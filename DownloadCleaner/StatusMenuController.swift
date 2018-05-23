//
//  StatusMenuController.swift
//  DownloadCleaner
//
//  Created by Marc Roberts on 21/05/2018.
//  Copyright © 2018. All rights reserved.
//

import os.log
import Cocoa

extension NSImage.Name {
    static let statusIcon = NSImage.Name("statusIcon")
}

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var lastRan: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let fileProperties = Set(arrayLiteral: URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.contentModificationDateKey, URLResourceKey.localizedTypeDescriptionKey, URLResourceKey.isDirectoryKey)
    
    override func awakeFromNib() {
        let icon = NSImage(named: .statusIcon)
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        trashFiles()
        
        let activity = NSBackgroundActivityScheduler(identifier: "DownloadCleaner.DeleteTask")
        activity.repeats = true
        activity.interval = 240 * 60
        activity.tolerance = 60 * 60
        
        activity.schedule() { (completion: NSBackgroundActivityScheduler.CompletionHandler) in
            
            self.trashFiles()
            
            completion(NSBackgroundActivityScheduler.Result.finished)
        }
    }
    
    private func trashFiles() {
        let fileManager = FileManager.default
        let downloadsURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        
        do {
            let enumerator = try fileManager.contentsOfDirectory(at: downloadsURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles] )
            var deleted = 0
            let oldest = Date.init(timeIntervalSinceNow: -30*86400) // 30 days in seconds
            
            for case let fileURL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: self.fileProperties)
                if (oldest > resourceValues.creationDate!) {
                    try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
                    deleted += 1
                }
            }
            
            NSLog("Deleted %d files older than %@", deleted, oldest.description)
            
            lastRan.title = "Last ran: \(dateFormatter.string(from: Date.init()))"
            
        } catch {
            NSLog("Error while enumerating files (%@): %@", downloadsURL.description, error.localizedDescription)
        }
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
