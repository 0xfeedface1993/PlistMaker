//
//  DestinationView.swift
//  H5ProjectMake
//
//  Created by virus1993 on 2017/12/20.
//  Copyright © 2017年 ascp. All rights reserved.
//

import Cocoa

class DestinationView: NSImageView {
    var isImageFile : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([NSPasteboard.PasteboardType.tiff, NSPasteboard.PasteboardType.png])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let data = sender.draggingPasteboard.data(forType: NSPasteboard.PasteboardType.fileURL), let url = URL(dataRepresentation: data, relativeTo: nil), let _ = NSImage(contentsOf: url) {
            isImageFile = true
            return true
        }
        isImageFile = false
        return false
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if let data = sender.draggingPasteboard.data(forType: NSPasteboard.PasteboardType.fileURL), let url = URL(dataRepresentation: data, relativeTo: nil), let _ = NSImage(contentsOf: url) {
            isImageFile = true
            return .copy
        }
        isImageFile = false
        return .generic
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        if let data = sender.draggingPasteboard.data(forType: NSPasteboard.PasteboardType.fileURL), let url = URL(dataRepresentation: data, relativeTo: nil), let img = NSImage(contentsOf: url) {
            image = img
            popImageAnimation()
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isImageFile = false
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let data = sender.draggingPasteboard.data(forType: NSPasteboard.PasteboardType.fileURL), let url = URL(dataRepresentation: data, relativeTo: nil), let _ = NSImage(contentsOf: url) {
            return true
        }
        return false
    }
    
    func popImageAnimation() {
        layer?.masksToBounds = true
        let xOffset = CABasicAnimation(keyPath: "cornerRadius")
        xOffset.fromValue = 0
        xOffset.toValue = 50
        xOffset.duration = 0.35
        xOffset.beginTime = CACurrentMediaTime()
        xOffset.fillMode = CAMediaTimingFillMode.forwards
        xOffset.isRemovedOnCompletion = false
        layer?.add(xOffset, forKey: xOffset.keyPath!)
    }
}

