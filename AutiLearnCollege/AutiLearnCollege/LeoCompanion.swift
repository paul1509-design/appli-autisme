import AVFoundation
import SwiftUI

// MARK: - Léo, compagnon pair conversationnel (multilingue)
@MainActor
class LeoCompanion: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    @Published var isSpeaking = false
    @Published var currentMessage = ""
    @Published var emotion: LeoEmotion = .neutral
    @Published var showBubble = false

    private let synthesizer = AVSpeechSynthesizer()
    private var language: CollegeLanguage = .french

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func configure(language: CollegeLanguage) {
        self.language = language
    }

    // MARK: - Moments clés
    enum LeoContext {
        case sessionStart(subject: String, firstName: String)
        case correctAnswer(streak: Int)
        case wrongAnswer(attempt: Int)
        case hintRequested
        case sessionEnd(correct: Int, total: Int, firstName: String)
        case greetingMorning(firstName: String)
        case greetingReturn(firstName: String, daysSince: Int)
        case streakCelebration(days: Int)
        case encourageStart(firstName: String)
        case askQuestion(subject: String)
    }

    func speak(context: LeoContext) {
        let (msg, emo) = messageAndEmotion(for: context)
        display(message: msg, emotion: emo)
        speakText(msg)
    }

    func speakText(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        isSpeaking = true
        for (i, sentence) in sentences.enumerated() {
            let utterance = AVSpeechUtterance(string: sentence)
            utterance.voice = Self.preferredVoice(locale: language.voiceLocale)
            utterance.rate = 0.48
            utterance.pitchMultiplier = LeoAvatarView.gender == "female" ? 1.12 : 0.95
            utterance.volume = 1.0
            utterance.preUtteranceDelay = i == 0 ? 0 : 0.18
            utterance.postUtteranceDelay = 0.08
            synthesizer.speak(utterance)
        }
    }

    private static func preferredVoice(locale: String) -> AVSpeechSynthesisVoice? {
        let isFemale = LeoAvatarView.gender == "female"
        let langCode = String(locale.prefix(2))
        let all = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix(langCode) }
        let femaleIds = ["amelie","marie","audrey","aurelie","florence","monica","karen","samantha","victoria"]
        let maleIds   = ["thomas","nicolas","pierre","daniel","alex","romain","jorge","diego"]
        let preferred = isFemale ? femaleIds : maleIds
        for id in preferred {
            if let v = all.first(where: { $0.identifier.lowercased().contains(id) }) { return v }
        }
        return all.first ?? AVSpeechSynthesisVoice(language: locale)
    }

    func stop() { synthesizer.stopSpeaking(at: .immediate) }

    private func display(message: String, emotion: LeoEmotion) {
        currentMessage = message
        self.emotion = emotion
        withAnimation(.spring(response: 0.3)) { showBubble = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            withAnimation { self.showBubble = false }
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }

    // MARK: - Messages par contexte et langue
    private func messageAndEmotion(for context: LeoContext) -> (String, LeoEmotion) {
        switch context {

        case .sessionStart(let subject, let firstName):
            return (pick(sessionStart(subject: subject, firstName: firstName)), .excited)

        case .correctAnswer(let streak):
            if streak >= 3 {
                return (pick(streakCorrect(streak: streak)), .celebrating)
            }
            return (pick(correct()), .happy)

        case .wrongAnswer(let attempt):
            if attempt == 1 {
                return (pick(firstWrong()), .caring)
            }
            return (pick(secondWrong()), .supportive)

        case .hintRequested:
            return (pick(hint()), .helpful)

        case .sessionEnd(let correct, let total, let firstName):
            let rate = total > 0 ? correct * 100 / total : 0
            return (pick(sessionEnd(correct: correct, total: total, rate: rate, firstName: firstName)),
                    rate >= 70 ? .celebrating : .encouraging)

        case .greetingMorning(let firstName):
            return (pick(greetingMorning(firstName: firstName)), .excited)

        case .greetingReturn(let firstName, let daysSince):
            return (pick(greetingReturn(firstName: firstName, days: daysSince)), .caring)

        case .streakCelebration(let days):
            return (pick(streakCelebration(days: days)), .celebrating)

        case .encourageStart(let firstName):
            return (pick(encourageStart(firstName: firstName)), .neutral)

        case .askQuestion(let subject):
            return (pick(askQuestion(subject: subject)), .curious)
        }
    }

    private func pick(_ arr: [String]) -> String {
        arr.randomElement() ?? arr[0]
    }

    // MARK: - Banques de messages multilingues

    private func sessionStart(subject: String, firstName: String) -> [String] {
        switch language {
        case .french: return [
            "Salut \(firstName) ! On attaque \(subject) ensemble. Je suis là !",
            "C'est parti \(firstName) ! \(subject) aujourd'hui — t'as assuré la dernière fois !",
            "\(firstName), prêt(e) ? Moi oui ! On va se régaler en \(subject) !"
        ]
        case .english: return [
            "Hey \(firstName)! Let's do \(subject) together. I'm right here!",
            "Ready \(firstName)? \(subject) time! You did great last time!",
            "\(firstName), let's go! \(subject) is going to be fun today!"
        ]
        case .spanish: return [
            "¡Hola \(firstName)! Vamos a \(subject) juntos. ¡Estoy aquí contigo!",
            "¡Listo \(firstName)! Hoy toca \(subject). ¡Tú puedes!",
            "\(firstName), ¡empezamos! \(subject) hoy — ¡va a ir genial!"
        ]
        case .portuguese: return [
            "Olá \(firstName)! Vamos fazer \(subject) juntos. Estou aqui!",
            "Pronto \(firstName)? Hoje é \(subject)! Tu consegues!",
            "\(firstName), vamos começar! \(subject) vai correr muito bem!"
        ]
        case .italian: return [
            "Ciao \(firstName)! Facciamo \(subject) insieme. Sono qui con te!",
            "Pronti \(firstName)? Oggi \(subject)! Andrà benissimo!",
            "\(firstName), si parte! \(subject) oggi — fidati di me!"
        ]
        case .german: return [
            "Hallo \(firstName)! Wir machen \(subject) zusammen. Ich bin dabei!",
            "Bereit \(firstName)? Heute \(subject)! Du schaffst das!",
            "\(firstName), los geht's! \(subject) heute — wir sind ein Team!"
        ]
        case .arabic: return [
            "!مرحباً \(firstName)! سنتعلم \(subject) معاً. أنا هنا معك",
            "!\(firstName)، هيا نبدأ! \(subject) اليوم — أنت قادر",
            "!\(firstName)، انطلق! \(subject) اليوم سيكون رائعاً"
        ]
        case .dutch: return [
            "Hoi \(firstName)! We doen \(subject) samen. Ik ben er bij!",
            "Klaar \(firstName)? Vandaag \(subject)! Jij kunt het!",
            "\(firstName), we gaan! \(subject) vandaag — samen staan we sterk!"
        ]
        }
    }

    private func correct() -> [String] {
        switch language {
        case .french: return [
            "Exact ! Bien joué !",
            "Oui ! Je savais que tu y arriverais !",
            "Parfait ! Continue comme ça !",
            "Bravo ! Tu maîtrises bien !",
            "Super réponse ! T'as assuré !"
        ]
        case .english: return [
            "Correct! Well done!",
            "Yes! I knew you could do it!",
            "Perfect! Keep going!",
            "Great answer! You're nailing it!",
            "Brilliant! That's the way!"
        ]
        case .spanish: return [
            "¡Correcto! ¡Muy bien!",
            "¡Sí! ¡Sabía que podías!",
            "¡Perfecto! ¡Sigue así!",
            "¡Bravo! ¡Lo tienes controlado!",
            "¡Genial respuesta!"
        ]
        case .portuguese: return [
            "Correto! Muito bem!",
            "Sim! Sabia que conseguias!",
            "Perfeito! Continua assim!",
            "Parabéns! Estás a mandar!",
            "Ótima resposta!"
        ]
        case .italian: return [
            "Esatto! Bravo!",
            "Sì! Sapevo che ce la facevi!",
            "Perfetto! Continua così!",
            "Ottima risposta!",
            "Fantastico! Vai benissimo!"
        ]
        case .german: return [
            "Richtig! Gut gemacht!",
            "Ja! Ich wusste, du schaffst das!",
            "Perfekt! Weiter so!",
            "Super Antwort!",
            "Toll! Du machst das wirklich gut!"
        ]
        case .arabic: return [
            "!صحيح! أحسنت",
            "!نعم! كنت أعلم أنك ستنجح",
            "!ممتاز! استمر هكذا",
            "!إجابة رائعة",
            "!رائع! أنت تبلي بلاءً حسناً"
        ]
        case .dutch: return [
            "Correct! Goed gedaan!",
            "Ja! Ik wist dat je het kon!",
            "Perfect! Ga zo door!",
            "Geweldig antwoord!",
            "Super! Je doet het echt goed!"
        ]
        }
    }

    private func streakCorrect(streak: Int) -> [String] {
        switch language {
        case .french: return [
            "\(streak) bonnes réponses d'affilée ! Tu es en feu !",
            "Incroyable ! \(streak) à la suite ! Je suis impressionné !",
            "Wow \(streak) ! Tu cartonnes aujourd'hui !"
        ]
        case .english: return [
            "\(streak) in a row! You're on fire!",
            "Incredible! \(streak) streak! I'm impressed!",
            "Wow \(streak)! You're crushing it today!"
        ]
        case .spanish: return [
            "¡\(streak) seguidas! ¡Estás en racha!",
            "¡Increíble! ¡\(streak) en fila! ¡Estoy impresionado!",
            "¡Wow \(streak)! ¡Estás que te sales hoy!"
        ]
        case .portuguese: return [
            "\(streak) seguidas! Estás em chama!",
            "Incrível! \(streak) consecutivas! Estou impressionado!",
            "Uau \(streak)! Estás arrasando hoje!"
        ]
        case .italian: return [
            "\(streak) di fila! Sei in fiamma!",
            "Incredibile! \(streak) di seguito! Sono impressionato!",
            "Wow \(streak)! Stai dominando oggi!"
        ]
        case .german: return [
            "\(streak) in Folge! Du bist auf Feuer!",
            "Unglaublich! \(streak) hintereinander! Ich bin beeindruckt!",
            "Wow \(streak)! Du rockst heute!"
        ]
        case .arabic: return [
            "!\(streak) إجابات متتالية! أنت في قمة أدائك",
            "!لا يصدق! \(streak) على التوالي! أنا معجب بك",
            "!واو \(streak)! أنت تتألق اليوم"
        ]
        case .dutch: return [
            "\(streak) op rij! Je bent geweldig!",
            "Ongelooflijk! \(streak) achter elkaar! Ik ben onder de indruk!",
            "Wauw \(streak)! Je doet het super vandaag!"
        ]
        }
    }

    private func firstWrong() -> [String] {
        switch language {
        case .french: return [
            "Pas grave ! On réessaie ensemble.",
            "C'est difficile celui-là ! Prends ton temps.",
            "Ça arrive à tout le monde. Tu vas y arriver !",
            "Hmm, presque ! Réfléchis encore un peu.",
            "Ne t'inquiète pas — je suis là avec toi."
        ]
        case .english: return [
            "No worries! Let's try again together.",
            "This one's tricky! Take your time.",
            "Everyone gets it wrong sometimes. You've got this!",
            "Hmm, almost! Think a bit more.",
            "Don't worry — I'm right here with you."
        ]
        case .spanish: return [
            "¡No pasa nada! Intentemos de nuevo juntos.",
            "¡Este es difícil! Tómate tu tiempo.",
            "Todos nos equivocamos. ¡Tú puedes!",
            "Hmm, ¡casi! Piensa un poco más.",
            "No te preocupes — estoy aquí contigo."
        ]
        case .portuguese: return [
            "Não faz mal! Tentamos de novo juntos.",
            "Este é difícil! Toma o teu tempo.",
            "Toda a gente erra. Consegues!",
            "Hmm, quase! Pensa um pouco mais.",
            "Não te preocupes — estou aqui contigo."
        ]
        case .italian: return [
            "Non preoccuparti! Riproviamo insieme.",
            "Questo è difficile! Prenditi il tuo tempo.",
            "Capita a tutti. Ce la fai!",
            "Hmm, quasi! Pensa ancora un po'.",
            "Non ti preoccupare — sono qui con te."
        ]
        case .german: return [
            "Kein Problem! Lass uns zusammen nochmal versuchen.",
            "Das ist schwierig! Nimm dir Zeit.",
            "Das passiert jedem mal. Du schaffst das!",
            "Hmm, fast! Denk noch etwas nach.",
            "Keine Sorge — ich bin bei dir."
        ]
        case .arabic: return [
            "!لا بأس! سنحاول معاً مرة أخرى",
            ".هذا صعب! خذ وقتك",
            "!يخطئ الجميع. ستنجح",
            ".هممم، تقريباً! فكر قليلاً أكثر",
            "لا تقلق — أنا هنا معك."
        ]
        case .dutch: return [
            "Geen probleem! Laten we het samen opnieuw proberen.",
            "Dit is moeilijk! Neem je tijd.",
            "Iedereen maakt fouten. Jij kunt het!",
            "Hmm, bijna! Denk nog even na.",
            "Maak je geen zorgen — ik ben bij je."
        ]
        }
    }

    private func secondWrong() -> [String] {
        switch language {
        case .french: return [
            "Essaie de relire la question doucement.",
            "Je t'aide si tu veux — demande un indice !",
            "Rappelle-toi ce qu'on a fait avant — tu le sais !",
            "Respire et relis. La réponse est là !"
        ]
        case .english: return [
            "Try reading the question slowly again.",
            "I can help — ask for a hint!",
            "Remember what we did before — you know this!",
            "Breathe and re-read. The answer is there!"
        ]
        case .spanish: return [
            "Intenta leer la pregunta despacio.",
            "Puedo ayudarte — ¡pide una pista!",
            "Recuerda lo que hicimos antes — ¡lo sabes!",
            "Respira y relee. ¡La respuesta está ahí!"
        ]
        case .portuguese: return [
            "Tenta ler a pergunta devagar.",
            "Posso ajudar — pede uma dica!",
            "Lembra-te do que fizemos antes — sabes isto!",
            "Respira e relê. A resposta está lá!"
        ]
        case .italian: return [
            "Prova a rileggere la domanda lentamente.",
            "Posso aiutarti — chiedi un suggerimento!",
            "Ricorda quello che abbiamo fatto prima — lo sai!",
            "Respira e rileggi. La risposta è lì!"
        ]
        case .german: return [
            "Lies die Frage noch einmal langsam.",
            "Ich helfe dir — frag nach einem Hinweis!",
            "Erinnere dich, was wir vorhin gemacht haben — du weißt das!",
            "Atme und lies nochmal. Die Antwort ist da!"
        ]
        case .arabic: return [
            ".حاول قراءة السؤال ببطء مرة أخرى",
            "!يمكنني مساعدتك — اطلب تلميحاً",
            "!تذكر ما تعلمناه من قبل — أنت تعرف هذا",
            "!تنفس وأعد القراءة. الإجابة موجودة هناك"
        ]
        case .dutch: return [
            "Probeer de vraag langzaam opnieuw te lezen.",
            "Ik kan helpen — vraag een hint!",
            "Herinner je wat we eerder deden — jij weet dit!",
            "Adem en herlees. Het antwoord is er!"
        ]
        }
    }

    private func hint() -> [String] {
        switch language {
        case .french: return [
            "Bien sûr ! Voilà un indice pour toi.",
            "Pas de souci ! Je t'aide.",
            "C'est courageux de demander de l'aide !",
            "Ensemble c'est plus facile. Regarde..."
        ]
        case .english: return [
            "Of course! Here's a hint for you.",
            "No problem! I'll help you.",
            "It's brave to ask for help!",
            "Together it's easier. Look..."
        ]
        case .spanish: return [
            "¡Claro! Aquí tienes una pista.",
            "¡Sin problema! Te ayudo.",
            "¡Es valiente pedir ayuda!",
            "Juntos es más fácil. Mira..."
        ]
        case .portuguese: return [
            "Claro! Aqui está uma dica para ti.",
            "Sem problema! Vou ajudar-te.",
            "É corajoso pedir ajuda!",
            "Juntos é mais fácil. Olha..."
        ]
        case .italian: return [
            "Certo! Ecco un suggerimento per te.",
            "Nessun problema! Ti aiuto.",
            "È coraggioso chiedere aiuto!",
            "Insieme è più facile. Guarda..."
        ]
        case .german: return [
            "Natürlich! Hier ist ein Hinweis für dich.",
            "Kein Problem! Ich helfe dir.",
            "Es ist mutig, um Hilfe zu bitten!",
            "Zusammen ist es leichter. Schau..."
        ]
        case .arabic: return [
            ".بالطبع! إليك تلميح",
            ".لا مشكلة! سأساعدك",
            "!من الشجاعة أن تطلب المساعدة",
            "...معاً الأمر أسهل. انظر"
        ]
        case .dutch: return [
            "Natuurlijk! Hier is een hint voor jou.",
            "Geen probleem! Ik help je.",
            "Het is dapper om om hulp te vragen!",
            "Samen is het makkelijker. Kijk..."
        ]
        }
    }

    private func sessionEnd(correct: Int, total: Int, rate: Int, firstName: String) -> [String] {
        switch language {
        case .french:
            if rate >= 80 { return [
                "\(correct) sur \(total) ! \(firstName), tu es incroyable !",
                "Magnifique session ! \(rate)% — je suis vraiment fier de toi !",
                "Wow \(firstName) ! \(correct) bonnes réponses — tu déchires !"
            ]} else if rate >= 50 { return [
                "\(correct) sur \(total) — bien joué \(firstName) ! On progresse !",
                "Belle session ! Chaque point compte. Tu t'améliores !",
                "Bien \(firstName) ! \(rate)% — on continue de progresser ensemble !"
            ]} else { return [
                "\(correct) sur \(total) \(firstName). C'était dur, mais tu as tenu bon !",
                "Bravo pour l'effort \(firstName) ! La prochaine fois sera meilleure.",
                "Tu as essayé et c'est le plus important \(firstName). Félicitations !"
            ]}
        case .english:
            if rate >= 80 { return [
                "\(correct) out of \(total)! \(firstName), you're incredible!",
                "Amazing session! \(rate)% — I'm really proud of you!",
                "Wow \(firstName)! \(correct) correct — you're smashing it!"
            ]} else if rate >= 50 { return [
                "\(correct) out of \(total) — great job \(firstName)! We're progressing!",
                "Good session! Every point counts. You're improving!",
                "Well done \(firstName)! \(rate)% — let's keep going!"
            ]} else { return [
                "\(correct) out of \(total) \(firstName). It was tough, but you held on!",
                "Well done for trying \(firstName)! Next time will be better.",
                "You tried and that's the most important thing \(firstName)!"
            ]}
        case .spanish:
            if rate >= 80 { return [
                "¡\(correct) de \(total)! ¡\(firstName), eres increíble!",
                "¡Sesión increíble! \(rate)% — ¡estoy muy orgulloso de ti!",
                "¡Wow \(firstName)! \(correct) correctas — ¡lo estás rompiendo!"
            ]} else if rate >= 50 { return [
                "\(correct) de \(total) — ¡bien hecho \(firstName)! ¡Progresamos!",
                "¡Buena sesión! Cada punto cuenta. ¡Estás mejorando!",
                "¡Bien \(firstName)! \(rate)% — ¡sigamos juntos!"
            ]} else { return [
                "\(correct) de \(total) \(firstName). ¡Fue difícil pero lo lograste!",
                "¡Bien por intentarlo \(firstName)! La próxima vez será mejor.",
                "¡Lo intentaste y eso es lo más importante \(firstName)!"
            ]}
        case .portuguese:
            if rate >= 80 { return [
                "\(correct) de \(total)! \(firstName), és incrível!",
                "Sessão fantástica! \(rate)% — estou mesmo orgulhoso de ti!",
                "Uau \(firstName)! \(correct) certas — estás a arrasar!"
            ]} else { return [
                "\(correct) de \(total) — bom trabalho \(firstName)! Estamos a progredir!",
                "Boa sessão! Cada ponto conta. Estás a melhorar!",
                "Bem \(firstName)! \(rate)% — vamos continuar juntos!"
            ]}
        case .italian:
            if rate >= 80 { return [
                "\(correct) su \(total)! \(firstName), sei incredibile!",
                "Sessione fantastica! \(rate)% — sono davvero orgoglioso di te!",
                "Wow \(firstName)! \(correct) corrette — stai dominando!"
            ]} else { return [
                "\(correct) su \(total) — bravo \(firstName)! Stiamo progredendo!",
                "Buona sessione! Ogni punto conta. Stai migliorando!",
                "Bene \(firstName)! \(rate)% — continuiamo insieme!"
            ]}
        case .german:
            if rate >= 80 { return [
                "\(correct) von \(total)! \(firstName), du bist unglaublich!",
                "Fantastische Einheit! \(rate)% — ich bin wirklich stolz auf dich!",
                "Wow \(firstName)! \(correct) richtig — du rockst!"
            ]} else { return [
                "\(correct) von \(total) — gut gemacht \(firstName)! Wir machen Fortschritte!",
                "Gute Einheit! Jeder Punkt zählt. Du wirst besser!",
                "Gut \(firstName)! \(rate)% — lass uns weitermachen!"
            ]}
        case .arabic:
            if rate >= 80 { return [
                "!\(correct) من \(total)! \(firstName)، أنت رائع",
                "!جلسة رائعة! \(rate)٪ — أنا فخور جداً بك",
                "!واو \(firstName)! \(correct) صحيحة — أنت تتألق"
            ]} else { return [
                "!\(correct) من \(total) — عمل جيد \(firstName)! نحن نتقدم",
                "!جلسة جيدة! كل نقطة تحسب. أنت تتحسن",
                "!\(firstName) أحسنت! \(rate)٪ — فلنكمل معاً"
            ]}
        case .dutch:
            if rate >= 80 { return [
                "\(correct) van \(total)! \(firstName), jij bent ongelooflijk!",
                "Fantastische sessie! \(rate)% — ik ben echt trots op jou!",
                "Wauw \(firstName)! \(correct) goed — jij bent geweldig!"
            ]} else { return [
                "\(correct) van \(total) — goed gedaan \(firstName)! We maken vooruitgang!",
                "Goede sessie! Elk punt telt. Je wordt beter!",
                "Goed \(firstName)! \(rate)% — laten we doorgaan!"
            ]}
        }
    }

    private func greetingMorning(firstName: String) -> [String] {
        switch language {
        case .french: return [
            "Bonjour \(firstName) ! Content de te voir aujourd'hui !",
            "Salut \(firstName) ! Prêt(e) pour une super session ?",
            "Hey \(firstName) ! Nouvelle journée, nouvelles victoires !"
        ]
        case .english: return [
            "Good morning \(firstName)! Happy to see you today!",
            "Hey \(firstName)! Ready for a great session?",
            "Hi \(firstName)! New day, new victories!"
        ]
        case .spanish: return [
            "¡Buenos días \(firstName)! ¡Me alegra verte hoy!",
            "¡Hola \(firstName)! ¿Listo para una gran sesión?",
            "¡Hey \(firstName)! ¡Nuevo día, nuevas victorias!"
        ]
        case .portuguese: return [
            "Bom dia \(firstName)! Fico feliz em te ver hoje!",
            "Olá \(firstName)! Pronto para uma ótima sessão?",
            "Oi \(firstName)! Novo dia, novas vitórias!"
        ]
        case .italian: return [
            "Buongiorno \(firstName)! Contento di vederti oggi!",
            "Ciao \(firstName)! Pronto per una sessione fantastica?",
            "Hey \(firstName)! Nuovo giorno, nuove vittorie!"
        ]
        case .german: return [
            "Guten Morgen \(firstName)! Schön, dich heute zu sehen!",
            "Hallo \(firstName)! Bereit für eine tolle Einheit?",
            "Hey \(firstName)! Neuer Tag, neue Siege!"
        ]
        case .arabic: return [
            "!\(firstName) صباح الخير! يسعدني رؤيتك اليوم",
            "!\(firstName) مرحباً! هل أنت مستعد لجلسة رائعة؟",
            "!\(firstName) يوم جديد، انتصارات جديدة"
        ]
        case .dutch: return [
            "Goedemorgen \(firstName)! Blij je vandaag te zien!",
            "Hallo \(firstName)! Klaar voor een geweldige sessie?",
            "Hey \(firstName)! Nieuwe dag, nieuwe overwinningen!"
        ]
        }
    }

    private func greetingReturn(firstName: String, days: Int) -> [String] {
        let d = days == 1 ? lateOneDay() : lateManyDays(days: days)
        return [d]
    }

    private func lateOneDay() -> String {
        switch language {
        case .french:     return "Tu m'as manqué hier ! Content que tu sois là !"
        case .english:    return "I missed you yesterday! Glad you're here!"
        case .spanish:    return "¡Te eché de menos ayer! ¡Me alegra que estés aquí!"
        case .portuguese: return "Fiz saudades de ti ontem! Fico feliz que estejas aqui!"
        case .italian:    return "Mi sei mancato ieri! Contento che tu sia qui!"
        case .german:     return "Ich habe dich gestern vermisst! Schön, dass du da bist!"
        case .arabic:     return "!افتقدتك أمس! سعيد بوجودك هنا"
        case .dutch:      return "Ik heb je gisteren gemist! Fijn dat je er bent!"
        }
    }

    private func lateManyDays(days: Int) -> String {
        switch language {
        case .french:     return "Cela fait \(days) jours ! Bienvenue de retour — j'avais hâte de travailler avec toi !"
        case .english:    return "It's been \(days) days! Welcome back — I was looking forward to working with you!"
        case .spanish:    return "¡Han pasado \(days) días! ¡Bienvenido de vuelta — tenía ganas de trabajar contigo!"
        case .portuguese: return "Já passaram \(days) dias! Bem-vindo de volta — estava ansioso para trabalhar contigo!"
        case .italian:    return "Sono passati \(days) giorni! Bentornato — non vedevo l'ora di lavorare con te!"
        case .german:     return "Es sind \(days) Tage vergangen! Willkommen zurück — ich freute mich darauf, mit dir zu arbeiten!"
        case .arabic:     return "!\(days) أيام مضت! مرحباً بعودتك — كنت أتطلع للعمل معك"
        case .dutch:      return "Het zijn al \(days) dagen! Welkom terug — ik keek ernaar uit om met jou te werken!"
        }
    }

    private func streakCelebration(days: Int) -> [String] {
        switch language {
        case .french: return [
            "\(days) jours de suite ! Tu es une machine \(days == 7 ? "— une semaine complète !" : "!")  ",
            "Incroyable ! \(days) jours sans t'arrêter. Je suis fan !",
            "\(days) jours de série ! On est invincibles ensemble !"
        ]
        case .english: return [
            "\(days) days in a row! You're a machine\(days == 7 ? " — a full week!" : "!")  ",
            "Incredible! \(days) days without stopping. I'm your biggest fan!",
            "\(days)-day streak! We're unstoppable together!"
        ]
        case .spanish: return [
            "¡\(days) días seguidos! ¡Eres una máquina\(days == 7 ? " — ¡una semana completa!" : "!")  ",
            "¡Increíble! \(days) días sin parar. ¡Soy tu fan número uno!",
            "¡\(days) días de racha! ¡Somos imparables juntos!"
        ]
        case .portuguese: return [
            "\(days) dias seguidos! És uma máquina\(days == 7 ? " — uma semana completa!" : "!")  ",
            "Incrível! \(days) dias sem parar. Sou o teu maior fã!",
            "\(days) dias de série! Somos imparáveis juntos!"
        ]
        case .italian: return [
            "\(days) giorni di fila! Sei una macchina\(days == 7 ? " — una settimana intera!" : "!")  ",
            "Incredibile! \(days) giorni senza fermarsi. Sono il tuo fan numero uno!",
            "\(days) giorni di serie! Siamo imbattibili insieme!"
        ]
        case .german: return [
            "\(days) Tage in Folge! Du bist eine Maschine\(days == 7 ? " — eine ganze Woche!" : "!")  ",
            "Unglaublich! \(days) Tage ohne Pause. Ich bin dein größter Fan!",
            "\(days)-Tage-Serie! Zusammen sind wir unschlagbar!"
        ]
        case .arabic: return [
            "!\(days) أيام متتالية! أنت آلة\(days == 7 ? " — أسبوع كامل!" : "")  ",
            "!لا يصدق! \(days) يوماً دون توقف. أنا أكبر معجبيك",
            "!\(days) أيام متواصلة! معاً لا يمكن إيقافنا"
        ]
        case .dutch: return [
            "\(days) dagen op rij! Jij bent een machine\(days == 7 ? " — een hele week!" : "!")  ",
            "Ongelooflijk! \(days) dagen zonder stoppen. Ik ben jouw grootste fan!",
            "\(days)-daagse serie! Samen zijn we onstoppable!"
        ]
        }
    }

    private func encourageStart(firstName: String) -> [String] {
        switch language {
        case .french: return [
            "Allez \(firstName), on peut le faire !",
            "\(firstName), je crois en toi.",
            "Pas de pression \(firstName). On avance à ton rythme."
        ]
        case .english: return [
            "Come on \(firstName), we can do this!",
            "\(firstName), I believe in you.",
            "No pressure \(firstName). We go at your pace."
        ]
        case .spanish: return [
            "¡Vamos \(firstName), podemos hacerlo!",
            "\(firstName), creo en ti.",
            "Sin presión \(firstName). Avanzamos a tu ritmo."
        ]
        case .portuguese: return [
            "Vamos \(firstName), conseguimos!",
            "\(firstName), acredito em ti.",
            "Sem pressão \(firstName). Avançamos ao teu ritmo."
        ]
        case .italian: return [
            "Dai \(firstName), ce la facciamo!",
            "\(firstName), credo in te.",
            "Nessuna pressione \(firstName). Andiamo al tuo ritmo."
        ]
        case .german: return [
            "Los \(firstName), wir schaffen das!",
            "\(firstName), ich glaube an dich.",
            "Kein Druck \(firstName). Wir gehen in deinem Tempo."
        ]
        case .arabic: return [
            "!\(firstName) هيا، يمكننا فعل ذلك",
            ".\(firstName)، أنا أؤمن بك",
            ".\(firstName) لا ضغط. نتقدم بوتيرتك"
        ]
        case .dutch: return [
            "Kom op \(firstName), we kunnen dit!",
            "\(firstName), ik geloof in jou.",
            "Geen druk \(firstName). We gaan op jouw tempo."
        ]
        }
    }

    private func askQuestion(subject: String) -> [String] {
        switch language {
        case .french: return [
            "Tu te souviens de ce qu'on a vu en \(subject) la dernière fois ?",
            "Quelle partie de \(subject) tu préfères ?",
            "Est-ce qu'il y a quelque chose en \(subject) qui te semble difficile ?"
        ]
        case .english: return [
            "Do you remember what we covered in \(subject) last time?",
            "Which part of \(subject) do you like best?",
            "Is there anything in \(subject) that feels difficult for you?"
        ]
        case .spanish: return [
            "¿Recuerdas lo que vimos en \(subject) la última vez?",
            "¿Qué parte de \(subject) te gusta más?",
            "¿Hay algo en \(subject) que te resulte difícil?"
        ]
        case .portuguese: return [
            "Lembras-te do que vimos em \(subject) da última vez?",
            "Qual é a parte de \(subject) que mais gostas?",
            "Há algo em \(subject) que te parece difícil?"
        ]
        case .italian: return [
            "Ti ricordi cosa abbiamo visto in \(subject) l'ultima volta?",
            "Quale parte di \(subject) preferisci?",
            "C'è qualcosa in \(subject) che ti sembra difficile?"
        ]
        case .german: return [
            "Erinnerst du dich, was wir letztes Mal in \(subject) gemacht haben?",
            "Welcher Teil von \(subject) gefällt dir am besten?",
            "Gibt es etwas in \(subject), das dir schwierig vorkommt?"
        ]
        case .arabic: return [
            "هل تتذكر ما تعلمناه في \(subject) في المرة الأخيرة؟",
            "ما الجزء الذي تفضله في \(subject)؟",
            "هل هناك شيء في \(subject) يبدو صعباً بالنسبة لك؟"
        ]
        case .dutch: return [
            "Weet je nog wat we vorige keer bij \(subject) behandeld hebben?",
            "Welk deel van \(subject) vind jij het leukst?",
            "Is er iets in \(subject) dat moeilijk voor je lijkt?"
        ]
        }
    }
}

