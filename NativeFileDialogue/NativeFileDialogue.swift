import AppKit

@_cdecl("DialogHandler_openFile")
public func openFile(title: UnsafePointer<CChar>? = nil, _ directory: UnsafePointer<CChar>? = nil, _ extension: UnsafePointer<CChar>? = nil, _ multiselect: Bool = false) -> UnsafePointer<CChar>? {
    let dialog = NSOpenPanel()
    
    dialog.canChooseFiles = true
    dialog.canChooseDirectories = false
    dialog.allowsMultipleSelection = multiselect
    
    if let title = title {
        let titleString = String(cString: title)
        dialog.message = titleString
    }
    
    if let `extension` = `extension` {
        let extensionString = String(cString: `extension`);
        dialog.allowedFileTypes = [extensionString];
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
    
    dialog.canCreateDirectories = true
    
    if let title = title {
        let titleString = String(cString: title)
        dialog.message = titleString
    }
    
    if let `extension` = `extension` {
        let extensionString = String(cString: `extension`);
        dialog.allowedFileTypes = [extensionString];
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

