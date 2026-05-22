import AVFoundation
import Foundation
import NaturalLanguage

final class VocabularySpeaker {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var originalLanguageCode = "en-US"
    private var translationLanguageCode = "en-US"

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
    }

    func speak(entry: VocabularyEntry) {
        speechSynthesizer.stopSpeaking(at: .immediate)

        let originalUtterance = makeUtterance(
            text: entry.original,
            languageCode: originalLanguageCode
        )
        speechSynthesizer.speak(originalUtterance)

        let translationUtterance = makeUtterance(
            text: entry.translation,
            languageCode: translationLanguageCode,
            preUtteranceDelay: 0.25
        )
        speechSynthesizer.speak(translationUtterance)
    }

    private func detectLanguageCode(for text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        return recognizer.dominantLanguage?.rawValue ?? "en-US"
    }

    private func makeUtterance(
        text: String,
        languageCode: String,
        preUtteranceDelay: TimeInterval = 0
    ) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.preUtteranceDelay = preUtteranceDelay

        if let voice = preferredVoice(for: languageCode) {
            utterance.voice = voice
        }

        return utterance
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
