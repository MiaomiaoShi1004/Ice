//
//  TempShowAppManager.swift
//  Ice
//
//  Created by Miaomiao Shi on 03/10/2024.
//

import Combine
import Foundation
import AppKit

class TempShowAppManager: ObservableObject {
    @Published var tempShowApps: [AppItem] = []

    func addItemFromFilePicker() {
        let dialog = NSOpenPanel()
        dialog.title = "Select an Application"
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedContentTypes = [.application]
        if dialog.runModal() == .OK {
            if let result = dialog.url {
                let appName = result.lastPathComponent
                // NSWorkspace.shared.icon(forFile:) always returns an image, so we can use it directly
                let appIcon = NSWorkspace.shared.icon(forFile: result.path)
                
                let newItem = AppItem(appIcon: appIcon, name: appName)
                addItem(item: newItem)
            }
        }
    }

    func addItem(item: AppItem) {
        tempShowApps.append(item)
    }

    func deleteItem(_ item: AppItem) {
        if let index = tempShowApps.firstIndex(where: { $0.id == item.id }) {
            tempShowApps.remove(at: index)
        }
    }

    func deleteItems(at offsets: IndexSet) {
        tempShowApps.remove(atOffsets: offsets)
    }
}
