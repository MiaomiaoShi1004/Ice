//
//  HotkeyAction.swift
//  Ice
//
import Foundation
import SwiftUI

enum HotkeyAction: String, Codable, CaseIterable {
    case toggleHiddenSection = "ToggleHiddenSection"
    case toggleAlwaysHiddenSection = "ToggleAlwaysHiddenSection"
    case toggleApplicationMenus = "ToggleApplicationMenus"
    case showSectionDividers = "ShowSectionDividers"
    case searchMenuBarItems = "SearchMenuBarItems"
    case tempShowSelectedItem = "TempShowSelectedItem"

    @MainActor
    func perform(appState: AppState) async {
        switch self {
        case .toggleHiddenSection:
            guard let section = appState.menuBarManager.section(withName: .hidden) else {
                return
            }
            section.toggle()
            // prevent the section from automatically rehiding after mouse movement
            if !section.isHidden {
                appState.preventShowOnHover()
            }
        case .toggleAlwaysHiddenSection:
            guard let section = appState.menuBarManager.section(withName: .alwaysHidden) else {
                return
            }
            section.toggle()
            // prevent the section from automatically rehiding after mouse movement
            if !section.isHidden {
                appState.preventShowOnHover()
            }
        case .toggleApplicationMenus:
            appState.menuBarManager.toggleApplicationMenus()
        case .showSectionDividers:
            appState.settingsManager.advancedSettingsManager.showSectionDividers.toggle()
        case .searchMenuBarItems:
            await appState.menuBarManager.searchPanel.toggle()
        case .tempShowSelectedItem:
            print("DEBUG: tempShowItemCase written here")
        }
    }
}

struct HotkeyItem: Identifiable {
    let id = UUID()  // Unique ID for each hotkey item
    let action: HotkeyAction
}

struct AppItem: Identifiable {
    let id = UUID()
    var appIcon: NSImage
    var name: String
}
