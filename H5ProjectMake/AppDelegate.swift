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
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        let window = NSApplication.shared.windows.first?.windowController
        if let flag = window?.window?.isVisible, !flag {
            window?.showWindow(nil)
        }
    }
}

