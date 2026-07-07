import SwiftData
import Foundation

// MARK: - Profil Enfant
@Model
class ChildProfile {
    var id: UUID
    var firstName: String
    var avatarName: String          // nom de l'avatar choisi
    var schoolLevel: SchoolLevel
    var communicationLevel: CommunicationLevel
    var teacherAvatarName: String   // prof ABA choisi par les parents
    var teacherAvatarVoice: String  // voix AVSpeech
    var createdAt: Date
    var lastActiveAt: Date
    var totalStars: Int             // monnaie de récompense
    var currentStreak: Int          // jours consécutifs
    var reminderHour: Int
    var reminderEnabled: Bool

    @Relationship(deleteRule: .cascade) var sessions: [LearningSession]
    @Relationship(deleteRule: .cascade) var wordProgresses: [WordProgress]
    @Relationship(deleteRule: .cascade) var weeklyReports: [WeeklyReport]

    init(firstName: String, avatarName: String = "avatar_star",
         schoolLevel: SchoolLevel = .level0,
         communicationLevel: CommunicationLevel = .emerging) {
        self.id = UUID()
        self.firstName = firstName
        self.avatarName = avatarName
        self.schoolLevel = schoolLevel
        self.communicationLevel = communicationLevel
        self.teacherAvatarName = "teacher_luna"
        self.teacherAvatarVoice = "fr-FR"
        self.createdAt = Date()
        self.lastActiveAt = Date()
        self.totalStars = 0
        self.currentStreak = 0
        self.reminderHour = 10
        self.reminderEnabled = true
        self.sessions = []
        self.wordProgresses = []
        self.weeklyReports = []
    }
}

// MARK: - Niveaux scolaires
enum SchoolLevel: String, Codable, CaseIterable {
    case level0 = "maternelle"
    case level1 = "cp_ce1"
    case level2 = "ce2_cm2"
    case level3 = "college"

    var displayName: String {
        switch self {
        case .level0: return "Maternelle"
        case .level1: return "CP – CE1"
        case .level2: return "CE2 – CM2"
        case .level3: return "Collège"
        }
    }

    var emoji: String {
        switch self {
        case .level0: return "🌱"
        case .level1: return "📖"
        case .level2: return "✏️"
        case .level3: return "🎓"
        }
    }

    var color: String {
        switch self {
        case .level0: return "levelPurple"
        case .level1: return "levelGreen"
        case .level2: return "levelBlue"
        case .level3: return "levelOrange"
        }
    }

    var description: String {
        switch self {
        case .level0: return "3 – 5 ans · Premiers mots et sons"
        case .level1: return "6 – 7 ans · Lecture et écriture"
        case .level2: return "8 – 10 ans · Phrases complètes"
        case .level3: return "11 – 14 ans · Expression avancée"
        }
    }
}

// MARK: - Niveau de communication
enum CommunicationLevel: String, Codable, CaseIterable {
    case preverbal      = "preverbal"       // pas de mots
    case emerging       = "emerging"        // quelques mots
    case functional     = "functional"      // phrases courtes
    case conversational = "conversational"  // conversations simples

    var displayName: String {
        switch self {
        case .preverbal:      return "Pré-verbal"
        case .emerging:       return "Langage émergent"
        case .functional:     return "Langage fonctionnel"
        case .conversational: return "Conversationnel"
        }
    }
}

// MARK: - Session d'apprentissage
@Model
class LearningSession {
    var id: UUID
    var date: Date
    var durationSeconds: Int
    var moduleType: ModuleType
    var starsEarned: Int
    var wordsStudied: Int
    var correctAnswers: Int
    var totalAnswers: Int
    var emotionAtStart: EmotionState
    var completed: Bool

    var successRate: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }

    init(moduleType: ModuleType, emotionAtStart: EmotionState = .happy) {
        self.id = UUID()
        self.date = Date()
        self.durationSeconds = 0
        self.moduleType = moduleType
        self.starsEarned = 0
        self.wordsStudied = 0
        self.correctAnswers = 0
        self.totalAnswers = 0
        self.emotionAtStart = emotionAtStart
        self.completed = false
    }
}

enum ModuleType: String, Codable {
    case vocabulary     = "vocabulaire"
    case reading        = "lecture"
    case numbers        = "chiffres"
    case diction        = "diction"
    case story          = "histoire"
    case karaoke        = "karaoke"
    case drawing        = "dessin"
    case rewardGame     = "jeu_recompense"
    case emotionCheck   = "emotion"
}

enum EmotionState: String, Codable, CaseIterable {
    case happy      = "happy"
    case calm       = "calm"
    case anxious    = "anxious"
    case sad        = "sad"
    case angry      = "angry"
    case tired      = "tired"

