import SwiftUI

// MARK: - Langue / Pays de scolarisation
enum CollegeLanguage: String, CaseIterable, Codable {
    case french     = "Français"
    case english    = "English"
    case spanish    = "Español"
    case portuguese = "Português"
    case italian    = "Italiano"
    case german     = "Deutsch"
    case arabic     = "العربية"
    case dutch      = "Nederlands"

    var flag: String {
        switch self {
        case .french:     return "🇫🇷"
        case .english:    return "🇬🇧"
        case .spanish:    return "🇪🇸"
        case .portuguese: return "🇵🇹"
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
        case .portuguese: return "pt-PT"
        case .italian:    return "it-IT"
        case .german:     return "de-DE"
        case .arabic:     return "ar-SA"
        case .dutch:      return "nl-NL"
        }
    }

    var nativeSubjectName: String {
        switch self {
        case .french:     return "Français"
        case .english:    return "English"
        case .spanish:    return "Lengua"
        case .portuguese: return "Português"
        case .italian:    return "Italiano"
        case .german:     return "Deutsch"
        case .arabic:     return "اللغة العربية"
        case .dutch:      return "Nederlands"
        }
    }

    var foreignSubjectName: String {
        switch self {
        case .english:    return "French"
        case .french:     return "English"
        default:          return "English"
        }
    }

    var historySubjectName: String {
        switch self {
        case .french:     return "Histoire-Géo"
        case .english:    return "History"
        case .spanish:    return "Historia"
        case .portuguese: return "História"
        case .italian:    return "Storia"
        case .german:     return "Geschichte"
        case .arabic:     return "التاريخ"
        case .dutch:      return "Geschiedenis"
        }
    }

    var sciencesSubjectName: String {
        switch self {
        case .french:     return "Sciences"
        case .english:    return "Science"
        case .spanish:    return "Ciencias"
        case .portuguese: return "Ciências"
        case .italian:    return "Scienze"
        case .german:     return "Naturwissenschaften"
        case .arabic:     return "العلوم"
        case .dutch:      return "Wetenschappen"
        }
    }

    var mathsSubjectName: String {
        switch self {
        case .french:     return "Mathématiques"
        case .english:    return "Mathematics"
        case .spanish:    return "Matemáticas"
        case .portuguese: return "Matemática"
        case .italian:    return "Matematica"
        case .german:     return "Mathematik"
        case .arabic:     return "الرياضيات"
        case .dutch:      return "Wiskunde"
        }
    }

    var communicationSubjectName: String {
        switch self {
        case .french:     return "Communication sociale"
        case .english:    return "Social Skills"
        case .spanish:    return "Habilidades Sociales"
        case .portuguese: return "Habilidades Sociais"
        case .italian:    return "Abilità Sociali"
        case .german:     return "Soziale Kompetenzen"
        case .arabic:     return "المهارات الاجتماعية"
        case .dutch:      return "Sociale Vaardigheden"
        }
    }

    var cultureSubjectName: String {
        switch self {
        case .french:     return "Culture & Histoires"
        case .english:    return "Culture & Stories"
        case .spanish:    return "Cultura e Historias"
        case .portuguese: return "Cultura e Histórias"
        case .italian:    return "Cultura e Storie"
        case .german:     return "Kultur & Geschichten"
        case .arabic:     return "الثقافة والقصص"
        case .dutch:      return "Cultuur & Verhalen"
        }
    }
}

// MARK: - Niveaux scolaires collège/lycée
enum CollegeLevel: String, CaseIterable, Codable {
    case sixieme   = "6ème"
    case cinquieme = "5ème"
    case quatrieme = "4ème"
    case troisieme = "3ème"
    case seconde   = "Seconde"
    case premiere  = "Première"
    case terminale = "Terminale"

    var ageRange: String {
        switch self {
        case .sixieme:   return "11-12 ans"
        case .cinquieme: return "12-13 ans"
        case .quatrieme: return "13-14 ans"
        case .troisieme: return "14-15 ans"
        case .seconde:   return "15-16 ans"
        case .premiere:  return "16-17 ans"
        case .terminale: return "17-18 ans"
        }
    }

    var emoji: String {
        switch self {
        case .sixieme:   return "🏫"
        case .cinquieme: return "📚"
        case .quatrieme: return "🔬"
        case .troisieme: return "🧪"
        case .seconde:   return "🎓"
        case .premiere:  return "📐"
        case .terminale: return "🏆"
        }
    }

    var isLycee: Bool {
        self == .seconde || self == .premiere || self == .terminale
    }
}

// MARK: - Matières
enum CollegeSubject: String, CaseIterable, Codable {
    case francais      = "Français"
    case maths         = "Mathématiques"
    case anglais       = "Anglais"
    case histoire      = "Histoire-Géo"
    case sciences      = "Sciences"
    case communication = "Communication sociale"
    case culture       = "Culture & Histoires"

    var emoji: String {
        switch self {
        case .francais:      return "📝"
        case .maths:         return "🔢"
        case .anglais:       return "🌍"
        case .histoire:      return "🏛️"
        case .sciences:      return "🔬"
        case .communication: return "🗣️"
        case .culture:       return "🌟"
        }
    }

    var color: String {
        switch self {
        case .francais:      return "accentPurple"
        case .maths:         return "accentBlue"
        case .anglais:       return "accentGreen"
        case .histoire:      return "accentOrange"
        case .sciences:      return "accentPink"
        case .communication: return "accentYellow"
        case .culture:       return "accentRed"
        }
    }

