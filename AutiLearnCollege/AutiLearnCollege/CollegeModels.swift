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
    case ukrainian  = "Українська"
    case polish     = "Polski"

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
        case .ukrainian:  return "🇺🇦"
        case .polish:     return "🇵🇱"
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
        case .ukrainian:  return "uk-UA"
        case .polish:     return "pl-PL"
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
        case .ukrainian:  return "Українська мова"
        case .polish:     return "Język Polski"
        }
    }

    var foreignSubjectName: String {
        switch self {
        case .english:    return "French"
        case .french:     return "English"
        case .ukrainian:  return "English"
        case .polish:     return "English"
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
        case .ukrainian:  return "Історія"
        case .polish:     return "Historia"
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
        case .ukrainian:  return "Природознавство"
        case .polish:     return "Nauki przyrodnicze"
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
        case .ukrainian:  return "Математика"
        case .polish:     return "Matematyka"
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
        case .ukrainian:  return "Соціальні навички"
        case .polish:     return "Umiejętności społeczne"
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
        case .ukrainian:  return "Культура та оповіді"
        case .polish:     return "Kultura i opowiadania"
        }
    }

    var ui: CollegeUIStrings { CollegeUIStrings(language: self) }

    struct CollegeUIStrings {
        let language: CollegeLanguage

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
        var chooseSubject: String {
            switch language {
            case .french:     return "Choisir une matière"
            case .english:    return "Choose a subject"
            case .spanish:    return "Elegir una asignatura"
            case .portuguese: return "Escolher uma matéria"
            case .italian:    return "Scegli una materia"
            case .german:     return "Fach wählen"
            case .arabic:     return "اختر مادة"
            case .dutch:      return "Kies een vak"
            case .ukrainian:  return "Оберіть предмет"
            case .polish:     return "Wybierz przedmiot"
            }
        }
        var freePlay: String {
            switch language {
            case .french:     return "Jeux libres"
            case .english:    return "Free play"
            case .spanish:    return "Juego libre"
            case .portuguese: return "Jogo livre"
            case .italian:    return "Gioco libero"
            case .german:     return "Freies Spielen"
            case .arabic:     return "لعب حر"
            case .dutch:      return "Vrij spelen"
            case .ukrainian:  return "Вільна гра"
            case .polish:     return "Swobodna gra"
            }
        }
        var freePlayDesc: String {
            switch language {
            case .french:     return "Explore les exercices sans pression, à ton rythme"
            case .english:    return "Explore exercises at your own pace, no pressure"
            case .spanish:    return "Explora ejercicios sin presión, a tu ritmo"
            case .portuguese: return "Explore exercícios sem pressão, ao seu ritmo"
            case .italian:    return "Esplora gli esercizi senza pressione, al tuo ritmo"
            case .german:     return "Übungen ohne Druck in eigenem Tempo erkunden"
            case .arabic:     return "استكشف التمارين بدون ضغط، بوتيرتك الخاصة"
            case .dutch:      return "Verken oefeningen op je eigen tempo, geen druk"
            case .ukrainian:  return "Вивчай вправи без поспіху, у своєму темпі"
            case .polish:     return "Odkrywaj ćwiczenia bez presji, we własnym tempie"
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
            case .french:     return "Suivi des matières, progression, rapport ABA"
            case .english:    return "Subject tracking, progress, ABA report"
            case .spanish:    return "Seguimiento de materias, progresión, informe ABA"
            case .portuguese: return "Acompanhamento de matérias, progresso, relatório ABA"
            case .italian:    return "Materie, progressi, rapporto ABA"
            case .german:     return "Fächer, Fortschritt, ABA-Bericht"
            case .arabic:     return "متابعة المواد، التقدم، تقرير ABA"
            case .dutch:      return "Vakken, voortgang, ABA-rapport"
            case .ukrainian:  return "Предмети, прогрес, звіт ABA"
            case .polish:     return "Przedmioty, postępy, raport ABA"
            }
        }
        var abaTip: String {
            switch language {
            case .french:     return "Conseil ABA"
            case .english:    return "ABA tip"
            case .spanish:    return "Consejo ABA"
            case .portuguese: return "Dica ABA"
            case .italian:    return "Consiglio ABA"
            case .german:     return "ABA-Tipp"
            case .arabic:     return "نصيحة ABA"
            case .dutch:      return "ABA-tip"
            case .ukrainian:  return "Порада ABA"
            case .polish:     return "Wskazówka ABA"
            }
        }
        var leoCompanion: String {
            switch language {
            case .french:     return "Léo, ton compagnon"
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
        var breakOver: String {
            switch language {
            case .french:     return "Terminer la pause"
            case .english:    return "End break"
            case .spanish:    return "Terminar el descanso"
            case .portuguese: return "Terminar a pausa"
            case .italian:    return "Fine pausa"
            case .german:     return "Pause beenden"
            case .arabic:     return "إنهاء الاستراحة"
            case .dutch:      return "Pauze beëindigen"
            case .ukrainian:  return "Завершити перерву"
            case .polish:     return "Zakończ przerwę"
            }
        }
        var wrongCode: String {
            switch language {
            case .french:     return "Code incorrect."
            case .english:    return "Wrong code."
            case .spanish:    return "Código incorrecto."
            case .portuguese: return "Código incorreto."
            case .italian:    return "Codice errato."
            case .german:     return "Falscher Code."
            case .arabic:     return "رمز خاطئ."
            case .dutch:      return "Verkeerde code."
            case .ukrainian:  return "Невірний код."
            case .polish:     return "Błędny kod."
            }
        }
        var changeLevel: String {
            switch language {
            case .french:     return "Changer de niveau"
            case .english:    return "Change level"
            case .spanish:    return "Cambiar nivel"
            case .portuguese: return "Mudar de nível"
            case .italian:    return "Cambia livello"
            case .german:     return "Stufe wechseln"
            case .arabic:     return "تغيير المستوى"
            case .dutch:      return "Niveau wijzigen"
            case .ukrainian:  return "Змінити рівень"
            case .polish:     return "Zmień poziom"
            }
        }
        var notStarted: String {
            switch language {
            case .french:     return "Pas encore commencé"
            case .english:    return "Not started yet"
            case .spanish:    return "Aún no empezado"
            case .portuguese: return "Ainda não iniciado"
            case .italian:    return "Non ancora iniziato"
            case .german:     return "Noch nicht begonnen"
            case .arabic:     return "لم يبدأ بعد"
            case .dutch:      return "Nog niet begonnen"
            case .ukrainian:  return "Ще не розпочато"
            case .polish:     return "Jeszcze nie rozpoczęto"
            }
        }
        var validate: String {
            switch language {
            case .french:     return "Valider"
            case .english:    return "Validate"
            case .spanish:    return "Validar"
            case .portuguese: return "Validar"
            case .italian:    return "Valida"
            case .german:     return "Bestätigen"
            case .arabic:     return "تأكيد"
            case .dutch:      return "Bevestigen"
            case .ukrainian:  return "Підтвердити"
            case .polish:     return "Zatwierdź"
            }
        }
        var answerAloud: String {
            switch language {
            case .french:     return "Réponds à voix haute"
            case .english:    return "Answer aloud"
            case .spanish:    return "Responde en voz alta"
            case .portuguese: return "Responda em voz alta"
            case .italian:    return "Rispondi ad alta voce"
            case .german:     return "Laut antworten"
            case .arabic:     return "أجب بصوت عالٍ"
            case .dutch:      return "Antwoord hardop"
            case .ukrainian:  return "Відповідай вголос"
            case .polish:     return "Odpowiedz na głos"
            }
        }
        var formAnswer: String {
            switch language {
            case .french:     return "Prends le temps de formuler ta réponse en une ou deux phrases complètes."
            case .english:    return "Take time to formulate your answer in one or two complete sentences."
            case .spanish:    return "Tómate el tiempo para formular tu respuesta en una o dos frases completas."
            case .portuguese: return "Reserve um tempo para formular sua resposta em uma ou duas frases completas."
            case .italian:    return "Prenditi il tempo per formulare la tua risposta in una o due frasi complete."
            case .german:     return "Nimm dir Zeit, deine Antwort in einem oder zwei vollständigen Sätzen zu formulieren."
            case .arabic:     return "خذ وقتك لصياغة إجابتك في جملة أو جملتين كاملتين."
            case .dutch:      return "Neem de tijd om je antwoord in één of twee volledige zinnen te formuleren."
            case .ukrainian:  return "Візьми час, щоб сформулювати відповідь у одному-двох реченнях."
            case .polish:     return "Poświęć czas na sformułowanie odpowiedzi w jednym lub dwóch zdaniach."
            }
        }
        var backToSubjects: String {
            switch language {
            case .french:     return "Retour aux matières"
            case .english:    return "Back to subjects"
            case .spanish:    return "Volver a las asignaturas"
            case .portuguese: return "Voltar às matérias"
            case .italian:    return "Torna alle materie"
            case .german:     return "Zurück zu den Fächern"
            case .arabic:     return "العودة للمواد"
            case .dutch:      return "Terug naar vakken"
            case .ukrainian:  return "Повернутися до предметів"
            case .polish:     return "Wróć do przedmiotów"
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
        var excellent: String {
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
        var almostRight: String {
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
        var wellPlayedPrefix: String {
            switch language {
            case .french:     return "Bien joué"
            case .english:    return "Well played"
            case .spanish:    return "¡Bien jugado"
            case .portuguese: return "Bem jogado"
            case .italian:    return "Ben fatto"
            case .german:     return "Gut gespielt"
            case .arabic:     return "أحسنت"
            case .dutch:      return "Goed gespeeld"
            case .ukrainian:  return "Молодець"
            case .polish:     return "Świetna robota"
            }
        }
        var breakEarnedDesc: String {
            switch language {
            case .french:     return "Tu as gagné ta pause de 5 minutes.\nChoisis ce que tu veux faire."
            case .english:    return "You've earned your 5-minute break.\nChoose what you want to do."
            case .spanish:    return "Te has ganado tu descanso de 5 minutos.\nElige lo que quieres hacer."
            case .portuguese: return "Você ganhou sua pausa de 5 minutos.\nEscolha o que quer fazer."
            case .italian:    return "Hai guadagnato la tua pausa di 5 minuti.\nScegli cosa vuoi fare."
            case .german:     return "Du hast deine 5-Minuten-Pause verdient.\nWähle, was du tun möchtest."
            case .arabic:     return "لقد استحققت استراحتك من 5 دقائق.\nاختر ما تريد فعله."
            case .dutch:      return "Je hebt je 5-minutenpauze verdiend.\nKies wat je wil doen."
            case .ukrainian:  return "Ти заробив(ла) 5-хвилинну перерву.\nОбери чим хочеш зайнятись."
            case .polish:     return "Zasłużyłeś/aś na 5-minutową przerwę.\nWybierz co chcesz zrobić."
            }
        }
        var starsLabel: String {
            switch language {
            case .french:     return "étoiles"
            case .english:    return "stars"
            case .spanish:    return "estrellas"
            case .portuguese: return "estrelas"
            case .italian:    return "stelle"
            case .german:     return "Sterne"
            case .arabic:     return "النجوم"
            case .dutch:      return "sterren"
            case .ukrainian:  return "зірки"
            case .polish:     return "gwiazdki"
            }
        }
        var successRateLabel: String {
            switch language {
            case .french:     return "réussite récente"
            case .english:    return "recent success"
            case .spanish:    return "éxito reciente"
            case .portuguese: return "sucesso recente"
            case .italian:    return "successo recente"
            case .german:     return "aktueller Erfolg"
            case .arabic:     return "النجاح الأخير"
            case .dutch:      return "recent succes"
            case .ukrainian:  return "нещодавній успіх"
            case .polish:     return "ostatni sukces"
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
        func starsUntilBreak(_ n: Int) -> String {
            switch language {
            case .french:     return "Encore \(n) étoile\(n > 1 ? "s" : "") → pause mérité !"
            case .english:    return "\(n) more star\(n > 1 ? "s" : "") → earned break!"
            case .spanish:    return "¡Aún \(n) estrella\(n > 1 ? "s" : "") → descanso merecido!"
            case .portuguese: return "Mais \(n) estrela\(n > 1 ? "s" : "") → pausa merecida!"
            case .italian:    return "Ancora \(n) stella\(n > 1 ? "e" : "") → pausa meritata!"
            case .german:     return "Noch \(n) Stern\(n > 1 ? "e" : "") → verdiente Pause!"
            case .arabic:     return "بعد \(n) نجمة → استراحة مستحقة!"
            case .dutch:      return "Nog \(n) ster\(n > 1 ? "ren" : "") → verdiende pauze!"
            case .ukrainian:  return "Ще \(n) зірку(и) → заслужена перерва!"
            case .polish:     return "Jeszcze \(n) gwiazdkę(i) → zasłużona przerwa!"
            }
        }
        func wellPlayed(_ name: String) -> String { "\(wellPlayedPrefix) \(name) !" }

        var mastered: String {
            switch language {
            case .french:     return "Maîtrisé"
            case .english:    return "Mastered"
            case .spanish:    return "Dominado"
            case .portuguese: return "Dominado"
            case .italian:    return "Padroneggiato"
            case .german:     return "Beherrscht"
            case .arabic:     return "متقن"
            case .dutch:      return "Beheerst"
            case .ukrainian:  return "Засвоєно"
            case .polish:     return "Opanowane"
            }
        }
        var inProgress: String {
            switch language {
            case .french:     return "En progrès"
            case .english:    return "In progress"
            case .spanish:    return "En progreso"
            case .portuguese: return "Em progresso"
            case .italian:    return "In corso"
            case .german:     return "In Bearbeitung"
            case .arabic:     return "في تقدم"
            case .dutch:      return "In uitvoering"
            case .ukrainian:  return "В процесі"
            case .polish:     return "W trakcie"
            }
        }
        var toWork: String {
            switch language {
            case .french:     return "À travailler"
            case .english:    return "Needs work"
            case .spanish:    return "A trabajar"
            case .portuguese: return "A trabalhar"
            case .italian:    return "Da migliorare"
            case .german:     return "Zu üben"
            case .arabic:     return "يحتاج تحسين"
            case .dutch:      return "Te verbeteren"
            case .ukrainian:  return "Потребує роботи"
            case .polish:     return "Do pracy"
            }
        }
        var encouragementMessages: [String] {
            switch language {
            case .french:     return ["On bosse ensemble aujourd'hui !", "Chaque bonne réponse compte — allez !", "Tu progresses, c'est ce qui compte.", "Une matière à la fois. Tu gères.", "Prêt(e) ? Moi aussi !"]
            case .english:    return ["We're working together today!", "Every right answer counts — let's go!", "You're improving, that's what matters.", "One subject at a time. You've got this.", "Ready? Me too!"]
            case .spanish:    return ["¡Trabajamos juntos hoy!", "Cada respuesta correcta cuenta — ¡vamos!", "Estás progresando, eso es lo que importa.", "Una asignatura a la vez. Tú puedes.", "¿Listo/a? ¡Yo también!"]
            case .portuguese: return ["Estamos trabalhando juntos hoje!", "Cada resposta certa conta — vamos!", "Você está progredindo, isso é o que importa.", "Uma matéria de cada vez. Você consegue.", "Pronto(a)? Eu também!"]
            case .italian:    return ["Lavoriamo insieme oggi!", "Ogni risposta giusta conta — andiamo!", "Stai progredendo, è questo che conta.", "Una materia alla volta. Ce la fai.", "Pronto/a? Anch'io!"]
            case .german:     return ["Wir arbeiten heute zusammen!", "Jede richtige Antwort zählt — los geht's!", "Du machst Fortschritte, das ist wichtig.", "Ein Fach nach dem anderen. Du schaffst das.", "Bereit? Ich auch!"]
            case .arabic:     return ["نعمل معاً اليوم!", "كل إجابة صحيحة تُحسب — هيا!", "أنت تتقدم، هذا هو المهم.", "مادة واحدة في كل مرة. أنت تستطيع.", "مستعد(ة)؟ أنا أيضاً!"]
            case .dutch:      return ["We werken vandaag samen!", "Elke juiste antwoord telt — kom op!", "Je maakt vooruitgang, dat is wat telt.", "Één vak tegelijk. Je kunt het.", "Klaar? Ik ook!"]
            case .ukrainian:  return ["Сьогодні працюємо разом!", "Кожна правильна відповідь має значення!", "Ти прогресуєш — це головне.", "По одному предмету. Ти справляєшся.", "Готовий/а? Я теж!"]
            case .polish:     return ["Dziś pracujemy razem!", "Każda dobra odpowiedź się liczy — do dzieła!", "Robisz postępy, to się liczy.", "Jeden przedmiot na raz. Dasz radę.", "Gotowy/a? Ja też!"]
            }
        }
        func abaTipMessage(emptySessions: Bool, rate: Double) -> String {
            switch language {
            case .french:
                if emptySessions { return "Commence ta première session ! Chaque étape compte." }
                else if rate >= 0.8 { return "Excellent ! Tu maîtrises bien les matières. Continue à ce rythme !" }
                else if rate >= 0.6 { return "Bien ! N'hésite pas à utiliser les indices pour progresser." }
                else { return "Chaque exercice t'aide à progresser. Reprends les matières difficiles." }
            case .english:
                if emptySessions { return "Start your first session! Every step counts." }
                else if rate >= 0.8 { return "Excellent! You master the subjects well. Keep it up!" }
                else if rate >= 0.6 { return "Good! Don't hesitate to use hints to improve." }
                else { return "Every exercise helps you progress. Revisit the harder subjects." }
            case .spanish:
                if emptySessions { return "¡Empieza tu primera sesión! Cada paso cuenta." }
                else if rate >= 0.8 { return "¡Excelente! Dominas bien las asignaturas. ¡Sigue así!" }
                else if rate >= 0.6 { return "¡Bien! No dudes en usar las pistas para progresar." }
                else { return "Cada ejercicio te ayuda a progresar. Retoma las asignaturas difíciles." }
            case .portuguese:
                if emptySessions { return "Comece sua primeira sessão! Cada passo conta." }
                else if rate >= 0.8 { return "Excelente! Você domina bem as matérias. Continue!" }
                else if rate >= 0.6 { return "Bem! Use as dicas para progredir." }
                else { return "Cada exercício ajuda a progredir. Retome as matérias difíceis." }
            case .italian:
                if emptySessions { return "Inizia la tua prima sessione! Ogni passo conta." }
                else if rate >= 0.8 { return "Eccellente! Padroneggi bene le materie. Continua così!" }
                else if rate >= 0.6 { return "Bene! Non esitare a usare gli indizi per migliorare." }
                else { return "Ogni esercizio ti aiuta a progredire. Riprendi le materie difficili." }
            case .german:
                if emptySessions { return "Starte deine erste Session! Jeder Schritt zählt." }
                else if rate >= 0.8 { return "Ausgezeichnet! Du beherrschst die Fächer gut. Weiter so!" }
                else if rate >= 0.6 { return "Gut! Nutze die Hinweise, um Fortschritte zu machen." }
                else { return "Jede Übung hilft dir. Übe die schwierigeren Fächer erneut." }
            case .arabic:
                if emptySessions { return "ابدأ جلستك الأولى! كل خطوة تُحسب." }
                else if rate >= 0.8 { return "ممتاز! أنت تتقن المواد جيداً. استمر بهذا الإيقاع!" }
                else if rate >= 0.6 { return "جيد! لا تتردد في استخدام التلميحات للتقدم." }
                else { return "كل تمرين يساعدك على التقدم. راجع المواد الصعبة." }
            case .dutch:
                if emptySessions { return "Begin je eerste sessie! Elke stap telt." }
                else if rate >= 0.8 { return "Uitstekend! Je beheerst de vakken goed. Ga zo door!" }
                else if rate >= 0.6 { return "Goed! Gebruik gerust de hints om vooruit te komen." }
                else { return "Elke oefening helpt je vooruit. Herhaal de moeilijke vakken." }
            case .ukrainian:
                if emptySessions { return "Почни першу сесію! Кожен крок важливий." }
                else if rate >= 0.8 { return "Чудово! Ти добре засвоїв(ла) предмети. Так тримати!" }
                else if rate >= 0.6 { return "Добре! Використовуй підказки, щоб прогресувати." }
                else { return "Кожна вправа допомагає. Поверніться до важких предметів." }
            case .polish:
                if emptySessions { return "Zacznij pierwszą sesję! Każdy krok się liczy." }
                else if rate >= 0.8 { return "Doskonale! Dobrze opanowujesz przedmioty. Tak trzymaj!" }
                else if rate >= 0.6 { return "Dobrze! Korzystaj z podpowiedzi, żeby postępować." }
                else { return "Każde ćwiczenie pomaga. Wróć do trudniejszych przedmiotów." }
            }
        }
        var yourAnswer: String {
            switch language {
            case .french:     return "Ta réponse..."
            case .english:    return "Your answer..."
            case .spanish:    return "Tu respuesta..."
            case .portuguese: return "Sua resposta..."
            case .italian:    return "La tua risposta..."
            case .german:     return "Deine Antwort..."
            case .arabic:     return "إجابتك..."
            case .dutch:      return "Jouw antwoord..."
            case .ukrainian:  return "Твоя відповідь..."
            case .polish:     return "Twoja odpowiedź..."
            }
        }
        var answerRecorded: String {
            switch language {
            case .french:     return "Réponse enregistrée ✓"
            case .english:    return "Answer recorded ✓"
            case .spanish:    return "Respuesta registrada ✓"
            case .portuguese: return "Resposta registada ✓"
            case .italian:    return "Risposta registrata ✓"
            case .german:     return "Antwort aufgezeichnet ✓"
            case .arabic:     return "تم تسجيل الإجابة ✓"
            case .dutch:      return "Antwoord opgenomen ✓"
            case .ukrainian:  return "Відповідь записано ✓"
            case .polish:     return "Odpowiedź zapisana ✓"
            }
        }
        var iAnsweredAloud: String {
            switch language {
            case .french:     return "J'ai répondu à voix haute"
            case .english:    return "I answered aloud"
            case .spanish:    return "Respondí en voz alta"
            case .portuguese: return "Respondi em voz alta"
            case .italian:    return "Ho risposto ad alta voce"
            case .german:     return "Ich habe laut geantwortet"
            case .arabic:     return "أجبت بصوت عالٍ"
            case .dutch:      return "Ik heb hardop geantwoord"
            case .ukrainian:  return "Я відповів(ла) вголос"
            case .polish:     return "Odpowiedziałem/am na głos"
            }
        }
        var goodAnswer: String {
            switch language {
            case .french:     return "Bonne réponse !"
            case .english:    return "Correct answer!"
            case .spanish:    return "¡Respuesta correcta!"
            case .portuguese: return "Resposta correta!"
            case .italian:    return "Risposta giusta!"
            case .german:     return "Richtige Antwort!"
            case .arabic:     return "إجابة صحيحة!"
            case .dutch:      return "Goed antwoord!"
            case .ukrainian:  return "Правильна відповідь!"
            case .polish:     return "Dobra odpowiedź!"
            }
        }
        var correctAnswerWas: String {
            switch language {
            case .french:     return "La bonne réponse était :"
            case .english:    return "The correct answer was:"
            case .spanish:    return "La respuesta correcta era:"
            case .portuguese: return "A resposta correta era:"
            case .italian:    return "La risposta corretta era:"
            case .german:     return "Die richtige Antwort war:"
            case .arabic:     return "كانت الإجابة الصحيحة:"
            case .dutch:      return "Het juiste antwoord was:"
            case .ukrainian:  return "Правильна відповідь була:"
            case .polish:     return "Prawidłowa odpowiedź brzmiała:"
            }
        }
        var seeResults: String {
            switch language {
            case .french:     return "Voir mes résultats"
            case .english:    return "See my results"
            case .spanish:    return "Ver mis resultados"
            case .portuguese: return "Ver meus resultados"
            case .italian:    return "Vedi i miei risultati"
            case .german:     return "Meine Ergebnisse sehen"
            case .arabic:     return "عرض نتائجي"
            case .dutch:      return "Mijn resultaten zien"
            case .ukrainian:  return "Переглянути результати"
            case .polish:     return "Zobacz wyniki"
            }
        }
        var nextQuestion: String {
            switch language {
            case .french:     return "Question suivante →"
            case .english:    return "Next question →"
            case .spanish:    return "Siguiente pregunta →"
            case .portuguese: return "Próxima pergunta →"
            case .italian:    return "Domanda successiva →"
            case .german:     return "Nächste Frage →"
            case .arabic:     return "السؤال التالي →"
            case .dutch:      return "Volgende vraag →"
            case .ukrainian:  return "Наступне питання →"
            case .polish:     return "Następne pytanie →"
            }
        }
        var excellentWork: String {
            switch language {
            case .french:     return "Excellent travail !"
            case .english:    return "Excellent work!"
            case .spanish:    return "¡Excelente trabajo!"
            case .portuguese: return "Excelente trabalho!"
            case .italian:    return "Ottimo lavoro!"
            case .german:     return "Ausgezeichnete Arbeit!"
            case .arabic:     return "عمل ممتاز!"
            case .dutch:      return "Uitstekend werk!"
            case .ukrainian:  return "Чудова робота!"
            case .polish:     return "Doskonała praca!"
            }
        }
        var keepTrying: String {
            switch language {
            case .french:     return "Continue tes efforts !"
            case .english:    return "Keep it up!"
            case .spanish:    return "¡Sigue esforzándote!"
            case .portuguese: return "Continue se esforçando!"
            case .italian:    return "Continua così!"
            case .german:     return "Weiter so!"
            case .arabic:     return "استمر في المحاولة!"
            case .dutch:      return "Blijf doorgaan!"
            case .ukrainian:  return "Продовжуй старатися!"
            case .polish:     return "Nie poddawaj się!"
            }
        }
        var successLabel: String {
            switch language {
            case .french:     return "Réussite"
            case .english:    return "Success"
            case .spanish:    return "Éxito"
            case .portuguese: return "Sucesso"
            case .italian:    return "Successo"
            case .german:     return "Erfolg"
            case .arabic:     return "النجاح"
            case .dutch:      return "Succes"
            case .ukrainian:  return "Успіх"
            case .polish:     return "Sukces"
            }
        }
        var correctLabel: String {
            switch language {
            case .french:     return "Correct"
            case .english:    return "Correct"
            case .spanish:    return "Correcto"
            case .portuguese: return "Correto"
            case .italian:    return "Corretto"
            case .german:     return "Richtig"
            case .arabic:     return "صحيح"
            case .dutch:      return "Correct"
            case .ukrainian:  return "Правильно"
            case .polish:     return "Poprawne"
            }
        }
        var breakActivities: [(String, String)] {
            switch language {
            case .french:     return [("🎮", "Jeu libre — 5 minutes"), ("🎵", "Musique ou podcast"), ("🚶", "Bouger — 5 min de marche"), ("📱", "Pause écran choisie")]
            case .english:    return [("🎮", "Free game — 5 minutes"), ("🎵", "Music or podcast"), ("🚶", "Move — 5 min walk"), ("📱", "Screen break of your choice")]
            case .spanish:    return [("🎮", "Juego libre — 5 minutos"), ("🎵", "Música o podcast"), ("🚶", "Moverse — 5 min de paseo"), ("📱", "Pausa de pantalla elegida")]
            case .portuguese: return [("🎮", "Jogo livre — 5 minutos"), ("🎵", "Música ou podcast"), ("🚶", "Mover — 5 min de caminhada"), ("📱", "Pausa de ecrã escolhida")]
            case .italian:    return [("🎮", "Gioco libero — 5 minuti"), ("🎵", "Musica o podcast"), ("🚶", "Muoversi — 5 min di cammino"), ("📱", "Pausa schermo scelta")]
            case .german:     return [("🎮", "Freies Spiel — 5 Minuten"), ("🎵", "Musik oder Podcast"), ("🚶", "Bewegen — 5 min Spaziergang"), ("📱", "Gewählte Bildschirmpause")]
            case .arabic:     return [("🎮", "لعبة حرة — 5 دقائق"), ("🎵", "موسيقى أو بودكاست"), ("🚶", "تحرك — 5 دقائق مشي"), ("📱", "استراحة شاشة مختارة")]
            case .dutch:      return [("🎮", "Vrij spel — 5 minuten"), ("🎵", "Muziek of podcast"), ("🚶", "Bewegen — 5 min wandelen"), ("📱", "Gekozen schermpauze")]
            case .ukrainian:  return [("🎮", "Вільна гра — 5 хвилин"), ("🎵", "Музика або подкаст"), ("🚶", "Рухатися — 5 хв прогулянки"), ("📱", "Обрана пауза від екрану")]
            case .polish:     return [("🎮", "Swobodna gra — 5 minut"), ("🎵", "Muzyka lub podcast"), ("🚶", "Ruch — 5 min spaceru"), ("📱", "Wybrana przerwa od ekranu")]
            }
        }
        var dailySteps: [(String, String, String)] {
            switch language {
            case .french:     return [("😊", "Comment tu te sens ?", "accentYellow"), ("🗣️", "Communication sociale", "accentOrange"), ("📝", "Français", "accentPurple"), ("🔢", "Maths", "accentBlue"), ("🎉", "Pause méritée !", "accentPink")]
            case .english:    return [("😊", "How are you feeling?", "accentYellow"), ("🗣️", "Social communication", "accentOrange"), ("📝", "English", "accentPurple"), ("🔢", "Maths", "accentBlue"), ("🎉", "Earned break!", "accentPink")]
            case .spanish:    return [("😊", "¿Cómo te sientes?", "accentYellow"), ("🗣️", "Comunicación social", "accentOrange"), ("📝", "Español", "accentPurple"), ("🔢", "Matemáticas", "accentBlue"), ("🎉", "¡Pausa merecida!", "accentPink")]
            case .portuguese: return [("😊", "Como te sentes?", "accentYellow"), ("🗣️", "Comunicação social", "accentOrange"), ("📝", "Português", "accentPurple"), ("🔢", "Matemática", "accentBlue"), ("🎉", "Pausa merecida!", "accentPink")]
            case .italian:    return [("😊", "Come ti senti?", "accentYellow"), ("🗣️", "Comunicazione sociale", "accentOrange"), ("📝", "Italiano", "accentPurple"), ("🔢", "Matematica", "accentBlue"), ("🎉", "Pausa meritata!", "accentPink")]
            case .german:     return [("😊", "Wie geht es dir?", "accentYellow"), ("🗣️", "Soziale Kommunikation", "accentOrange"), ("📝", "Deutsch", "accentPurple"), ("🔢", "Mathematik", "accentBlue"), ("🎉", "Verdiente Pause!", "accentPink")]
            case .arabic:     return [("😊", "كيف تشعر؟", "accentYellow"), ("🗣️", "التواصل الاجتماعي", "accentOrange"), ("📝", "اللغة العربية", "accentPurple"), ("🔢", "الرياضيات", "accentBlue"), ("🎉", "استراحة مستحقة!", "accentPink")]
            case .dutch:      return [("😊", "Hoe voel je je?", "accentYellow"), ("🗣️", "Sociale communicatie", "accentOrange"), ("📝", "Nederlands", "accentPurple"), ("🔢", "Wiskunde", "accentBlue"), ("🎉", "Verdiende pauze!", "accentPink")]
            case .ukrainian:  return [("😊", "Як ти почуваєшся?", "accentYellow"), ("🗣️", "Соціальне спілкування", "accentOrange"), ("📝", "Українська", "accentPurple"), ("🔢", "Математика", "accentBlue"), ("🎉", "Заслужена перерва!", "accentPink")]
            case .polish:     return [("😊", "Jak się czujesz?", "accentYellow"), ("🗣️", "Komunikacja społeczna", "accentOrange"), ("📝", "Język polski", "accentPurple"), ("🔢", "Matematyka", "accentBlue"), ("🎉", "Zasłużona przerwa!", "accentPink")]
            }
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
