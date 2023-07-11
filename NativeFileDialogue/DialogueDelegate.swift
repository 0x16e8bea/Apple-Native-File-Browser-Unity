import Foundation
import AppKit

class DialogueDelegate: NSObject, NSOpenSavePanelDelegate {
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        // Get the file extension
        let ext = url.pathExtension.lowercased()
        // Define a set of allowed extensions
        let allowedExtensions = ["txt", "md", "pdf"]
        // Return true if the extension is in the set, false otherwise
        return allowedExtensions.contains(ext)
    }
}