// MARK: - Émotion de Léo
enum LeoEmotion {
    case neutral, happy, excited, celebrating, caring, supportive, helpful, encouraging, curious

    var emoji: String {
        switch self {
        case .neutral:     return "🧑‍💻"
        case .happy:       return "😊"
        case .excited:     return "🤩"
        case .celebrating: return "🎉"
        case .caring:      return "🤗"
        case .supportive:  return "💪"
        case .helpful:     return "💡"
        case .encouraging: return "🌟"
        case .curious:     return "🤔"
        }
    }

    var color: String {
        switch self {
        case .celebrating: return "accentOrange"
        case .caring, .supportive: return "accentPink"
        case .helpful:     return "accentYellow"
        case .excited:     return "accentPurple"
        default:           return "accentBlue"
        }
    }
}

// MARK: - Bulle de dialogue de Léo (overlay dans les vues)
struct LeoBubbleView: View {
    @ObservedObject var leo: LeoCompanion

    var body: some View {
        if leo.showBubble {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: 10) {
                    // Avatar photo
                    LeoAvatarView(isSpeaking: leo.isSpeaking,
                                  accentColor: Color(leo.emotion.color))

                    // Bulle message
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LeoAvatarView.tutorName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(leo.emotion.color))
                        Text(leo.currentMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)

                        if leo.isSpeaking {
                            HStack(spacing: 3) {
                                ForEach(0..<3) { i in
                                    Circle()
                                        .fill(Color(leo.emotion.color))
                                        .frame(width: 5, height: 5)
                                        .scaleEffect(leo.isSpeaking ? 1.3 : 0.7)
                                        .animation(.easeInOut(duration: 0.5)
                                            .repeatForever()
                                            .delay(Double(i) * 0.15),
                                            value: leo.isSpeaking)
                                }
                            }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color("cardBackground"))
                            .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                    )
                }
            }
            .padding(.horizontal, 16)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .opacity
            ))
        }
    }
}

