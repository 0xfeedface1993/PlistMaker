//
//  ContentView.swift
//  PlistMake
//
//  Created by john on 2023/3/14.
//  Copyright © 2023 ascp. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var configs = [PlistConfig]()
    @State private var selectConfig: PlistConfig?
    
    @State var bundleIdentifier: String = ""
    @State var imageName: String = ""
    @State var appName: String = ""
    @State var ipaPath: String = ""
    @State var imagePath: String = ""
    
    @State var image: NSImage?
    
    var disbaleButton: Bool {
        bundleIdentifier.isEmpty ||
        imageName.isEmpty ||
        appName.isEmpty ||
        ipaPath.isEmpty ||
        imagePath.isEmpty ||
        image == nil
    }
    
    var body: some View {
        if #available(macOS 13.0, *) {
            NavigationSplitView(sidebar: listView, detail: detailView)
                .onAppear(perform: appearAction)
        } else {
            // Fallback on earlier versions
            HSplitView {
                listView()
                detailView()
            }
            .onAppear(perform: appearAction)
        }
    }
    
    @ViewBuilder private func listView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(configs, id: \.id) { value in
                    HStack {
                        Spacer()
                        Text(value.title)
                            .foregroundColor(value.titleColor)
                        Spacer()
                    }
                    .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .background(value.backgroundColor)
                }
            }
        }
    }
    
    @ViewBuilder private func detailView() -> some View {
        if let item = selectConfig {
            HStack(alignment: .top) {
                VStack {
                    TextField("包名(Bundle Identifier)", text: $bundleIdentifier)
                    TextField("图片名", text: $imageName)
                    TextField("应用名称", text: $appName)
                    TextField("服务器ipa文件夹路径", text: $ipaPath)
                    TextField("服务器图片文件夹路径", text: $imagePath)
                }
                
                VStack {
                    imageView()
                    Button(action: export) {
                        Text(item.exportTitle)
                    }
                    .disabled(disbaleButton)
                }
                .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            .padding(.init(top: 4, leading: 4, bottom: 2, trailing: 4))
        }   else    {
            Text("请选择操作类别")
                .font(.largeTitle)
        }
    }
    
    @ViewBuilder private func imageView() -> some View {
        if let image = image {
            Image(nsImage: image)
                .resizable()
                .frame(width: 120, height: 120)
                .onDrop(of: ["public.file-url"], delegate: ImageDropDelegate(iconImage: $image))
        }   else    {
            Text("Add")
                .frame(width: 120, height: 120)
                .onDrop(of: ["public.file-url"], delegate: ImageDropDelegate(iconImage: $image))
        }
    }
    
    private func appearAction() {
        configs = [.init("企业版plist导出")]
        selectConfig = configs.first
        selectConfig?.updateState(true)
    }
    
    private func export() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
