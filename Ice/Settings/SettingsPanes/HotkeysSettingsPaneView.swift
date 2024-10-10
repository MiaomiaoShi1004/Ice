//
//  HotkeysSettingsPane.swift
//  Ice
//

import SwiftUI

struct HotkeysSettingsPaneView: View {
    @EnvironmentObject var appState: AppState
    @State private var hotkeyActions: [HotkeyItem] = [HotkeyItem(action: .tempShowSelectedItem)]
    @ObservedObject var tempShowAppManager = TempShowAppManager()
    private var hotkeySettingsManager: HotkeySettingsManager {
        appState.settingsManager.hotkeySettingsManager
    }

    var body: some View {
        IceForm {
            IceSection("Menu Bar Sections") {
                hotkeyRecorder(forSection: .hidden)
                hotkeyRecorder(forSection: .alwaysHidden)
            }
            IceSection("Menu Bar Items") {
                hotkeyRecorder(forAction: .searchMenuBarItems)
            }
            IceSection("Other") {
                hotkeyRecorder(forAction: .toggleApplicationMenus)
                hotkeyRecorder(forAction: .showSectionDividers)
            }
            IceSection("Temporarily show individual menu bar items") {
                ForEach(hotkeyActions) { hotkeyItem in
                    hotkeyRecorder(forAction: hotkeyItem.action)
                }
            } footer: {
                HStack {
                    Spacer()
                    Button("Add in item") {
                        // Add a new unique item
                        hotkeyActions.append(HotkeyItem(action: .tempShowSelectedItem))
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    @ViewBuilder
    private func hotkeyRecorder(forAction action: HotkeyAction) -> some View {
        if let hotkey = hotkeySettingsManager.hotkey(withAction: action) {
            HotkeyRecorderView(hotkey: hotkey) {
                switch action {
                case .toggleHiddenSection:
                    Text("Toggle the hidden section")
                case .toggleAlwaysHiddenSection:
                    Text("Toggle the always-hidden section")
                case .toggleApplicationMenus:
                    Text("Toggle application menus")
                case .showSectionDividers:
                    Text("Show section dividers")
                case .searchMenuBarItems:
                    Text("Search menu bar items")
                case .tempShowSelectedItem:
                    HStack {
                        Image(systemName: "house")
                        Text("displayAppName")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func hotkeyRecorder(forSection name: MenuBarSection.Name) -> some View {
        if appState.menuBarManager.section(withName: name)?.isEnabled == true {
            if case .hidden = name {
                hotkeyRecorder(forAction: .toggleHiddenSection)
            } else if case .alwaysHidden = name {
                hotkeyRecorder(forAction: .toggleAlwaysHiddenSection)
            }
        }
    }
}
