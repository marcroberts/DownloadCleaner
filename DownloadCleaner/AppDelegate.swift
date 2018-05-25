//
//  AppDelegate.swift
//  DownloadCleaner
//
//  Created by Marc Roberts on 21/05/2018.
//  Copyright © 2018. All rights reserved.
//

import Cocoa
import LoginServiceKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if !LoginServiceKit.isExistLoginItems(at: Bundle.main.bundlePath) {
            LoginServiceKit.addLoginItems(at: Bundle.main.bundlePath)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

