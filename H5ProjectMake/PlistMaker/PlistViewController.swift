//
//  PlistViewController.swift
//  H5ProjectMake
//
//  Created by virus1993 on 2017/12/19.
//  Copyright © 2017年 ascp. All rights reserved.
//

import Cocoa
import CoreGraphics
import Quartz

//struct for PLists
struct DistrubitePlist: Codable {
    var items : [Item]
}

struct Item: Codable {
    var assets : [Asset]
    var metadata : Meta
}

struct Asset: Codable {
    var kind : String
    var url : String
    var shine : Bool?
    enum CodingKeys : String, CodingKey {
        case kind = "kind"
        case url = "url"
        case shine = "needs-shine"
    }
}

struct Meta : Codable {
    var identifier: String
    var version: String
    var kind: String
    var title: String
    enum CodingKeys : String, CodingKey {
        case identifier = "bundle-identifier"
        case version = "bundle-version"
        case kind = "kind"
        case title = "title"
    }
}

class PlistViewController: NSViewController {
    @IBOutlet weak var bundleIdentifier: NSTextField!
    @IBOutlet weak var imageName: NSTextField!
    @IBOutlet weak var appName: NSTextField!
    @IBOutlet weak var ipaDirPath: NSTextField!
    @IBOutlet weak var imageDirPath: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var generate: NSButton!
    
    lazy var emptyPlist : DistrubitePlist? = {
        let emptyPlistPath = Bundle.main.url(forResource: "empty", withExtension: "plist")
        do {
            let data = try Data.init(contentsOf: emptyPlistPath!, options: .mappedIfSafe)
            let decoder = PropertyListDecoder()
            let result = try decoder.decode(DistrubitePlist.self, from: data)
            return result
        } catch {
            print(error)
            return nil
        }
    }()
    
    private let defaultImage = #imageLiteral(resourceName: "Add")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        guard let plist = emptyPlist else { return }
        self.bundleIdentifier.stringValue = plist.items[0].metadata.identifier
        if let url = URL(string: plist.items[0].assets[1].url) {
            let name = String(url.lastPathComponent.split(separator: ".")[0])
            self.imageName.stringValue = String(name[name.startIndex..<name.index(before: name.endIndex)])
        }
        appName.stringValue = plist.items[0].metadata.title
        
        if let url = URL(string: plist.items[0].assets[0].url) {
            ipaDirPath.stringValue = url.deletingLastPathComponent().absoluteString
        }
        
