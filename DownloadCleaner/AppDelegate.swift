//
//  AppDelegate.swift
//  DownloadCleaner
//
//  Created by Marc Roberts on 21/05/2018.
//  Copyright © 2018. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let fileProperties = Set(arrayLiteral: URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.contentModificationDateKey, URLResourceKey.localizedTypeDescriptionKey, URLResourceKey.isDirectoryKey)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let activity = NSBackgroundActivityScheduler(identifier: "DownloadCleaner.DeleteTask")
        activity.repeats = true
        activity.interval = 60 * 60
        activity.tolerance = 10 * 60
        
        activity.schedule() { (completion: NSBackgroundActivityScheduler.CompletionHandler) in
            // Perform the activity
            completion(NSBackgroundActivityScheduler.Result.finished)
        }
        
        let fileManager = FileManager.default
        let downloadsURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        do {
            let enumerator = try fileManager.contentsOfDirectory(at: downloadsURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles] )
            var deleted = 0
            let oldest = Date.init(timeIntervalSinceNow: -30*86400) // 30 days in seconds
            
            for case let fileURL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: fileProperties)
                if (oldest > resourceValues.creationDate!) {
                    deleted += 1
                }
            }
            print("Deleted \(deleted) files odler than \(oldest)")
            
        } catch {
            print("Error while enumerating files \(downloadsURL): \(error.localizedDescription)")
        }
        
        
        
        
        
        let files =  fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first! as NSURL


    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

