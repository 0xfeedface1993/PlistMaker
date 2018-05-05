//
//  CustomWindowController.swift
//  PlistMake
//
//  Created by virus1994 on 2018/5/3.
//  Copyright © 2018年 ascp. All rights reserved.
//

import Cocoa

class CustomWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    @IBAction func generation(_ sender: Any) {
        findMaker().generation(self)
    }
    
    @IBAction func bundleIdentifier(_ sender: Any) {
        findMaker().bundleIdentifier.becomeFirstResponder()
    }
    
    @IBAction func imageNmae(_ sender: Any) {
        findMaker().imageName.becomeFirstResponder()
    }
    
    @IBAction func appNmae(_ sender: Any) {
        findMaker().appName.becomeFirstResponder()
    }
    
    @IBAction func ipa(_ sender: Any) {
        findMaker().ipaDirPath.becomeFirstResponder()
    }
    
    @IBAction func imageDir(_ sender: Any) {
        findMaker().imageDirPath.becomeFirstResponder()
    }
    
    func findMaker() -> PlistViewController {
        return contentViewController as! PlistViewController
    }
}
