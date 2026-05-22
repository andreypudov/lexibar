import Foundation

class AppSettings {
    static let shared = AppSettings()

    private enum Keys {
        static let wordInterval = "wordInterval"
    }

    private enum Defaults {
        static let wordInterval: TimeInterval = 8
    }

    var wordInterval: TimeInterval {
        get {
            let stored = UserDefaults.standard.double(forKey: Keys.wordInterval)
            return stored > 0 ? stored : Defaults.wordInterval
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.wordInterval)
        }
    }
}
