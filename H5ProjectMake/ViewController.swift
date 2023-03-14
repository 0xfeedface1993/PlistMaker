//
//  ViewController.swift
//  H5ProjectMake
//
//  Created by virus1993 on 2017/12/19.
//  Copyright © 2017年 ascp. All rights reserved.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hostingView = NSHostingView(rootView: ContentView())
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingView)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[a]|", metrics: nil, views: ["a": hostingView]) +
                                    NSLayoutConstraint.constraints(withVisualFormat: "V:|[a]|", metrics: nil, views: ["a": hostingView]))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