    var emoji: String {
        switch self {
        case .happy:   return "😊"
        case .calm:    return "😌"
        case .anxious: return "😰"
        case .sad:     return "😢"
        case .angry:   return "😤"
        case .tired:   return "😴"
        }
    }

    var displayName: String {
        switch self {
        case .happy:   return "Joyeux"
        case .calm:    return "Calme"
        case .anxious: return "Anxieux"
        case .sad:     return "Triste"
        case .angry:   return "En colère"
        case .tired:   return "Fatigué"
        }
    }

    // Si état difficile → suggestion cohérence cardiaque
    var needsRegulation: Bool {
        [.anxious, .sad, .angry, .tired].contains(self)
    }
}

// MARK: - Progression par mot
@Model
class WordProgress {
    var id: UUID
    var word: String
    var translation: String
    var schoolLevel: SchoolLevel
    var module: String
    var timesStudied: Int
    var timesCorrect: Int
    var lastStudied: Date?
    var nextReviewDate: Date?         // spacing effect automatique
    var masteryLevel: MasteryLevel

    var accuracy: Double {
        guard timesStudied > 0 else { return 0 }
        return Double(timesCorrect) / Double(timesStudied)
    }

    init(word: String, translation: String,
         schoolLevel: SchoolLevel, module: String) {
        self.id = UUID()
        self.word = word
        self.translation = translation
        self.schoolLevel = schoolLevel
        self.module = module
        self.timesStudied = 0
        self.timesCorrect = 0
        self.masteryLevel = .new
        self.nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3) // J+3
    }

    // Spacing effect: J+3 → J+7 → J+14 → maîtrisé
    func recordAnswer(correct: Bool) {
        timesStudied += 1
        lastStudied = Date()
        if correct {
            timesCorrect += 1
            switch masteryLevel {
            case .new:
                masteryLevel = .learning
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
            case .learning:
                masteryLevel = .reviewing
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 7)
            case .reviewing:
                masteryLevel = .mastered
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 14)
            case .mastered:
                nextReviewDate = nil
            }
        } else {
            // Régression si erreur
            if masteryLevel == .mastered || masteryLevel == .reviewing {
                masteryLevel = .learning
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
            }
        }
    }
}

enum MasteryLevel: String, Codable, CaseIterable {
    case new        = "nouveau"
    case learning   = "en_cours"
    case reviewing  = "révision"
    case mastered   = "maîtrisé"

    var color: String {
        switch self {
        case .new:      return "masteryGray"
        case .learning: return "masteryBlue"
        case .reviewing: return "masteryOrange"
        case .mastered: return "masteryGreen"
        }
    }

    var emoji: String {
        switch self {
        case .new:      return "🆕"
        case .learning: return "📚"
        case .reviewing: return "🔄"
        case .mastered: return "⭐️"
        }
    }
}

// MARK: - Rapport hebdomadaire
@Model
class WeeklyReport {
    var id: UUID
    var weekStartDate: Date
    var weekEndDate: Date
    var totalSessions: Int
    var totalMinutes: Int
    var activeDays: Int
    var wordsMastered: Int
    var wordsInProgress: Int
    var overallSuccessRate: Double
    var topModule: String
    var parentNote: String           // message auto-généré pour le parent

    init(weekStartDate: Date) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.weekEndDate = weekStartDate.addingTimeInterval(60 * 60 * 24 * 7)
        self.totalSessions = 0
        self.totalMinutes = 0
        self.activeDays = 0
        self.wordsMastered = 0
        self.wordsInProgress = 0
        self.overallSuccessRate = 0
        self.topModule = ""
        self.parentNote = ""
    }
}

// MARK: - Langue de l'application (8 langues)
enum AppLanguage: String, Codable, CaseIterable {
    case french     = "fr"
    case english    = "en"
    case spanish    = "es"
    case portuguese = "pt"
    case italian    = "it"
    case german     = "de"
    case arabic     = "ar"
    case dutch      = "nl"

    var displayName: String {
        switch self {
        case .french:     return "Français"
        case .english:    return "English"
        case .spanish:    return "Español"
        case .portuguese: return "Português"
        case .italian:    return "Italiano"
        case .german:     return "Deutsch"
        case .arabic:     return "العربية"
        case .dutch:      return "Nederlands"
        }
    }

    var flag: String {
        switch self {
        case .french:     return "🇫🇷"
        case .english:    return "🇬🇧"
        case .spanish:    return "🇪🇸"
        case .portuguese: return "🇧🇷"
        case .italian:    return "🇮🇹"
        case .german:     return "🇩🇪"
        case .arabic:     return "🇸🇦"
        case .dutch:      return "🇳🇱"
        }
    }