    func displayName(for language: CollegeLanguage) -> String {
        switch self {
        case .francais:      return language.nativeSubjectName
        case .maths:         return language.mathsSubjectName
        case .anglais:       return language.foreignSubjectName
        case .histoire:      return language.historySubjectName
        case .sciences:      return language.sciencesSubjectName
        case .communication: return language.communicationSubjectName
        case .culture:       return language.cultureSubjectName
        }
    }
}

// MARK: - Mode d'exercice
enum CollegeExerciseMode: String, Codable {
    case lesson           // 📖 Slide de cours illustrée (pas d'évaluation)
    case multipleChoice   // QCM
    case shortAnswer      // Réponse courte
    case trueFalse        // Vrai/Faux
    case fillBlank        // Compléter la phrase
    case oral             // Répéter/Expliquer à voix haute
}

// MARK: - Exercice collège
struct CollegeExercise: Identifiable {
    let id = UUID()
    let subject: CollegeSubject
    let mode: CollegeExerciseMode
    let question: String
    let choices: [String]
    let correctAnswer: String
    let explanation: String
    let emoji: String
    let difficulty: Int
    let lessonTitle: String
    let lessonBody: String

    init(subject: CollegeSubject, mode: CollegeExerciseMode, question: String,
         choices: [String], correctAnswer: String, explanation: String,
         emoji: String, difficulty: Int,
         lessonTitle: String = "", lessonBody: String = "") {
        self.subject = subject
        self.mode = mode
        self.question = question
        self.choices = choices
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.emoji = emoji
        self.difficulty = difficulty
        self.lessonTitle = lessonTitle
        self.lessonBody = lessonBody
    }

    static func lesson(subject: CollegeSubject, emoji: String,
                       title: String, body: String, narration: String) -> CollegeExercise {
        CollegeExercise(subject: subject, mode: .lesson,
                        question: narration, choices: [], correctAnswer: "",
                        explanation: "", emoji: emoji, difficulty: 1,
                        lessonTitle: title, lessonBody: body)
    }
}

// MARK: - Profil élève collège (Codable struct)
struct CollegeProfile: Identifiable, Codable {
    var id: UUID = UUID()
    var firstName: String
    var avatarName: String
    var level: CollegeLevel
    var language: CollegeLanguage
    var totalStars: Int
    var currentStreak: Int
    var lastSessionDate: Date?
    var sessions: [CollegeSession]
    var exerciseProgresses: [CollegeExerciseProgress]
    var reminderHour: Int
    var reminderEnabled: Bool

    init(firstName: String, avatarName: String, level: CollegeLevel, language: CollegeLanguage = .french) {
        self.firstName = firstName
        self.avatarName = avatarName
        self.level = level
        self.language = language
        self.totalStars = 0
        self.currentStreak = 0
        self.sessions = []
        self.exerciseProgresses = []
        self.reminderHour = 10
        self.reminderEnabled = true
    }
}

// MARK: - Session (Codable struct)
struct CollegeSession: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var subject: String
    var starsEarned: Int
    var correctAnswers: Int
    var totalAnswers: Int
    var durationSeconds: Int

    init(subject: CollegeSubject, stars: Int, correct: Int, total: Int, duration: Int) {
        self.date = Date()
        self.subject = subject.rawValue
        self.starsEarned = stars
        self.correctAnswers = correct
        self.totalAnswers = total
        self.durationSeconds = duration
    }

    var successRate: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }
}

// MARK: - Hiérarchie de prompts ABA (adaptée ado)
enum CollegePromptLevel: Int, CaseIterable {
    case independent = 0
    case hint        = 1
    case partial     = 2
    case full        = 3

    var buttonLabel: String {
        switch self {
        case .independent: return "J'ai besoin d'un indice 💡"
        case .hint:        return "Encore un indice"
        case .partial:     return "Voir la réponse partielle"
        case .full:        return ""
        }
    }
}

// MARK: - Progression par exercice (Codable struct)
struct CollegeExerciseProgress: Identifiable, Codable {
    var id: UUID = UUID()
    var exerciseKey: String
    var subject: String
    var timesStudied: Int
    var timesCorrect: Int
    var lastStudied: Date?
    var nextReviewDate: Date?
    var masteryLevel: String

    var accuracy: Double {
        guard timesStudied > 0 else { return 0 }
        return Double(timesCorrect) / Double(timesStudied)
    }

    var masteryEmoji: String {
        switch masteryLevel {
        case "mastered":  return "⭐️"
        case "reviewing": return "🔄"
        case "learning":  return "📚"
        default:          return "🆕"
        }
    }

    init(key: String, subject: String) {
        self.exerciseKey = key
        self.subject = subject
        self.timesStudied = 0
        self.timesCorrect = 0
        self.masteryLevel = "new"
        self.nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
    }

    mutating func record(correct: Bool) {
        timesStudied += 1
        lastStudied = Date()
        if correct {
            timesCorrect += 1
            switch masteryLevel {
            case "new":
                masteryLevel = "learning"
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
            case "learning":
                masteryLevel = "reviewing"
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 7)
            case "reviewing":
                masteryLevel = "mastered"
                nextReviewDate = nil
            default: break
            }
        } else {
            if masteryLevel == "mastered" || masteryLevel == "reviewing" {
                masteryLevel = "learning"
                nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
            }
        }
    }
}