private extension Animation {
    func repeatWhileTrue(_ condition: Bool) -> Animation {
        condition ? self.repeatForever(autoreverses: true) : self
    }
}

// MARK: - Avatar photo du professeur
struct LeoAvatarView: View {
    let isSpeaking: Bool
    let accentColor: Color

    static let gender    = "female"
    static let tutorName = gender == "female" ? "Léa" : "Léo"

    private static let assetName   = gender == "female" ? "LeoAvatarFemale" : "LeoAvatarMale"
    private static let loadedImage: UIImage? = UIImage(named: assetName)

    @State private var headOffset: CGFloat = 0
    @State private var headScale: CGFloat = 1.0
    @State private var ringScale: CGFloat = 1.0
    @State private var barHeights: [CGFloat] = [4, 6, 4, 8, 4]

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(accentColor.opacity(isSpeaking ? 0.55 : 0.20),
                            lineWidth: isSpeaking ? 3 : 1.5)
                    .frame(width: 60, height: 60)
                    .scaleEffect(ringScale)
                    .animation(
                        isSpeaking
                            ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                            : .easeOut(duration: 0.3),
                        value: ringScale
                    )

                avatarContent
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: .black.opacity(0.18), radius: 5, y: 2)
                    .scaleEffect(headScale)
                    .offset(y: headOffset)
                    .animation(
                        isSpeaking
                            ? .easeInOut(duration: 0.38).repeatForever(autoreverses: true)
                            : .easeOut(duration: 0.25),
                        value: headOffset
                    )
                    .animation(
                        isSpeaking
                            ? .easeInOut(duration: 0.45).repeatForever(autoreverses: true)
                            : .easeOut(duration: 0.25),
                        value: headScale
                    )
            }

            if isSpeaking {
                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor.opacity(0.75))
                            .frame(width: 3, height: barHeights[i])
                            .animation(
                                .easeInOut(duration: Double.random(in: 0.18...0.32))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.07),
                                value: barHeights[i]
                            )
                    }
                }
                .frame(height: 12)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .onChange(of: isSpeaking) { speaking in
            if speaking {
                headOffset = -2.5
                headScale  = 1.025
                ringScale  = 1.12
                barHeights = [8, 12, 6, 14, 8]
            } else {
                headOffset = 0
                headScale  = 1.0
                ringScale  = 1.0
                barHeights = [4, 6, 4, 8, 4]
            }
        }
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let img = Self.loadedImage {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.29, green: 0.56, blue: 0.89),
                             Color(red: 0.18, green: 0.38, blue: 0.72)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Text("L")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Visage humain de Léo (prof bienveillant, SwiftUI Canvas)