    var voiceLocale: String {
        switch self {
        case .french:     return "fr-FR"
        case .english:    return "en-GB"
        case .spanish:    return "es-ES"
        case .portuguese: return "pt-BR"
        case .italian:    return "it-IT"
        case .german:     return "de-DE"
        case .arabic:     return "ar-SA"
        case .dutch:      return "nl-NL"
        }
    }

    // Noms des niveaux scolaires selon le pays
    var levelNames: (l0: String, l1: String, l2: String) {
        switch self {
        case .french:     return ("Maternelle", "CP – CE1", "CE2 – CM2")
        case .english:    return ("Early Years", "KS1 (Y1–Y2)", "KS2 (Y3–Y6)")
        case .spanish:    return ("Infantil", "1°–2° Primaria", "3°–6° Primaria")
        case .portuguese: return ("Ed. Infantil", "1°–3° Ano", "4°–6° Ano")
        case .italian:    return ("Infanzia", "1°–2° Elementare", "3°–5° Elementare")
        case .german:     return ("Vorschule", "1.–2. Klasse", "3.–4. Klasse")
        case .arabic:     return ("روضة الأطفال", "الصفوف ١–٣", "الصفوف ٤–٦")
        case .dutch:      return ("Kleuterschool", "Groep 1–3", "Groep 4–6")
        }
    }

    // Traductions UI essentielles
    var ui: UIStrings { UIStrings(language: self) }

    struct UIStrings {
        let language: AppLanguage
        var repeatTitle: String {
            switch language {
            case .french:     return "Répète à voix haute !"
            case .english:    return "Repeat out loud!"
            case .spanish:    return "¡Repite en voz alta!"
            case .portuguese: return "Repita em voz alta!"
            case .italian:    return "Ripeti ad alta voce!"
            case .german:     return "Laut wiederholen!"
            case .arabic:     return "أعد القول بصوت عالٍ!"
            case .dutch:      return "Herhaal hardop!"
            }
        }
        var repeatButton: String {
            switch language {
            case .french:     return "J'ai répété à voix haute ✓"
            case .english:    return "I repeated out loud ✓"
            case .spanish:    return "Lo repetí en voz alta ✓"
            case .portuguese: return "Eu repeti em voz alta ✓"
            case .italian:    return "Ho ripetuto ad alta voce ✓"
            case .german:     return "Ich habe laut wiederholt ✓"
            case .arabic:     return "لقد أعدت القول ✓"
            case .dutch:      return "Ik heb het hardop herhaald ✓"
            }
        }
        var validateButton: String {
            switch language {
            case .french:     return "Valider ma réponse"
            case .english:    return "Submit my answer"
            case .spanish:    return "Enviar mi respuesta"
            case .portuguese: return "Enviar minha resposta"
            case .italian:    return "Invia la mia risposta"
            case .german:     return "Meine Antwort senden"
            case .arabic:     return "إرسال إجابتي"
            case .dutch:      return "Mijn antwoord indienen"
            }
        }
        var nextExercise: String {
            switch language {
            case .french:     return "Exercice suivant →"
            case .english:    return "Next exercise →"
            case .spanish:    return "Siguiente ejercicio →"
            case .portuguese: return "Próximo exercício →"
            case .italian:    return "Prossimo esercizio →"
            case .german:     return "Nächste Übung →"
            case .arabic:     return "التمرين التالي →"
            case .dutch:      return "Volgende oefening →"
            }
        }
        var writeHere: String {
            switch language {
            case .french:     return "Écris ta réponse ici..."
            case .english:    return "Write your answer here..."
            case .spanish:    return "Escribe tu respuesta aquí..."
            case .portuguese: return "Escreva sua resposta aqui..."
            case .italian:    return "Scrivi la tua risposta qui..."
            case .german:     return "Schreibe deine Antwort hier..."
            case .arabic:     return "اكتب إجابتك هنا..."
            case .dutch:      return "Schrijf je antwoord hier..."
            }
        }
        var bravo: String {
            switch language {
            case .french:     return "🎉 Excellent !"
            case .english:    return "🎉 Excellent!"
            case .spanish:    return "🎉 ¡Excelente!"
            case .portuguese: return "🎉 Excelente!"
            case .italian:    return "🎉 Eccellente!"
            case .german:     return "🎉 Ausgezeichnet!"
            case .arabic:     return "🎉 ممتاز!"
            case .dutch:      return "🎉 Uitstekend!"
            }
        }
        var almostTitle: String {
            switch language {
            case .french:     return "💪 Presque !"
            case .english:    return "💪 Almost!"
            case .spanish:    return "💪 ¡Casi!"
            case .portuguese: return "💪 Quase!"
            case .italian:    return "💪 Quasi!"
            case .german:     return "💪 Fast!"
            case .arabic:     return "💪 تقريباً!"
            case .dutch:      return "💪 Bijna!"
            }
        }
    }
}
