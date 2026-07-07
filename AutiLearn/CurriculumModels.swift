import Foundation

// MARK: - Exercice pédagogique (nouveau modèle unifié)
struct CurriculumExercise {
    // Contenu commun
    let characterSays: String   // Léa lit ce texte à voix haute
    let prompt: String          // Instruction affichée à l'enfant
    let expectedAnswer: String
    let emoji: String           // Grande image illustrative
    let type: ExerciseMode
    let subject: CurriculumSubject
    let useGirl: Bool

    // Champs spécifiques selon le type
    let choices: [String]       // QCM : options de réponse
    let lessonTitle: String     // Cours : titre de la slide
    let lessonBody: String      // Cours : texte explicatif
    let blankSentence: String   // Trou : "Le ___ est rouge" → answer = "chat"
    let writingPrompt: String   // Écriture : "Écris le mot que tu entends"

    // Phase pédagogique dans la session
    let phase: SessionPhase

    enum SessionPhase {
        case lesson      // 📖 Cours illustré (pas d'évaluation)
        case practice    // ✏️ Pratique guidée
        case evaluation  // ✅ Évaluation
    }

    enum ExerciseMode: String {
        case lesson          = "lesson"       // 📖 Slide de cours narratif
        case repeatAfterMe   = "repeat"       // 🔊 Répéter oralement
        case diction         = "diction"      // 🎤 Parler dans le micro
        case writeWord       = "write"        // ✏️ Écrire un mot entier
        case fillBlank       = "blank"        // 🔤 Compléter un trou
        case multipleChoice  = "qcm"          // ✅ Choisir parmi 4 options
        case answerQuestion  = "answer"       // Compatibilité ancien code
        case writeResponse   = "writeResp"    // Compatibilité
    }

    enum CurriculumSubject: String {
        case oral, reading, writing, math, science, social, arts, nature, history
    }

    // MARK: - Initialiseur simplifié pour les cours
    static func lesson(
        emoji: String, title: String, body: String,
        narration: String, subject: CurriculumSubject = .oral
    ) -> CurriculumExercise {
        CurriculumExercise(
            characterSays: narration, prompt: "", expectedAnswer: "",
            emoji: emoji, type: .lesson, subject: subject, useGirl: true,
            choices: [], lessonTitle: title, lessonBody: body,
            blankSentence: "", writingPrompt: "", phase: .lesson
        )
    }

    // Initialiseur complet
    init(characterSays: String, prompt: String, expectedAnswer: String,
         emoji: String, type: ExerciseMode, subject: CurriculumSubject,
         useGirl: Bool, choices: [String] = [], lessonTitle: String = "",
         lessonBody: String = "", blankSentence: String = "",
         writingPrompt: String = "", phase: SessionPhase = .evaluation) {
        self.characterSays = characterSays
        self.prompt = prompt
        self.expectedAnswer = expectedAnswer
        self.emoji = emoji
        self.type = type
        self.subject = subject
        self.useGirl = useGirl
        self.choices = choices
        self.lessonTitle = lessonTitle
        self.lessonBody = lessonBody
        self.blankSentence = blankSentence
        self.writingPrompt = writingPrompt
        self.phase = phase
    }
}
