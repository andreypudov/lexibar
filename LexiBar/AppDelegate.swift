import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private let vocabularyController = VocabularyController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        setupMenu()
        showNextWord()

        timer = Timer.scheduledTimer(withTimeInterval: AppSettings.shared.wordInterval, repeats: true) { [weak self] _ in
            self?.showNextWord()
        }
    }

    private func setupMenu() {
        let menu = NSMenu()

        let openItem = NSMenuItem(
            title: "Open Vocabulary",
            action: #selector(openVocabulary),
            keyEquivalent: "o"
        )
        menu.addItem(openItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func openVocabulary() {
        let panel = NSOpenPanel()
        panel.title = "Open Vocabulary"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true

        if panel.runModal() == .OK, let url = panel.url {
            vocabularyController.load(from: url)
            showNextWord()
        }
    }

    private func showNextWord() {
        statusItem.button?.title = vocabularyController.next()
    }
}