        if let url = URL(string: plist.items[0].assets[1].url) {
            imageDirPath.stringValue = url.deletingLastPathComponent().absoluteString
        }
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    
    /// 生成图片和plist
    ///
    /// - Parameter sender: 参数
    @IBAction func generation(_ sender: Any) {
        let (isEmpty, message) = checkInput()
        if !isEmpty {
            let info = "信息有误、\(message ?? "")"
            let alert = NSAlert()
            alert.addButton(withTitle: "OK")
            alert.messageText = info
            alert.beginSheetModal(for: view.window!, completionHandler: { (res) in

            })
            return
        }
        
        let sps = self.bundleIdentifier.stringValue.split(separator: ".")
        guard sps.count >= 3  else {
            let info = "包名错误（示例 com.apple.imessage）"
            let alert = NSAlert()
            alert.addButton(withTitle: "OK")
            alert.messageText = info
            alert.beginSheetModal(for: view.window!, completionHandler: { (res) in
                
            })
            return
        }
        let fileName = String(sps[1])
        
        let panel = NSOpenPanel()
        panel.nameFieldLabel = "unsaved.plist"
        panel.message = "请选择plist文件的保存位置"
        panel.allowedFileTypes = ["plist", "png"]
        panel.allowsOtherFileTypes = false
        panel.isExtensionHidden = true
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.beginSheetModal(for: view.window!) { (res) in
            if res == .OK {
                var plist = self.emptyPlist!
                plist.items[0].metadata.identifier = self.bundleIdentifier.stringValue
                plist.items[0].metadata.title = self.appName.stringValue
                
                //
                let pathx = URL(string: self.ipaDirPath.stringValue)?.appendingPathComponent("\(fileName).ipa")
                plist.items[0].assets[0].url = pathx?.absoluteString ?? ""
                
                let simagePath = URL(string: self.imageDirPath.stringValue)?.appendingPathComponent("\(self.imageName.stringValue)s.png")
                let limagePath = URL(string: self.imageDirPath.stringValue)?.appendingPathComponent("\(self.imageName.stringValue)l.png")
                
                plist.items[0].assets[1].url = limagePath?.absoluteString ?? ""
                plist.items[0].assets[2].url = simagePath?.absoluteString ?? ""
                
                let pPath = panel.url!
                
                let localLargeImagePath = pPath.appendingPathComponent("\(self.imageName.stringValue)l.png")
                let localSmallImagePath = pPath.appendingPathComponent("\(self.imageName.stringValue)s.png")
                
                let encoder = PropertyListEncoder()
                do {
                    let data = try encoder.encode(plist)
                    try data.write(to: pPath.appendingPathComponent("\(fileName).plist"))
                    let images = self.ramden(image: self.imageView.image!)
                    let lData = images.l.tiffRepresentation!
                    let sData = images.s.tiffRepresentation!
                    try lData.write(to: localLargeImagePath)
                    try sData.write(to: localSmallImagePath)
                }   catch {
                    print(error)
                }
            }
        }
    }
    
    
    /// 检查输入
    ///
    /// - Returns: 空返回false，并带有提示信息
    func checkInput() -> (Bool, String?) {
        var pack : (Bool, String?) = (true, nil)
        if bundleIdentifier.stringValue.count <= 0 {
            shakeAnimate(v: bundleIdentifier)
            pack = (false, "包名未填写")
        }
        if imageName.stringValue.count <= 0 {
            shakeAnimate(v: imageName)
            pack = (false, "图片名未填写")
        }
        if appName.stringValue.count <= 0 {
            shakeAnimate(v: appName)
            pack = (false, "应用名未填写")
        }
        if ipaDirPath.stringValue.count <= 0 {
            shakeAnimate(v: ipaDirPath)
            pack = (false, "ipa文件夹路径未填写")
        }
        if imageDirPath.stringValue.count <= 0 {
            shakeAnimate(v: imageDirPath)
            pack = (false, "图片文件夹未填写")
        }
        
        if defaultImage.isEqual(to: imageView.image) {
            shakeAnimate(v: imageView)
            pack = (false, "图片未添加")
        }
        return pack
    }
    
    struct ImageSize {
        static let large : (CGFloat, CGFloat) = (512.0, 512.0)
        static let small : (CGFloat, CGFloat) = (58.0, 58.0)
    }
    
    
    /// 生成大小图片
    ///
    /// - Parameter image: 图标
    /// - Returns: l为大图，s为小图
    func ramden(image: NSImage) -> (l: NSImage, s: NSImage) {
        let largeRect = NSRect(x: 0, y: 0, width: ImageSize.large.0, height: ImageSize.large.1)
        let smallRect = NSRect(x: 0, y: 0, width: ImageSize.small.0, height: ImageSize.small.1)
        
        let lImage = NSImage(size: largeRect.size)
        lImage.lockFocus()
        image.draw(in: largeRect, from: NSZeroRect, operation: .copy, fraction: 1.0, respectFlipped: true, hints: nil)
        lImage.unlockFocus()
        
        let sImage = NSImage(size: smallRect.size)
        sImage.lockFocus()
        image.draw(in: smallRect, from: NSZeroRect, operation: .copy, fraction: 1.0, respectFlipped: true, hints: nil)
        sImage.unlockFocus()
        return (lImage, sImage)
    }

    
    /// 抖动动画
    ///
    /// - Parameter v: 需要抖动的视图，IB生成的需要开启Core Animation Layer
    func shakeAnimate(v : NSView) {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        if v.layer == nil {
            v.layer = v.makeBackingLayer()
        }
        let point = v.layer!.position;
        keyFrame.values = [CGPoint(x: point.x, y: point.y),
                           CGPoint(x: point.x - 10, y: point.y),
                           CGPoint(x: point.x + 10, y: point.y),
                           CGPoint(x: point.x - 10, y: point.y),
                           CGPoint(x: point.x + 10, y: point.y),
                           CGPoint(x: point.x - 10, y: point.y),
                           CGPoint(x: point.x + 10, y: point.y), point]
        keyFrame.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        keyFrame.duration = 0.5
        v.layer?.add(keyFrame, forKey: keyFrame.keyPath!)
    }
}

