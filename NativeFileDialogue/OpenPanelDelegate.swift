import Foundation
import AppKit

class OpenPanelDelegate: NSObject, NSOpenSavePanelDelegate {
    let allowedExtensions: [String]

    init(allowedExtensions: [String]) {
        self.allowedExtensions = allowedExtensions
    }

    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                // Always enable directories so they can be navigated
                return true
            } else {
                // Enable files if their extension is allowed
                return allowedExtensions.contains(url.pathExtension)
            }
        } else {
            // The item does not exist, don't enable it
            return false
        }
    }
}
