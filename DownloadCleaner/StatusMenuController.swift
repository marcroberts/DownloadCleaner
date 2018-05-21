//
//  StatusMenuController.swift
//  DownloadCleaner
//
//  Created by Marc Roberts on 21/05/2018.
//  Copyright © 2018. All rights reserved.
//

import Cocoa

extension NSImage.Name {
    static let statusIcon = NSImage.Name("statusIcon")
}

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: .statusIcon)
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
