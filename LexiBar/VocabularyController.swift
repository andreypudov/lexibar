import Foundation

class VocabularyController {
    private var entries: [VocabularyEntry] = []
    private var index = -1

    var allEntries: [VocabularyEntry] {
        entries
    }

    var currentEntry: VocabularyEntry? {
        guard index >= 0, index < entries.count else { return nil }
        return entries[index]
    }

    func next() -> String {
        guard !entries.isEmpty else { return "LexiBar: Hello!" }
        index = (index + 1) % entries.count
        return entries[index].displayText
    }

    func load(from url: URL) {
        let loaded = VocabularyLoader.load(from: url)
        guard !loaded.isEmpty else { return }
        entries = loaded
        index = -1
    }
}
