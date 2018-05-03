//
//  ImageHelper.swift
//  PlistMake
//
//  Created by virus1994 on 2018/5/3.
//  Copyright © 2018年 ascp. All rights reserved.
//

import Cocoa

func unscaledBitmapImageRep(forImage image: NSImage) -> NSBitmapImageRep {
    guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                     pixelsWide: Int(image.size.width),
                                     pixelsHigh: Int(image.size.height),
                                     bitsPerSample: 8,
                                     samplesPerPixel: 4,
                                     hasAlpha: true,
                                     isPlanar: false,
                                     colorSpaceName: .deviceRGB,
                                     bytesPerRow: 0,
                                     bitsPerPixel: 0) else { preconditionFailure() }
    
    rep.size = image.size
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    image.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1.0)
    NSGraphicsContext.restoreGraphicsState()
    
    return rep
}

func writeImage(image: NSImage,
                usingType type: NSBitmapImageRep.FileType,
                withSizeInPixels size: NSSize?,
                to url: URL) throws {
    if let size = size {
        image.size = size
    }
    
    let rep = unscaledBitmapImageRep(forImage: image)
    
    guard let data = rep.representation(using: type,
                                        properties: [.compressionFactor: 1.0]) else { preconditionFailure() }
    
    try data.write(to: url)
}