struct LeoFaceView: View {
    let isSpeaking: Bool
    let accentColor: Color

    @State private var isBlinking = false
    @State private var mouthOpen  = false

    var body: some View {
        Canvas { ctx, size in
            leoFaceDraw(ctx: ctx, size: size,
                        isBlinking: isBlinking, mouthOpen: mouthOpen,
                        accentColor: accentColor)
        }
        .onAppear { scheduleBlink() }
        .onChange(of: isSpeaking) { speaking in
            if speaking { animateMouth() }
            else { withAnimation(.easeOut(duration: 0.15)) { mouthOpen = false } }
        }
    }

    private func scheduleBlink() {
        let delay = Double.random(in: 2.8...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.linear(duration: 0.07)) { isBlinking = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                withAnimation(.linear(duration: 0.07)) { isBlinking = false }
                scheduleBlink()
            }
        }
    }

    private func animateMouth() {
        guard isSpeaking else { return }
        withAnimation(.easeInOut(duration: 0.20)) { mouthOpen.toggle() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) { animateMouth() }
    }
}

private func leoFaceDraw(ctx: GraphicsContext, size: CGSize,
                          isBlinking: Bool, mouthOpen: Bool, accentColor: Color) {
    let w = size.width, h = size.height
    let cx = w / 2

    // ── Col de chemise ──
    var shirt = Path()
    shirt.move(to: CGPoint(x: cx - w*0.40, y: h))
    shirt.addLine(to: CGPoint(x: cx - w*0.16, y: h*0.88))
    shirt.addLine(to: CGPoint(x: cx - w*0.05, y: h*0.86))
    shirt.addLine(to: CGPoint(x: cx + w*0.05, y: h*0.86))
    shirt.addLine(to: CGPoint(x: cx + w*0.16, y: h*0.88))
    shirt.addLine(to: CGPoint(x: cx + w*0.40, y: h))
    shirt.closeSubpath()
    ctx.fill(shirt, with: .color(Color(red: 0.88, green: 0.92, blue: 1.0)))

    var collarL = Path()
    collarL.move(to: CGPoint(x: cx - w*0.05, y: h*0.86))
    collarL.addLine(to: CGPoint(x: cx - w*0.16, y: h*0.88))
    collarL.addLine(to: CGPoint(x: cx - w*0.40, y: h))
    var collarR = Path()
    collarR.move(to: CGPoint(x: cx + w*0.05, y: h*0.86))
    collarR.addLine(to: CGPoint(x: cx + w*0.16, y: h*0.88))
    collarR.addLine(to: CGPoint(x: cx + w*0.40, y: h))
    let collarStyle = StrokeStyle(lineWidth: max(1, w*0.025), lineCap: .round, lineJoin: .round)
    ctx.stroke(collarL, with: .color(Color(red: 0.60, green: 0.68, blue: 0.85)), style: collarStyle)
    ctx.stroke(collarR, with: .color(Color(red: 0.60, green: 0.68, blue: 0.85)), style: collarStyle)

    // ── Cou ──
    var neck = Path()
    neck.addRect(CGRect(x: cx - w*0.13, y: h*0.76, width: w*0.26, height: h*0.14))
    ctx.fill(neck, with: .color(Color(red: 0.95, green: 0.80, blue: 0.66)))

    // ── Tête ──
    var head = Path()
    head.addEllipse(in: CGRect(x: w*0.07, y: h*0.03, width: w*0.86, height: h*0.82))
    ctx.fill(head, with: .color(Color(red: 0.97, green: 0.83, blue: 0.68)))

    // ── Cheveux ──
    var hairMass = Path()
    hairMass.addEllipse(in: CGRect(x: w*0.08, y: h*0.03, width: w*0.84, height: h*0.44))
    ctx.fill(hairMass, with: .color(Color(red: 0.28, green: 0.17, blue: 0.07)))

    var parting = Path()
    parting.move(to: CGPoint(x: cx - w*0.08, y: h*0.03))
    parting.addQuadCurve(to: CGPoint(x: cx - w*0.12, y: h*0.28),
                          control: CGPoint(x: cx - w*0.14, y: h*0.14))
    ctx.stroke(parting, with: .color(Color(red: 0.97, green: 0.83, blue: 0.68).opacity(0.45)),
               style: StrokeStyle(lineWidth: max(1, w*0.025), lineCap: .round))

    for sign: CGFloat in [-1, 1] {
        var sideHair = Path()
        let sx: CGFloat = sign < 0 ? w*0.07 : w*0.93
        let mx: CGFloat = sign < 0 ? w*0.04 : w*0.96
        sideHair.move(to: CGPoint(x: sx, y: h*0.25))
        sideHair.addQuadCurve(to: CGPoint(x: sx, y: h*0.46),
                               control: CGPoint(x: mx, y: h*0.36))
        ctx.stroke(sideHair, with: .color(Color(red: 0.28, green: 0.17, blue: 0.07)),
                   style: StrokeStyle(lineWidth: max(2, w*0.09), lineCap: .round))
    }

    // ── Joues ──
    for sign: CGFloat in [-1, 1] {
        var cheek = Path()
        cheek.addEllipse(in: CGRect(x: cx + sign*w*0.22 - w*0.11, y: h*0.54,
                                    width: w*0.22, height: h*0.14))
        ctx.fill(cheek, with: .color(Color(red: 1.0, green: 0.72, blue: 0.68).opacity(0.28)))
    }

    // ── Sourcils ──
    let browY = h * 0.41
    for sign: CGFloat in [-1, 1] {
        let bcx = cx + sign * w*0.22
        var brow = Path()
        brow.move(to: CGPoint(x: bcx - w*0.12, y: browY + h*0.01))
        brow.addQuadCurve(to: CGPoint(x: bcx + w*0.12, y: browY),
                           control: CGPoint(x: bcx, y: browY - h*0.028))
        ctx.stroke(brow, with: .color(Color(red: 0.23, green: 0.14, blue: 0.05)),
                   style: StrokeStyle(lineWidth: max(1.5, w*0.038), lineCap: .round))
    }

    // ── Yeux ──
    let eyeY = h * 0.52
    let eyeW = w * 0.20
    let eyeH: CGFloat = isBlinking ? max(1.0, h*0.015) : h*0.13

    for sign: CGFloat in [-1, 1] {
        let ecx = cx + sign * w*0.22
        let eyeRect = CGRect(x: ecx - eyeW/2, y: eyeY - eyeH/2, width: eyeW, height: eyeH)

        var sclera = Path(); sclera.addEllipse(in: eyeRect)
        ctx.fill(sclera, with: .color(.white))

        if !isBlinking {
            let ir = min(eyeW, eyeH) * 0.44
            var iris = Path()
            iris.addEllipse(in: CGRect(x: ecx - ir, y: eyeY - ir, width: ir*2, height: ir*2))
            ctx.fill(iris, with: .color(Color(red: 0.42, green: 0.26, blue: 0.10)))

            let pr = ir * 0.54
            var pupil = Path()
            pupil.addEllipse(in: CGRect(x: ecx - pr, y: eyeY - pr, width: pr*2, height: pr*2))
            ctx.fill(pupil, with: .color(.black))

            var glint = Path()
            glint.addEllipse(in: CGRect(x: ecx - ir*0.22, y: eyeY - ir*0.50,
                                         width: ir*0.34, height: ir*0.34))
            ctx.fill(glint, with: .color(.white.opacity(0.90)))
        }

        var lid = Path(); lid.addEllipse(in: eyeRect.insetBy(dx: -0.5, dy: -0.5))
        ctx.stroke(lid, with: .color(Color(red: 0.18, green: 0.10, blue: 0.04)),
                   lineWidth: max(1.0, w*0.030))
    }

    // ── Nez ──
    let noseBaseY = h * 0.66
    var noseBridge = Path()
    noseBridge.move(to: CGPoint(x: cx + w*0.01, y: eyeY + h*0.07))
    noseBridge.addQuadCurve(to: CGPoint(x: cx - w*0.04, y: noseBaseY),
                             control: CGPoint(x: cx - w*0.07, y: noseBaseY - h*0.04))
    ctx.stroke(noseBridge, with: .color(Color(red: 0.72, green: 0.52, blue: 0.40).opacity(0.55)),
               style: StrokeStyle(lineWidth: 0.9, lineCap: .round))

    for sign: CGFloat in [-1, 1] {
        var nostril = Path()
        nostril.addEllipse(in: CGRect(x: cx + sign*w*0.055 - w*0.025,
                                      y: noseBaseY - h*0.008,
                                      width: w*0.05, height: h*0.028))
        ctx.fill(nostril, with: .color(Color(red: 0.65, green: 0.45, blue: 0.35).opacity(0.50)))
    }

    // ── Bouche ──
    let mouthY = h * 0.77
    let lipColor = Color(red: 0.75, green: 0.38, blue: 0.28)
    let lipStyle = StrokeStyle(lineWidth: max(1.5, w*0.032), lineCap: .round)

    if !mouthOpen {
        var smile = Path()
        smile.move(to: CGPoint(x: cx - w*0.16, y: mouthY))
        smile.addQuadCurve(to: CGPoint(x: cx + w*0.16, y: mouthY),
                            control: CGPoint(x: cx, y: mouthY + h*0.07))
        ctx.stroke(smile, with: .color(lipColor), style: lipStyle)

        for sign: CGFloat in [-1, 1] {
            var dimple = Path()
            let dx = cx + sign * w*0.175
            dimple.addEllipse(in: CGRect(x: dx - w*0.018, y: mouthY - h*0.005,
                                          width: w*0.036, height: h*0.028))
            ctx.fill(dimple, with: .color(Color(red: 0.85, green: 0.65, blue: 0.55).opacity(0.35)))
        }
    } else {
        var mouthPath = Path()
        mouthPath.move(to: CGPoint(x: cx - w*0.15, y: mouthY))
        mouthPath.addQuadCurve(to: CGPoint(x: cx + w*0.15, y: mouthY),
                                control: CGPoint(x: cx, y: mouthY + h*0.10))
        mouthPath.addQuadCurve(to: CGPoint(x: cx - w*0.15, y: mouthY),
                                control: CGPoint(x: cx, y: mouthY + h*0.01))
        mouthPath.closeSubpath()
        ctx.fill(mouthPath, with: .color(Color(red: 0.52, green: 0.14, blue: 0.14)))

        var teeth = Path()
        teeth.addRoundedRect(in: CGRect(x: cx - w*0.12, y: mouthY + h*0.004,
                                         width: w*0.24, height: h*0.038),
                             cornerSize: CGSize(width: 2, height: 2))
        ctx.fill(teeth, with: .color(Color(red: 0.97, green: 0.97, blue: 0.97)))

        ctx.stroke(mouthPath, with: .color(lipColor), style: lipStyle)
    }
}
