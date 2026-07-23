import SwiftUI
import Speech
import AVFoundation

// MARK: - Vue diction avec reconnaissance vocale
struct DictionView: View {
    @ObservedObject var vm: LearningSessionVM
    let exercise: CurriculumExercise

    @StateObject private var recognizer = SpeechRecognizer()
    @State private var phase: DictionPhase = .listening
    @State private var attempts = 0

    enum DictionPhase {
        case intro, listening, analyzing, result(Bool)
    }

    var body: some View {
        VStack(spacing: 24) {
            // Grande image illustrative
            Text(exercise.emoji)
                .font(.system(size: 80))
                .padding(20)
                .background(Color("accentPurple").opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 24))

            // Mot / phrase à prononcer
            VStack(spacing: 8) {
                Text("Dis à voix haute :")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("textSecondary"))
                Text(exercise.expectedAnswer)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color("textPrimary"))
                    .multilineTextAlignment(.center)
            }

            // Zone d'écoute
            switch phase {
            case .intro:
                introPhase
            case .listening:
                listeningPhase
            case .analyzing:
                analyzingPhase
            case .result(let correct):
                resultPhase(correct: correct)
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            // Léa dit d'abord le mot, puis demande à l'enfant
            vm.speak(exercise.characterSays)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                phase = .listening
            }
        }
        .onDisappear { recognizer.stop() }
    }

    // MARK: - Phases

    private var introPhase: some View {
        VStack(spacing: 12) {
            Text("Écoute bien...")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textSecondary"))
            WaveformAnimation(isActive: true, color: Color("accentPurple"))
                .frame(height: 48)
        }
    }

    private var listeningPhase: some View {
        VStack(spacing: 16) {
            // Transcription en temps réel
            if !recognizer.transcript.isEmpty {
                Text(recognizer.transcript)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("accentPurple"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color("accentPurple").opacity(0.08))
                    .cornerRadius(12)
            }

            // Onde sonore animée
            WaveformAnimation(isActive: recognizer.isRecording, color: Color("accentGreen"))
                .frame(height: 56)

            if recognizer.isRecording {
                Text("Je t'écoute... 🎤")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("accentGreen"))
            }

            HStack(spacing: 16) {
                // Bouton micro
                Button {
                    if recognizer.isRecording {
                        recognizer.stop()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            analyzeResult()
                        }
                    } else {
                        recognizer.start()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(recognizer.isRecording
                                  ? Color("accentGreen") : Color("accentPurple"))
                            .frame(width: 72, height: 72)
                            .shadow(color: (recognizer.isRecording
                                           ? Color("accentGreen") : Color("accentPurple"))
                                    .opacity(0.4), radius: 8, y: 4)
                        Image(systemName: recognizer.isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(recognizer.isRecording ? 1.12 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                           .delay(0), value: recognizer.isRecording)

                if !recognizer.isRecording && attempts > 0 {
                    Button {
                        phase = .result(false)
                        vm.confirmRepeated() // auto-valider après essais
                    } label: {
                        Text("Passer ›")
                            .font(.system(size: 15))
                            .foregroundColor(Color("textSecondary"))
                    }
                }
            }

            Text(recognizer.isRecording
                 ? "Appuie sur ■ quand tu as fini"
                 : "Appuie sur le micro pour parler")
                .font(.system(size: 13))
                .foregroundColor(Color("textSecondary"))
        }
    }

    private var analyzingPhase: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
            Text("J'analyse ta voix...")
                .font(.system(size: 16))
                .foregroundColor(Color("textSecondary"))
        }
        .frame(height: 80)
    }

    private func resultPhase(correct: Bool) -> some View {
        VStack(spacing: 16) {
            Text(correct ? "🎉" : "💪")
                .font(.system(size: 56))
            Text(correct
                 ? "Bravo ! Tu as bien dit \"\(exercise.expectedAnswer)\" !"
                 : "Encore un essai ! Écoute bien : \"\(exercise.expectedAnswer)\"")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textPrimary"))
                .multilineTextAlignment(.center)

            if !correct && attempts < 3 {
                Button {
                    recognizer.transcript = ""
                    phase = .listening
                } label: {
                    Label("Réessayer", systemImage: "mic.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color("accentPurple"))
                        .cornerRadius(14)
                }
            }

            if correct || attempts >= 3 {
                Button {
                    vm.nextExercise()
                } label: {
                    Text("Exercice suivant →")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 13)
                        .background(Color("accentGreen"))
                        .cornerRadius(14)
                }
            }
        }
    }

    // MARK: - Analyse

    private func analyzeResult() {
        phase = .analyzing
        attempts += 1
        let heard   = normalize(recognizer.transcript)
        let expected = normalize(exercise.expectedAnswer)
        let correct = similarity(heard, expected) >= 0.65

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            phase = .result(correct)
            if correct {
                vm.totalAnswers += 1
                vm.correctAnswers += 1
                vm.starsEarned += 1
                vm.leo.speak(context: .correct(streak: 1))
            } else {
                vm.leo.speakText("Tu as dit \(recognizer.transcript.isEmpty ? "rien" : recognizer.transcript). Écoute bien et réessaie.")
                vm.speak(exercise.expectedAnswer)
            }
        }
    }

    private func normalize(_ s: String) -> String {
        s.lowercased()
         .trimmingCharacters(in: .whitespacesAndNewlines)
         .folding(options: .diacriticInsensitive, locale: .current)
         .components(separatedBy: CharacterSet.letters.inverted).joined(separator: " ")
         .components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: " ")
    }

    private func similarity(_ a: String, _ b: String) -> Double {
        if a == b { return 1.0 }
        let wa = Set(a.components(separatedBy: " ").filter { !$0.isEmpty })
        let wb = Set(b.components(separatedBy: " ").filter { !$0.isEmpty })
        guard !wb.isEmpty else { return 0 }
        return Double(wa.intersection(wb).count) / Double(wb.count)
    }
}

