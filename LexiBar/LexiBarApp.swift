//
//  LexiBarApp.swift
//  LexiBar
//
//  Created by Andrey Pudov on 19/05/2026.
//

import SwiftUI

@main
struct LexiBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
