//
//  PlistConfig.swift
//  PlistMake
//
//  Created by john on 2023/3/14.
//  Copyright © 2023 ascp. All rights reserved.
//

import SwiftUI

final class PlistConfig: ObservableObject, Identifiable {
    let id = UUID()
    @Published var title: String
    @Published var titleColor: Color = .clear
    @Published var backgroundColor: Color = .clear
    
    @Published var exportDisable = false
    @Published var exportTitle = "导出"
    
    init(_ title: String) {
        self.title = title
    }
    
    func updateState(_ state: Bool) {
        titleColor = titleColor(for: state)
        backgroundColor = backgroundColor(for: state)
    }
    
    func titleColor(for selected: Bool) -> Color {
        !selected ? Color("normal_color"):Color("selected_color")
    }
    
    func backgroundColor(for selected: Bool) -> Color {
        selected ? Color("normal_color").opacity(0.25):.clear
    }
}

struct ImageDropDelegate: DropDelegate {
    @Binding var iconImage: NSImage?
    
    func performDrop(info: DropInfo) -> Bool {
        if info.hasItemsConforming(to: ["public.file-url"]) {
            guard let provider = info.itemProviders(for: ["public.file-url"]).first else {
                return false
            }
            provider.loadDataRepresentation(forTypeIdentifier: "public.file-url") {  data, error in
                guard let data = data, let url = URL(dataRepresentation: data, relativeTo: nil) else {
                    return
                }
                iconImage = NSImage(contentsOf: url)
            }
            return true
        }
        return false
    }
    
    func dropEntered(info: DropInfo) {
        
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        .init(operation: info.hasItemsConforming(to: [.fileURL]) ? .copy:.cancel)
    }
    
    func dropExited(info: DropInfo) {
        //iconImage = NSImage(named: "Add")?.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
