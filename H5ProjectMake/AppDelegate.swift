//
//  AppDelegate.swift
//  H5ProjectMake
//
//  Created by virus1993 on 2017/12/19.
//  Copyright © 2017年 ascp. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        if let vc = NSApplication.shared.windows.first?.windowController?.contentViewController as? PlistViewController {
            vc.saveEditData()
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        let window = NSApplication.shared.windows.first?.windowController
        print("\(window?.window?.isVisible ?? false)")
        if let flag = window?.window?.isVisible, !flag {
            window?.showWindow(nil)
        }
    }
    
    @IBAction func reopen(_ sender: Any) {
        let window = NSApplication.shared.windows.first?.windowController
        window?.showWindow(nil)
    }
}

