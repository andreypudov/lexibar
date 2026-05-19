//
//  AppDelegate.swift
//  LexiBar
//
//  Created by Andrey Pudov on 19/05/2026.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var Timer: timer?

    let words = [
        "猫 — ねこ — cat",
        "犬 — いぬ — dog",
        "水 — みず — water",
        "空 — そら — sky"
    ]
    var index = 0

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateMenuBarText()

        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.updateMenuBarText()
        }
    }

    func updateMenuBarText() {
        index = (index + 1) % words.count
        statusItem.button?.title = words[index]
    }
}
