import Foundation

// MARK: - Profil Enfant
struct ChildProfile: Codable, Identifiable {
    var id: UUID
    var firstName: String
    var avatarName: String
    var schoolLevel: SchoolLevel
    var communicationLevel: CommunicationLevel
    var teacherAvatarName: String
    var teacherAvatarVoice: String
    var createdAt: Date
    var lastActiveAt: Date
    var totalStars: Int
    var currentStreak: Int
    var reminderHour: Int
    var reminderEnabled: Bool

    var sessions: [LearningSession]
    var wordProgresses: [WordProgress]
    var weeklyReports: [WeeklyReport]

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
    case preverbal      = "preverbal"
    case emerging       = "emerging"
    case functional     = "functional"
    case conversational = "conversational"

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
struct LearningSession: Codable, Identifiable {
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

    var needsRegulation: Bool {
        [.anxious, .sad, .angry, .tired].contains(self)
    }
}

// MARK: - Progression par mot
struct WordProgress: Codable, Identifiable {
    var id: UUID
    var word: String
    var translation: String
    var schoolLevel: SchoolLevel
    var module: String
    var timesStudied: Int
    var timesCorrect: Int
    var lastStudied: Date?
    var nextReviewDate: Date?
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
        self.nextReviewDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
    }

    mutating func recordAnswer(correct: Bool) {
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
struct WeeklyReport: Codable, Identifiable {
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
    var parentNote: String

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
    case ukrainian  = "uk"
    case polish     = "pl"

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
        case .ukrainian:  return "Українська"
        case .polish:     return "Polski"
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
        case .ukrainian:  return "🇺🇦"
        case .polish:     return "🇵🇱"
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
        case .ukrainian:  return "uk-UA"
        case .polish:     return "pl-PL"
        }
    }

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
        case .ukrainian:  return ("Дошкілля", "1–2 клас", "3–4 клас")
        case .polish:     return ("Przedszkole", "Klasa 1–2", "Klasa 3–4")
        }
    }

    var ui: UIStrings { UIStrings(language: self) }

    struct UIStrings {
        let language: AppLanguage

        // MARK: - Session exercise strings
        var repeatTitle: String {
            switch language {
            case .french:     return "Répète à voix haute !"
            case .english:    return "Repeat aloud!"
            case .spanish:    return "¡Repite en voz alta!"
            case .portuguese: return "Repita em voz alta!"
            case .italian:    return "Ripeti ad alta voce!"
            case .german:     return "Laut wiederholen!"
            case .arabic:     return "أعد القول بصوت عالٍ!"
            case .dutch:      return "Herhaal hardop!"
            case .ukrainian:  return "Повтори вголос!"
            case .polish:     return "Powtórz na głos!"
            }
        }
        var listenThenSay: String {
            switch language {
            case .french:     return "Écoute bien, puis dis la phrase."
            case .english:    return "Listen carefully, then say the sentence."
            case .spanish:    return "Escucha bien, luego di la frase."
            case .portuguese: return "Ouça com atenção, depois diga a frase."
            case .italian:    return "Ascolta bene, poi di' la frase."
            case .german:     return "Höre gut zu, dann sage den Satz."
            case .arabic:     return "استمع جيداً، ثم قل الجملة."
            case .dutch:      return "Luister goed, zeg dan de zin."
            case .ukrainian:  return "Слухай уважно, потім скажи речення."
            case .polish:     return "Słuchaj uważnie, potem powiedz zdanie."
            }
        }
        var tryAgain: String {
            switch language {
            case .french:     return "Si tu n'y arrives pas, réécoute et réessaie !"
            case .english:    return "If you can't, listen again and try!"
            case .spanish:    return "¡Si no puedes, escucha de nuevo e inténtalo!"
            case .portuguese: return "Se não conseguir, ouça novamente e tente!"
            case .italian:    return "Se non riesci, riascolta e riprova!"
            case .german:     return "Wenn es nicht klappt, nochmal zuhören!"
            case .arabic:     return "إذا لم تستطع، استمع مجدداً وحاول!"
            case .dutch:      return "Lukt het niet? Luister opnieuw!"
            case .ukrainian:  return "Якщо не виходить — послухай ще раз і спробуй!"
            case .polish:     return "Jeśli nie wychodzi, posłuchaj jeszcze raz!"
            }
        }
        var repeatButton: String {
            switch language {
            case .french:     return "J'ai répété à voix haute ✓"
            case .english:    return "I repeated aloud ✓"
            case .spanish:    return "Repetí en voz alta ✓"
            case .portuguese: return "Repeti em voz alta ✓"
            case .italian:    return "Ho ripetuto ad alta voce ✓"
            case .german:     return "Ich habe laut wiederholt ✓"
            case .arabic:     return "لقد أعدت القول ✓"
            case .dutch:      return "Ik heb het hardop herhaald ✓"
            case .ukrainian:  return "Я повторив вголос ✓"
            case .polish:     return "Powtórzyłem na głos ✓"
            }
        }
        var wellSaid: String {
            switch language {
            case .french:     return "Bien dit !"
            case .english:    return "Well said!"
            case .spanish:    return "¡Bien dicho!"
            case .portuguese: return "Bem dito!"
            case .italian:    return "Ben detto!"
            case .german:     return "Gut gesagt!"
            case .arabic:     return "أحسنت القول!"
            case .dutch:      return "Goed gezegd!"
            case .ukrainian:  return "Добре сказано!"
            case .polish:     return "Dobrze powiedziane!"
            }
        }
        var validateButton: String {
            switch language {
            case .french:     return "Valider ma réponse"
            case .english:    return "Submit my answer"
            case .spanish:    return "Validar mi respuesta"
            case .portuguese: return "Validar minha resposta"
            case .italian:    return "Convalida la mia risposta"
            case .german:     return "Meine Antwort bestätigen"
            case .arabic:     return "تأكيد إجابتي"
            case .dutch:      return "Mijn antwoord bevestigen"
            case .ukrainian:  return "Підтвердити відповідь"
            case .polish:     return "Zatwierdź odpowiedź"
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
            case .arabic:     return "التمرين التالي ←"
            case .dutch:      return "Volgende oefening →"
            case .ukrainian:  return "Наступна вправа →"
            case .polish:     return "Następne ćwiczenie →"
            }
        }
        var seeResult: String {
            switch language {
            case .french:     return "Voir mon résultat !"
            case .english:    return "See my result!"
            case .spanish:    return "¡Ver mi resultado!"
            case .portuguese: return "Ver meu resultado!"
            case .italian:    return "Vedi il mio risultato!"
            case .german:     return "Mein Ergebnis sehen!"
            case .arabic:     return "عرض نتيجتي!"
            case .dutch:      return "Mijn resultaat zien!"
            case .ukrainian:  return "Переглянути результат!"
            case .polish:     return "Zobacz mój wynik!"
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
            case .ukrainian:  return "Напиши свою відповідь тут..."
            case .polish:     return "Napisz swoją odpowiedź tutaj..."
            }
        }
        var says: String {
            switch language {
            case .french:     return "dit :"
            case .english:    return "says:"
            case .spanish:    return "dice:"
            case .portuguese: return "diz:"
            case .italian:    return "dice:"
            case .german:     return "sagt:"
            case .arabic:     return "يقول:"
            case .dutch:      return "zegt:"
            case .ukrainian:  return "каже:"
            case .polish:     return "mówi:"
            }
        }
        var isSpeaking: String {
            switch language {
            case .french:     return "En train de parler..."
            case .english:    return "Speaking..."
            case .spanish:    return "Hablando..."
            case .portuguese: return "Falando..."
            case .italian:    return "Parlando..."
            case .german:     return "Spricht..."
            case .arabic:     return "يتحدث..."
            case .dutch:      return "Spreken..."
            case .ukrainian:  return "Говорить..."
            case .polish:     return "Mówi..."
            }
        }
        var replay: String {
            switch language {
            case .french:     return "Réécouter"
            case .english:    return "Replay"
            case .spanish:    return "Volver a escuchar"
            case .portuguese: return "Ouvir novamente"
            case .italian:    return "Riascolta"
            case .german:     return "Nochmal anhören"
            case .arabic:     return "إعادة الاستماع"
            case .dutch:      return "Opnieuw afspelen"
            case .ukrainian:  return "Прослухати знову"
            case .polish:     return "Posłuchaj ponownie"
            }
        }
        var correctAnswer: String {
            switch language {
            case .french:     return "La bonne réponse :"
            case .english:    return "The correct answer:"
            case .spanish:    return "La respuesta correcta:"
            case .portuguese: return "A resposta correta:"
            case .italian:    return "La risposta corretta:"
            case .german:     return "Die richtige Antwort:"
            case .arabic:     return "الإجابة الصحيحة:"
            case .dutch:      return "Het juiste antwoord:"
            case .ukrainian:  return "Правильна відповідь:"
            case .polish:     return "Prawidłowa odpowiedź:"
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
            case .ukrainian:  return "🎉 Чудово!"
            case .polish:     return "🎉 Doskonale!"
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
            case .ukrainian:  return "💪 Майже!"
            case .polish:     return "💪 Prawie!"
            }
        }
        var sessionBravo: String {
            switch language {
            case .french:     return "Bravo !"
            case .english:    return "Well done!"
            case .spanish:    return "¡Bravo!"
            case .portuguese: return "Muito bem!"
            case .italian:    return "Bravo!"
            case .german:     return "Bravo!"
            case .arabic:     return "أحسنت!"
            case .dutch:      return "Goed gedaan!"
            case .ukrainian:  return "Молодець!"
            case .polish:     return "Brawo!"
            }
        }
        var keepGoing: String {
            switch language {
            case .french:     return "Continue comme ça !"
            case .english:    return "Keep it up!"
            case .spanish:    return "¡Sigue así!"
            case .portuguese: return "Continue assim!"
            case .italian:    return "Continua così!"
            case .german:     return "Weiter so!"
            case .arabic:     return "استمر هكذا!"
            case .dutch:      return "Ga zo door!"
            case .ukrainian:  return "Так тримати!"
            case .polish:     return "Tak trzymaj!"
            }
        }
        var successRateLabel: String {
            switch language {
            case .french:     return "Réussite"
            case .english:    return "Success"
            case .spanish:    return "Éxito"
            case .portuguese: return "Acerto"
            case .italian:    return "Successo"
            case .german:     return "Erfolg"
            case .arabic:     return "النجاح"
            case .dutch:      return "Succes"
            case .ukrainian:  return "Успіх"
            case .polish:     return "Sukces"
            }
        }
        var starsLabel: String {
            switch language {
            case .french:     return "Étoiles"
            case .english:    return "Stars"
            case .spanish:    return "Estrellas"
            case .portuguese: return "Estrelas"
            case .italian:    return "Stelle"
            case .german:     return "Sterne"
            case .arabic:     return "النجوم"
            case .dutch:      return "Sterren"
            case .ukrainian:  return "Зірки"
            case .polish:     return "Gwiazdki"
            }
        }
        var backToHome: String {
            switch language {
            case .french:     return "Retour à l'accueil"
            case .english:    return "Back to home"
            case .spanish:    return "Volver al inicio"
            case .portuguese: return "Voltar ao início"
            case .italian:    return "Torna alla home"
            case .german:     return "Zurück zur Startseite"
            case .arabic:     return "العودة للرئيسية"
            case .dutch:      return "Terug naar home"
            case .ukrainian:  return "Повернутися на головну"
            case .polish:     return "Wróć do ekranu głównego"
            }
        }
        func starsEarned(_ n: Int) -> String {
            switch language {
            case .french:     return "Tu as gagné \(n) étoile\(n > 1 ? "s" : "") !"
            case .english:    return "You earned \(n) star\(n > 1 ? "s" : "")!"
            case .spanish:    return "¡Ganaste \(n) estrella\(n > 1 ? "s" : "")!"
            case .portuguese: return "Você ganhou \(n) estrela\(n > 1 ? "s" : "")!"
            case .italian:    return "Hai guadagnato \(n) stella\(n > 1 ? "e" : "")!"
            case .german:     return "Du hast \(n) Stern\(n > 1 ? "e" : "") verdient!"
            case .arabic:     return "ربحت \(n) نجمة!"
            case .dutch:      return "Je hebt \(n) ster\(n > 1 ? "ren" : "") verdiend!"
            case .ukrainian:  return "Ти заробив(ла) \(n) зірку(и)!"
            case .polish:     return "Zdobyłeś/aś \(n) gwiazdkę(i)!"
            }
        }

        // MARK: - Home screen strings
        var goodMorning: String {
            switch language {
            case .french:     return "Bonjour"
            case .english:    return "Good morning"
            case .spanish:    return "Buenos días"
            case .portuguese: return "Bom dia"
            case .italian:    return "Buongiorno"
            case .german:     return "Guten Morgen"
            case .arabic:     return "صباح الخير"
            case .dutch:      return "Goedemorgen"
            case .ukrainian:  return "Доброго ранку"
            case .polish:     return "Dzień dobry"
            }
        }
        var goodAfternoon: String {
            switch language {
            case .french:     return "Bon après-midi"
            case .english:    return "Good afternoon"
            case .spanish:    return "Buenas tardes"
            case .portuguese: return "Boa tarde"
            case .italian:    return "Buon pomeriggio"
            case .german:     return "Guten Tag"
            case .arabic:     return "مساء الخير"
            case .dutch:      return "Goedemiddag"
            case .ukrainian:  return "Доброго дня"
            case .polish:     return "Dzień dobry"
            }
        }
        var goodEvening: String {
            switch language {
            case .french:     return "Bonsoir"
            case .english:    return "Good evening"
            case .spanish:    return "Buenas noches"
            case .portuguese: return "Boa noite"
            case .italian:    return "Buonasera"
            case .german:     return "Guten Abend"
            case .arabic:     return "مساء الخير"
            case .dutch:      return "Goedenavond"
            case .ukrainian:  return "Добрий вечір"
            case .polish:     return "Dobry wieczór"
            }
        }
        var whereToStart: String {
            switch language {
            case .french:     return "Par où commencer ?"
            case .english:    return "Where to start?"
            case .spanish:    return "¿Por dónde empezar?"
            case .portuguese: return "Por onde começar?"
            case .italian:    return "Da dove iniziare?"
            case .german:     return "Wo anfangen?"
            case .arabic:     return "من أين نبدأ؟"
            case .dutch:      return "Waar te beginnen?"
            case .ukrainian:  return "З чого почати?"
            case .polish:     return "Od czego zacząć?"
            }
        }
        var parentSpace: String {
            switch language {
            case .french:     return "Espace Parents"
            case .english:    return "Parent Space"
            case .spanish:    return "Espacio Padres"
            case .portuguese: return "Espaço Pais"
            case .italian:    return "Spazio Genitori"
            case .german:     return "Elternbereich"
            case .arabic:     return "فضاء الوالدين"
            case .dutch:      return "Ouderruimte"
            case .ukrainian:  return "Простір батьків"
            case .polish:     return "Przestrzeń rodziców"
            }
        }
        var parentSpaceDesc: String {
            switch language {
            case .french:     return "Suivi des progrès, compétences ABA, rapport"
            case .english:    return "Progress tracking, ABA skills, report"
            case .spanish:    return "Seguimiento, habilidades ABA, informe"
            case .portuguese: return "Acompanhamento, habilidades ABA, relatório"
            case .italian:    return "Progressi, abilità ABA, rapporto"
            case .german:     return "Fortschritt, ABA-Fähigkeiten, Bericht"
            case .arabic:     return "تتبع التقدم، مهارات ABA، التقرير"
            case .dutch:      return "Voortgang, ABA-vaardigheden, rapport"
            case .ukrainian:  return "Прогрес, навички ABA, звіт"
            case .polish:     return "Postępy, umiejętności ABA, raport"
            }
        }
        var leoCompanion: String {
            switch language {
            case .french:     return "Ton compagnon Léo"
            case .english:    return "Leo, your companion"
            case .spanish:    return "Leo, tu compañero"
            case .portuguese: return "Leo, seu companheiro"
            case .italian:    return "Leo, il tuo compagno"
            case .german:     return "Leo, dein Begleiter"
            case .arabic:     return "ليو، رفيقك"
            case .dutch:      return "Leo, jouw metgezel"
            case .ukrainian:  return "Лео, твій друг"
            case .polish:     return "Leo, twój towarzysz"
            }
        }
        var breathingExercise: String {
            switch language {
            case .french:     return "Exercice de respiration"
            case .english:    return "Breathing exercise"
            case .spanish:    return "Ejercicio de respiración"
            case .portuguese: return "Exercício de respiração"
            case .italian:    return "Esercizio di respirazione"
            case .german:     return "Atemübung"
            case .arabic:     return "تمرين التنفس"
            case .dutch:      return "Ademhalingsoefening"
            case .ukrainian:  return "Дихальна вправа"
            case .polish:     return "Ćwiczenie oddechowe"
            }
        }
        var breathingDesc: String {
            switch language {
            case .french:     return "3 minutes pour se calmer avant d'apprendre"
            case .english:    return "3 minutes to calm down before learning"
            case .spanish:    return "3 minutos para calmarse antes de aprender"
            case .portuguese: return "3 minutos para se acalmar antes de aprender"
            case .italian:    return "3 minuti per calmarsi prima di imparare"
            case .german:     return "3 Minuten zum Beruhigen vor dem Lernen"
            case .arabic:     return "٣ دقائق للاسترخاء قبل التعلم"
            case .dutch:      return "3 minuten kalmeren voor het leren"
            case .ukrainian:  return "3 хвилини для заспокоєння перед навчанням"
            case .polish:     return "3 minuty na uspokojenie przed nauką"
            }
        }
        var quickReview: String {
            switch language {
            case .french:     return "Révision rapide — 3 minutes !"
            case .english:    return "Quick review — 3 minutes!"
            case .spanish:    return "¡Repaso rápido — 3 minutos!"
            case .portuguese: return "Revisão rápida — 3 minutos!"
            case .italian:    return "Ripasso veloce — 3 minuti!"
            case .german:     return "Schnelle Wiederholung — 3 Minuten!"
            case .arabic:     return "مراجعة سريعة — ٣ دقائق!"
            case .dutch:      return "Snelle herhaling — 3 minuten!"
            case .ukrainian:  return "Швидке повторення — 3 хвилини!"
            case .polish:     return "Szybka powtórka — 3 minuty!"
            }
        }
        var startHere: String {
            switch language {
            case .french:     return "Commence ici !"
            case .english:    return "Start here!"
            case .spanish:    return "¡Empieza aquí!"
            case .portuguese: return "Comece aqui!"
            case .italian:    return "Inizia qui!"
            case .german:     return "Hier anfangen!"
            case .arabic:     return "ابدأ هنا!"
            case .dutch:      return "Begin hier!"
            case .ukrainian:  return "Починай тут!"
            case .polish:     return "Zacznij tutaj!"
            }
        }
        var storyOfDay: String {
            switch language {
            case .french:     return "📚 Histoire du jour"
            case .english:    return "📚 Story of the day"
            case .spanish:    return "📚 Historia del día"
            case .portuguese: return "📚 História do dia"
            case .italian:    return "📚 Storia del giorno"
            case .german:     return "📚 Geschichte des Tages"
            case .arabic:     return "📚 قصة اليوم"
            case .dutch:      return "📚 Verhaal van de dag"
            case .ukrainian:  return "📚 Казка дня"
            case .polish:     return "📚 Historia dnia"
            }
        }
        var dailySchedule: String {
            switch language {
            case .french:     return "📅 Programme du jour"
            case .english:    return "📅 Daily schedule"
            case .spanish:    return "📅 Programa del día"
            case .portuguese: return "📅 Programa do dia"
            case .italian:    return "📅 Programma del giorno"
            case .german:     return "📅 Tagesplan"
            case .arabic:     return "📅 برنامج اليوم"
            case .dutch:      return "📅 Dagelijks programma"
            case .ukrainian:  return "📅 Розклад на день"
            case .polish:     return "📅 Plan dnia"
            }
        }
        var timeRemainingBreak: String {
            switch language {
            case .french:     return "Il reste ce temps pour ta pause"
            case .english:    return "Time remaining for your break"
            case .spanish:    return "Tiempo restante para tu descanso"
            case .portuguese: return "Tempo restante para sua pausa"
            case .italian:    return "Tempo rimanente per la pausa"
            case .german:     return "Verbleibende Zeit für deine Pause"
            case .arabic:     return "الوقت المتبقي للاستراحة"
            case .dutch:      return "Resterende tijd voor je pauze"
            case .ukrainian:  return "Час, що залишився на перерву"
            case .polish:     return "Pozostały czas na przerwę"
            }
        }
        var chooseActivity: String {
            switch language {
            case .french:     return "Choisis ton activité :"
            case .english:    return "Choose your activity:"
            case .spanish:    return "Elige tu actividad:"
            case .portuguese: return "Escolha sua atividade:"
            case .italian:    return "Scegli la tua attività:"
            case .german:     return "Wähle deine Aktivität:"
            case .arabic:     return "اختر نشاطك:"
            case .dutch:      return "Kies je activiteit:"
            case .ukrainian:  return "Обери свою активність:"
            case .polish:     return "Wybierz swoją aktywność:"
            }
        }
        var close: String {
            switch language {
            case .french:     return "Fermer"
            case .english:    return "Close"
            case .spanish:    return "Cerrar"
            case .portuguese: return "Fechar"
            case .italian:    return "Chiudi"
            case .german:     return "Schließen"
            case .arabic:     return "إغلاق"
            case .dutch:      return "Sluiten"
            case .ukrainian:  return "Закрити"
            case .polish:     return "Zamknij"
            }
        }
        var unlock: String {
            switch language {
            case .french:     return "Débloquer"
            case .english:    return "Unlock"
            case .spanish:    return "Desbloquear"
            case .portuguese: return "Desbloquear"
            case .italian:    return "Sbloccare"
            case .german:     return "Freischalten"
            case .arabic:     return "فتح"
            case .dutch:      return "Ontgrendelen"
            case .ukrainian:  return "Розблокувати"
            case .polish:     return "Odblokuj"
            }
        }
        var mysteryWord: String {
            switch language {
            case .french:     return "Mot Mystère 🔤"
            case .english:    return "Mystery Word 🔤"
            case .spanish:    return "Palabra Misterio 🔤"
            case .portuguese: return "Palavra Mistério 🔤"
            case .italian:    return "Parola Mistero 🔤"
            case .german:     return "Geheimwort 🔤"
            case .arabic:     return "الكلمة السرية 🔤"
            case .dutch:      return "Geheimwoord 🔤"
            case .ukrainian:  return "Таємне слово 🔤"
            case .polish:     return "Tajemnicze słowo 🔤"
            }
        }
        var abaGame: String {
            switch language {
            case .french:     return "Jeu de lettres adapté TSA"
            case .english:    return "ABA-adapted letter game"
            case .spanish:    return "Juego de letras adaptado ABA"
            case .portuguese: return "Jogo de letras adaptado ABA"
            case .italian:    return "Gioco di lettere adattato ABA"
            case .german:     return "ABA-angepasstes Buchstabenspiel"
            case .arabic:     return "لعبة حروف معدّلة ABA"
            case .dutch:      return "ABA-aangepast lettersspel"
            case .ukrainian:  return "ABA-адаптована гра з літерами"
            case .polish:     return "Gra literowa adaptowana ABA"
            }
        }
        var unlockBonus: String {
            switch language {
            case .french:     return "Débloquer le jeu bonus 🎁"
            case .english:    return "Unlock bonus game 🎁"
            case .spanish:    return "Desbloquear juego extra 🎁"
            case .portuguese: return "Desbloquear jogo bônus 🎁"
            case .italian:    return "Sblocca il gioco bonus 🎁"
            case .german:     return "Bonusspiel freischalten 🎁"
            case .arabic:     return "فتح لعبة المكافأة 🎁"
            case .dutch:      return "Bonusspel ontgrendelen 🎁"
            case .ukrainian:  return "Розблокувати бонусну гру 🎁"
            case .polish:     return "Odblokuj grę bonus 🎁"
            }
        }
        var leaveReview: String {
            switch language {
            case .french:     return "Laisser un avis 5⭐ pour débloquer"
            case .english:    return "Leave a 5⭐ review to unlock"
            case .spanish:    return "Deja una reseña 5⭐ para desbloquear"
            case .portuguese: return "Deixe uma avaliação 5⭐ para desbloquear"
            case .italian:    return "Lascia una recensione 5⭐ per sbloccare"
            case .german:     return "5⭐-Bewertung hinterlassen"
            case .arabic:     return "اترك تقييم 5⭐ للفتح"
            case .dutch:      return "Laat een 5⭐-review achter"
            case .ukrainian:  return "Залиш відгук 5⭐ щоб розблокувати"
            case .polish:     return "Wystaw 5⭐ recenzję, aby odblokować"
            }
        }
        var consecutiveDays: String {
            switch language {
            case .french:     return "jours consécutifs"
            case .english:    return "consecutive days"
            case .spanish:    return "días consecutivos"
            case .portuguese: return "dias consecutivos"
            case .italian:    return "giorni consecutivi"
            case .german:     return "Tage hintereinander"
            case .arabic:     return "أيام متتالية"
            case .dutch:      return "opeenvolgende dagen"
            case .ukrainian:  return "днів поспіль"
            case .polish:     return "dni z rzędu"
            }
        }
        var starsRewards: String {
            switch language {
            case .french:     return "étoiles — voir récompenses"
            case .english:    return "stars — see rewards"
            case .spanish:    return "estrellas — ver recompensas"
            case .portuguese: return "estrelas — ver recompensas"
            case .italian:    return "stelle — vedi premi"
            case .german:     return "Sterne — Belohnungen sehen"
            case .arabic:     return "نجوم — عرض المكافآت"
            case .dutch:      return "sterren — beloningen bekijken"
            case .ukrainian:  return "зірки — переглянути нагороди"
            case .polish:     return "gwiazdki — zobacz nagrody"
            }
        }
        var howDoYouFeelPrefix: String {
            switch language {
            case .french:     return "Comment tu te sens"
            case .english:    return "How do you feel"
            case .spanish:    return "¿Cómo te sientes"
            case .portuguese: return "Como você se sente"
            case .italian:    return "Come ti senti"
            case .german:     return "Wie fühlst du dich"
            case .arabic:     return "كيف حالك"
            case .dutch:      return "Hoe voel je je"
            case .ukrainian:  return "Як ти себе почуваєш"
            case .polish:     return "Jak się czujesz"
            }
        }
        var settingsTitle: String {
            switch language {
            case .french:     return "Réglages"
            case .english:    return "Settings"
            case .spanish:    return "Ajustes"
            case .portuguese: return "Configurações"
            case .italian:    return "Impostazioni"
            case .german:     return "Einstellungen"
            case .arabic:     return "الإعدادات"
            case .dutch:      return "Instellingen"
            case .ukrainian:  return "Налаштування"
            case .polish:     return "Ustawienia"
            }
        }
        var chooseLevel: String {
            switch language {
            case .french:     return "Choisir le niveau"
            case .english:    return "Choose level"
            case .spanish:    return "Elegir nivel"
            case .portuguese: return "Escolher nível"
            case .italian:    return "Scegli livello"
            case .german:     return "Stufe wählen"
            case .arabic:     return "اختر المستوى"
            case .dutch:      return "Niveau kiezen"
            case .ukrainian:  return "Обрати рівень"
            case .polish:     return "Wybierz poziom"
            }
        }
        var encouragementMessages: [String] {
            switch language {
            case .french:     return ["On apprend ensemble aujourd'hui !", "Tu vas y arriver, je suis là !", "Chaque mot appris est une victoire !", "Prêt(e) ? Moi j'y suis !", "On forme une super équipe !"]
            case .english:    return ["We're learning together today!", "You can do it, I'm here!", "Every word learned is a victory!", "Ready? I'm here for you!", "We make a great team!"]
            case .spanish:    return ["¡Hoy aprendemos juntos!", "¡Tú puedes, estoy aquí!", "¡Cada palabra es una victoria!", "¿Listo/a? ¡Aquí estoy!", "¡Somos un gran equipo!"]
            case .portuguese: return ["Aprendemos juntos hoje!", "Você consegue, estou aqui!", "Cada palavra é uma vitória!", "Pronto(a)? Estou aqui!", "Somos uma ótima equipe!"]
            case .italian:    return ["Oggi impariamo insieme!", "Ce la farai, sono qui!", "Ogni parola è una vittoria!", "Pronto/a? Ci sono!", "Siamo una squadra fantastica!"]
            case .german:     return ["Heute lernen wir zusammen!", "Du schaffst es, ich bin hier!", "Jedes Wort ist ein Sieg!", "Bereit? Ich bin dabei!", "Wir sind ein tolles Team!"]
            case .arabic:     return ["نتعلم معاً اليوم!", "ستنجح، أنا هنا!", "كل كلمة هي انتصار!", "مستعد؟ أنا هنا!", "نحن فريق رائع!"]
            case .dutch:      return ["Vandaag leren we samen!", "Je kunt het, ik ben hier!", "Elk woord is een overwinning!", "Klaar? Ik ben erbij!", "We zijn een super team!"]
            case .ukrainian:  return ["Сьогодні вчимось разом!", "Ти впораєшся, я тут!", "Кожне слово — перемога!", "Готовий/готова? Я поруч!", "Ми чудова команда!"]
            case .polish:     return ["Dziś uczymy się razem!", "Dasz radę, jestem tu!", "Każde słowo to zwycięstwo!", "Gotowy/Gotowa? Jestem tu!", "Tworzymy świetny zespół!"]
            }
        }
        var moduleSpeech: String {
            switch language {
            case .french:     return "Parole"
            case .english:    return "Speech"
            case .spanish:    return "Habla"
            case .portuguese: return "Fala"
            case .italian:    return "Parlato"
            case .german:     return "Sprechen"
            case .arabic:     return "نطق"
            case .dutch:      return "Spraak"
            case .ukrainian:  return "Мовлення"
            case .polish:     return "Mowa"
            }
        }
        var moduleSong: String {
            switch language {
            case .french:     return "Chanson"
            case .english:    return "Song"
            case .spanish:    return "Canción"
            case .portuguese: return "Música"
            case .italian:    return "Canzone"
            case .german:     return "Lied"
            case .arabic:     return "أغنية"
            case .dutch:      return "Liedje"
            case .ukrainian:  return "Пісня"
            case .polish:     return "Piosenka"
            }
        }
        var moduleStory: String {
            switch language {
            case .french:     return "Histoire"
            case .english:    return "Story"
            case .spanish:    return "Historia"
            case .portuguese: return "História"
            case .italian:    return "Storia"
            case .german:     return "Geschichte"
            case .arabic:     return "قصة"
            case .dutch:      return "Verhaal"
            case .ukrainian:  return "Казка"
            case .polish:     return "Opowiadanie"
            }
        }
        var moduleVocab: String {
            switch language {
            case .french:     return "Vocabulaire"
            case .english:    return "Vocabulary"
            case .spanish:    return "Vocabulario"
            case .portuguese: return "Vocabulário"
            case .italian:    return "Vocabolario"
            case .german:     return "Wortschatz"
            case .arabic:     return "مفردات"
            case .dutch:      return "Woordenschat"
            case .ukrainian:  return "Словник"
            case .polish:     return "Słownictwo"
            }
        }
        var moduleNumbers: String {
            switch language {
            case .french:     return "Chiffres"
            case .english:    return "Numbers"
            case .spanish:    return "Números"
            case .portuguese: return "Números"
            case .italian:    return "Numeri"
            case .german:     return "Zahlen"
            case .arabic:     return "أرقام"
            case .dutch:      return "Getallen"
            case .ukrainian:  return "Числа"
            case .polish:     return "Liczby"
            }
        }
        var moduleDrawing: String {
            switch language {
            case .french:     return "Dessin"
            case .english:    return "Drawing"
            case .spanish:    return "Dibujo"
            case .portuguese: return "Desenho"
            case .italian:    return "Disegno"
            case .german:     return "Zeichnen"
            case .arabic:     return "رسم"
            case .dutch:      return "Tekenen"
            case .ukrainian:  return "Малювання"
            case .polish:     return "Rysowanie"
            }
        }
        func starsUntilBreak(_ n: Int) -> String {
            switch language {
            case .french:     return "Encore \(n) étoile\(n > 1 ? "s" : "") → pause jeu !"
            case .english:    return "\(n) more star\(n > 1 ? "s" : "") → game break!"
            case .spanish:    return "¡Aún \(n) estrella\(n > 1 ? "s" : "") → pausa!"
            case .portuguese: return "Mais \(n) estrela\(n > 1 ? "s" : "") → pausa!"
            case .italian:    return "Ancora \(n) stella\(n > 1 ? "e" : "") → pausa!"
            case .german:     return "Noch \(n) Stern\(n > 1 ? "e" : "") → Spielpause!"
            case .arabic:     return "بعد \(n) نجمة → استراحة!"
            case .dutch:      return "Nog \(n) ster\(n > 1 ? "ren" : "") → speelpauze!"
            case .ukrainian:  return "Ще \(n) зірку(и) → перерва на гру!"
            case .polish:     return "Jeszcze \(n) gwiazdkę(i) → przerwa!"
            }
        }
        func wordsToReview(_ n: Int) -> String {
            switch language {
            case .french:     return "\(n) mots à réviser aujourd'hui"
            case .english:    return "\(n) words to review today"
            case .spanish:    return "\(n) palabras para repasar hoy"
            case .portuguese: return "\(n) palavras para revisar hoje"
            case .italian:    return "\(n) parole da ripassare oggi"
            case .german:     return "\(n) Wörter heute zu wiederholen"
            case .arabic:     return "\(n) كلمات للمراجعة اليوم"
            case .dutch:      return "\(n) woorden te herhalen vandaag"
            case .ukrainian:  return "\(n) слів для повторення сьогодні"
            case .polish:     return "\(n) słów do powtórzenia dziś"
            }
        }
        func stepsCompleted(_ done: Int, _ total: Int) -> String {
            switch language {
            case .french:     return "\(done) / \(total) étapes terminées"
            case .english:    return "\(done) / \(total) steps completed"
            case .spanish:    return "\(done) / \(total) pasos completados"
            case .portuguese: return "\(done) / \(total) etapas concluídas"
            case .italian:    return "\(done) / \(total) fasi completate"
            case .german:     return "\(done) / \(total) Schritte abgeschlossen"
            case .arabic:     return "\(done) / \(total) خطوات مكتملة"
            case .dutch:      return "\(done) / \(total) stappen voltooid"
            case .ukrainian:  return "\(done) / \(total) кроків виконано"
            case .polish:     return "\(done) / \(total) kroków ukończono"
            }
        }
        func breakEarned(_ n: Int) -> String {
            switch language {
            case .french:     return "Tu as gagné \(n) étoiles !\nC'est ta pause de 5 minutes !"
            case .english:    return "You earned \(n) stars!\nIt's your 5-minute break!"
            case .spanish:    return "¡Ganaste \(n) estrellas!\n¡Es tu pausa de 5 minutos!"
            case .portuguese: return "Você ganhou \(n) estrelas!\nÉ sua pausa de 5 minutos!"
            case .italian:    return "Hai guadagnato \(n) stelle!\nÈ la tua pausa di 5 minuti!"
            case .german:     return "Du hast \(n) Sterne verdient!\nDas ist deine 5-Minuten-Pause!"
            case .arabic:     return "ربحت \(n) نجوم!\nهذه استراحتك من 5 دقائق!"
            case .dutch:      return "Je hebt \(n) sterren verdiend!\nHet is je 5-minutenpauze!"
            case .ukrainian:  return "Ти заробив(ла) \(n) зірки!\nЦе твоя 5-хвилинна перерва!"
            case .polish:     return "Zdobyłeś \(n) gwiazdki!\nTo twoja 5-minutowa przerwa!"
            }
        }
        func howDoYouFeel(_ name: String) -> String { "\(howDoYouFeelPrefix) \(name) ?" }
        func bravoFull(_ name: String) -> String { "\(sessionBravo.replacingOccurrences(of: "!", with: "")) \(name) !" }
    }
}
