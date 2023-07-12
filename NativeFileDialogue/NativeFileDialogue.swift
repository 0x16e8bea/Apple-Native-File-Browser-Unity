import AppKit
import UniformTypeIdentifiers


@_cdecl("DialogHandler_openFile")
public func openFile(title: UnsafePointer<CChar>? = nil, _ directory: UnsafePointer<CChar>? = nil, _ extension: UnsafePointer<CChar>? = nil, _ multiselect: Bool = false) -> UnsafePointer<CChar>? {
    let dialog = NSOpenPanel()
    
    let playlistType = UTType(exportedAs: "com.ReplayInstitute.playlist",
                              conformingTo: .data) // or another appropriate parent UTType
    
    dialog.canChooseFiles = true
    dialog.canChooseDirectories = false
    dialog.allowsMultipleSelection = multiselect
    
    if let title = title {
        let titleString = String(cString: title)
        dialog.message = titleString
    }

    var allowedExtensions = [String]()
    if let `extension` = `extension` {
        let extensionString = String(cString: `extension`)
        // Split the string by pipe ('|') to get filter segments
        let filterSegments = extensionString.split(separator: "|")
        // For each filter segment
        for segment in filterSegments {
            // Split by semicolon (';') to separate filter name and extensions
            let parts = segment.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: true)
            // Handle the case when there's no name before ';'
            if parts.count == 1 {
                // Split extensions by comma (',')
                let extensions = parts[0].split(separator: ",")
                // Append extensions to the allowedTypes array
                for ext in extensions {
                    allowedExtensions.append(String(ext).replacingOccurrences(of: "*.", with: ""))
                }
            }
            else if parts.count > 1 {
                // Split extensions by comma (',')
                let extensions = parts[1].split(separator: ",")
                // Append extensions to the allowedTypes array
                for ext in extensions {
                    allowedExtensions.append(String(ext).replacingOccurrences(of: "*.", with: ""))
                }
            }
        }
    }

    let delegate = OpenPanelDelegate(allowedExtensions: allowedExtensions)
    dialog.delegate = delegate
    
    if let directory = directory {
        let directoryString = String(cString: directory)
        let expandedDirectoryString = (directoryString as NSString).expandingTildeInPath
        dialog.directoryURL = URL(fileURLWithPath: expandedDirectoryString, isDirectory: true)
    }
    
    if dialog.runModal() == NSApplication.ModalResponse.OK {
        if multiselect {
            let paths = dialog.urls.map { $0.path }
            let pathsString = paths.joined(separator: "\u{1C}") // Char 28 in Unicode is "\u{1C}"
            let mutablePointer = strdup(pathsString)
            return UnsafePointer(mutablePointer)
        } else {
            if let result = dialog.url {
                let path = result.path
                let mutablePointer = strdup(path)
                return UnsafePointer(mutablePointer)
            }
        }
    }
    
    return nil
}


@_cdecl("DialogHandler_openFolder")
public func openFolder(title: UnsafePointer<CChar>? = nil, _ directory: UnsafePointer<CChar>? = nil, _ multiselect: Bool = false) -> UnsafePointer<CChar>? {
    let dialog = NSOpenPanel()
    
    dialog.canChooseFiles = false
    dialog.canChooseDirectories = true
    dialog.allowsMultipleSelection = multiselect
    
    if let title = title {
        let titleString = String(cString: title)
        dialog.message = titleString
    }
    

    if let directory = directory {
        let directoryString = String(cString: directory)
        let expandedDirectoryString = (directoryString as NSString).expandingTildeInPath
        dialog.directoryURL = URL(fileURLWithPath: expandedDirectoryString, isDirectory: true)
    }
    
    if dialog.runModal() == NSApplication.ModalResponse.OK {
        if multiselect {
            let paths = dialog.urls.map { $0.path }
            let pathsString = paths.joined(separator: "\u{1C}") // Char 28 in Unicode is "\u{1C}"
            let mutablePointer = strdup(pathsString)
            return UnsafePointer(mutablePointer)
        } else {
            if let result = dialog.url {
                let path = result.path
                let mutablePointer = strdup(path)
                return UnsafePointer(mutablePointer)
            }
        }
    }
    
    return nil
}

@_cdecl("DialogHandler_saveFile")
public func saveFile(title: UnsafePointer<CChar>? = nil, _ directory: UnsafePointer<CChar>? = nil, _ defaultName: UnsafePointer<CChar>? = nil, _ extension: UnsafePointer<CChar>? = nil) -> UnsafePointer<CChar>? {
    let dialog = NSSavePanel()
    
    let playlistType = UTType(exportedAs: "com.ReplayInstitute.playlist",
                              conformingTo: .data) // or another appropriate parent UTType
    
    dialog.canCreateDirectories = true
    
    if let title = title {
        let titleString = String(cString: title)
        dialog.message = titleString
    }
    
    if let `extension` = `extension` {
        let extensionString = String(cString: `extension`)
        // Parse the extensions string in the same way as in openFile
        var allowedExtensions = [String]()
        let filterSegments = extensionString.split(separator: "|")
        for segment in filterSegments {
            let parts = segment.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: true)
            if parts.count == 1 {
                let extensions = parts[0].split(separator: ",")
                for ext in extensions {
                    allowedExtensions.append(String(ext).replacingOccurrences(of: "*.", with: ""))
                }
            }
            else if parts.count > 1 {
                let extensions = parts[1].split(separator: ",")
                for ext in extensions {
                    allowedExtensions.append(String(ext).replacingOccurrences(of: "*.", with: ""))
                }
            }
        }
        dialog.allowedFileTypes = allowedExtensions
    }

    if let defaultName = defaultName {
        let defaultNameString = String(cString: defaultName)
        dialog.nameFieldStringValue = defaultNameString
    }

    if let directory = directory {
        let directoryString = String(cString: directory)
        let expandedDirectoryString = (directoryString as NSString).expandingTildeInPath
        dialog.directoryURL = URL(fileURLWithPath: expandedDirectoryString, isDirectory: true)
    }
    
    if dialog.runModal() == NSApplication.ModalResponse.OK {
        if let result = dialog.url {
            let path = result.path
            let mutablePointer = strdup(path)
            return UnsafePointer(mutablePointer)
        }
    }
    
    return nil
}
