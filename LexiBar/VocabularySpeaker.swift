import AVFoundation
import Foundation
import NaturalLanguage

final class VocabularySpeaker {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var originalLanguageCode = "en-US"
    private var translationLanguageCode = "en-US"
    private var originalVoice = AVSpeechSynthesisVoice(language: "en-US")
    private var translationVoice = AVSpeechSynthesisVoice(language: "en-US")

    func stop() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }

    func configureLanguages(entries: [VocabularyEntry]) {
        let originalText = entries
            .map(\.original)
            .joined(separator: "\n")
        let translationText = entries
            .map(\.translation)
            .joined(separator: "\n")

        originalLanguageCode = detectLanguageCode(for: originalText)
        translationLanguageCode = detectLanguageCode(for: translationText)
        originalVoice = preferredVoice(for: originalLanguageCode)
        translationVoice = preferredVoice(for: translationLanguageCode)
    }

    func speak(entry: VocabularyEntry) {
        speechSynthesizer.stopSpeaking(at: .immediate)

        let originalUtterance = AVSpeechUtterance(string: entry.original)
        originalUtterance.voice = originalVoice
        speechSynthesizer.speak(originalUtterance)

        let translationUtterance = AVSpeechUtterance(string: entry.translation)
        translationUtterance.preUtteranceDelay = 0.25
        translationUtterance.voice = translationVoice
        speechSynthesizer.speak(translationUtterance)
    }

    private func detectLanguageCode(for text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        return recognizer.dominantLanguage?.rawValue ?? "en-US"
    }

    private func preferredVoice(for languageCode: String) -> AVSpeechSynthesisVoice? {
        if let exactVoice = AVSpeechSynthesisVoice(language: languageCode) {
            return exactVoice
        }

        let normalized = Locale(identifier: languageCode)
            .language
            .languageCode?
            .identifier

        guard let normalized else {
            return AVSpeechSynthesisVoice(language: "en-US")
        }

        let fallbackVoice = AVSpeechSynthesisVoice.speechVoices().first {
            Locale(identifier: $0.language)
                .language
                .languageCode?
                .identifier == normalized
        }

        return fallbackVoice ?? AVSpeechSynthesisVoice(language: "en-US")
    }
}