// MARK: - Moteur de reconnaissance vocale
@MainActor
class SpeechRecognizer: ObservableObject {
    @Published var transcript = ""
    @Published var isRecording = false

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var recognizer: SFSpeechRecognizer?

    init() {
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "fr-FR"))
        SFSpeechRecognizer.requestAuthorization { _ in }
    }

    func start() {
        guard !isRecording else { return }
        transcript = ""

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let req = recognitionRequest else { return }
        req.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        recognitionTask = recognizer?.recognitionTask(with: req) { [weak self] result, error in
            guard let self else { return }
            if let result {
                Task { @MainActor in
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal == true) {
                Task { @MainActor in self.stop() }
            }
        }

        let fmt = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: fmt) { [weak self] buf, _ in
            self?.recognitionRequest?.append(buf)
        }

        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}

// MARK: - Animation onde sonore
struct WaveformAnimation: View {
    let isActive: Bool
    let color: Color
    @State private var phases: [CGFloat] = [0, 0.3, 0.6, 0.9, 1.2, 0.9, 0.6, 0.3, 0]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<9) { i in
                RoundedRectangle(cornerRadius: 3)
                    .fill(color.opacity(0.8))
                    .frame(width: 5, height: isActive ? max(8, phases[i] * 44) : 8)
                    .animation(
                        isActive
                            ? .easeInOut(duration: Double.random(in: 0.25...0.5))
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.06)
                            : .easeOut(duration: 0.2),
                        value: isActive
                    )
            }
        }
        .onAppear {
            if isActive { animateWave() }
        }
        .onChange(of: isActive) { _, active in
            if active { animateWave() }
        }
    }

    private func animateWave() {
        guard isActive else { return }
        phases = (0..<9).map { _ in CGFloat.random(in: 0.15...1.0) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if isActive { animateWave() }
        }
    }
}
