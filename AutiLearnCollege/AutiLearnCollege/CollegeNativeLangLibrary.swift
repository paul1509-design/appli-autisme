import Foundation

// MARK: - Langue nationale par pays (grammaire + littérature)
struct CollegeNativeLangLibrary {

    static func exercises(level: CollegeLevel, language: CollegeLanguage) -> [CollegeExercise] {
        switch language {
        case .french:     return french(level)
        case .english:    return english(level)
        case .spanish:    return spanish(level)
        case .portuguese: return portuguese(level)
        case .italian:    return italian(level)
        case .german:     return german(level)
        case .arabic:     return arabic(level)
        case .dutch:      return dutch(level)
        }
    }

    private static func ex(_ q: String, _ choices: [String], _ answer: String,
                            _ explanation: String, _ emoji: String, _ diff: Int) -> CollegeExercise {
        let isTF = choices.count == 2 && (choices.contains("Vrai") || choices.contains("True") ||
                   choices.contains("Verdad") || choices.contains("Vero") || choices.contains("Wahr") ||
                   choices.contains("Waar") || choices.contains("صح"))
        return CollegeExercise(subject: .francais,
                               mode: choices.isEmpty ? .shortAnswer : (isTF ? .trueFalse : .multipleChoice),
                               question: q, choices: choices, correctAnswer: answer,
                               explanation: explanation, emoji: emoji, difficulty: diff)
    }

    // MARK: - 🇫🇷 Français (programme France)
    private static func french(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Quel est le sujet dans : « Le chat mange la souris » ?",
               ["Le chat", "mange", "la souris", "Le"], "Le chat",
               "Le sujet indique qui fait l'action. 'Le chat' réalise l'action de 'manger'.", "🐱", 1),
            ex("Un nom propre prend toujours une majuscule.",
               ["Vrai", "Faux"], "Vrai",
               "Les noms propres (personnes, villes, pays) ont toujours une majuscule en français.", "✍️", 1),
            ex("Qu'est-ce qu'un synonyme ?",
               ["Un mot de même sens", "Un mot contraire", "Un mot qui rime", "Un mot étranger"], "Un mot de même sens",
               "Un synonyme est un mot qui a le même sens qu'un autre. Ex : content = heureux.", "📖", 1),
            ex("Le pluriel de 'journal' est :",
               ["journaux", "journals", "journeaux", "journels"], "journaux",
               "Les mots en -al font leur pluriel en -aux : journal → journaux.", "📰", 2),
            ex("Qu'est-ce qu'une métaphore ?",
               ["Une comparaison sans 'comme'", "Une comparaison avec 'comme'", "Un mot inventé", "Une répétition"], "Une comparaison sans 'comme'",
               "La métaphore compare sans outil de comparaison. Ex : « Il est un lion ».", "🦁", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Qu'est-ce qu'un oxymore ?",
                   ["Deux mots contraires ensemble", "Une répétition", "Un mot rare", "Une question rhétorique"], "Deux mots contraires ensemble",
                   "L'oxymore associe deux mots de sens contraires. Ex : « une obscure clarté ».", "✨", 3),
                ex("Le subjonctif est utilisé pour exprimer :",
                   ["Un doute ou un souhait", "Une certitude", "Le passé", "Une question"], "Un doute ou un souhait",
                   "Ex : « Il faut que tu viennes. » Le subjonctif exprime le doute, le souhait, la nécessité.", "❓", 3),
                ex("Donne un exemple de figure de style et son nom.", [], "Métaphore : « La vie est un long fleuve tranquille »",
                   "Les figures de style enrichissent le langage : métaphore, comparaison, hyperbole, anaphore, etc.", "🎭", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("Quel auteur a écrit « Les Misérables » ?",
                   ["Victor Hugo", "Flaubert", "Zola", "Balzac"], "Victor Hugo",
                   "Les Misérables (1862) de Victor Hugo suit Jean Valjean dans la France du XIXe siècle.", "📚", 2),
                ex("Le mouvement littéraire du Naturalisme est associé à :",
                   ["Émile Zola", "Victor Hugo", "Molière", "Voltaire"], "Émile Zola",
                   "Zola est le chef de file du Naturalisme, courant qui applique la méthode scientifique à la littérature.", "🔬", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇬🇧 English Literature & Language
    private static func english(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("What is the subject in: 'The dog chases the cat'?",
               ["The dog", "chases", "the cat", "dog"], "The dog",
               "The subject performs the action. 'The dog' does the chasing.", "🐕", 1),
            ex("True or False: Nouns always start with a capital letter in English.",
               ["True", "False"], "False",
               "In English, only proper nouns (names, places, nationalities) are capitalised.", "✍️", 1),
            ex("What is a synonym?",
               ["A word with the same meaning", "A word with the opposite meaning", "A rhyming word", "A made-up word"], "A word with the same meaning",
               "A synonym is a word with the same or similar meaning. E.g. happy = joyful.", "📖", 1),
            ex("What literary device is used in: 'The wind whispered through the trees'?",
               ["Personification", "Simile", "Metaphor", "Alliteration"], "Personification",
               "Personification gives human qualities to non-human things. The wind cannot actually whisper.", "🌬️", 2),
            ex("A simile compares using:",
               ["'like' or 'as'", "No comparison word", "Exaggeration", "Repetition"], "'like' or 'as'",
               "A simile makes a direct comparison using 'like' or 'as'. E.g. 'He ran like the wind.'", "⚡", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Who wrote Romeo and Juliet?",
                   ["William Shakespeare", "Charles Dickens", "Jane Austen", "Geoffrey Chaucer"], "William Shakespeare",
                   "Romeo and Juliet (c.1595) is one of Shakespeare's most famous tragedies.", "🎭", 2),
                ex("What is an iambic pentameter?",
                   ["A line of verse with 10 syllables, alternating unstressed and stressed", "A type of rhyme scheme", "A form of prose", "A narrative technique"], "A line of verse with 10 syllables, alternating unstressed and stressed",
                   "Iambic pentameter: da-DUM da-DUM da-DUM da-DUM da-DUM — Shakespeare's signature rhythm.", "🎵", 3),
                ex("In 'To Kill a Mockingbird', who is the narrator?",
                   ["Scout Finch", "Atticus Finch", "Tom Robinson", "Boo Radley"], "Scout Finch",
                   "Scout (Jean Louise) Finch narrates the story as an adult looking back on her childhood in Alabama.", "📚", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("What is the main theme of George Orwell's '1984'?",
                   ["Totalitarianism and loss of freedom", "The beauty of nature", "A love story", "Space exploration"], "Totalitarianism and loss of freedom",
                   "1984 explores a dystopian society under surveillance and thought control — Big Brother is watching.", "👁️", 3),
                ex("Explain the difference between active and passive voice.", [],
                   "Active: 'The cat ate the fish.' Passive: 'The fish was eaten by the cat.'",
                   "In active voice, the subject performs the action. In passive, the subject receives it.", "📝", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇪🇸 Lengua Española
    private static func spanish(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("¿Cuál es el sujeto en: 'El perro corre por el parque'?",
               ["El perro", "corre", "el parque", "por"], "El perro",
               "El sujeto realiza la acción del verbo. 'El perro' es quien corre.", "🐕", 1),
            ex("¿Cuántas vocales tiene el español?",
               ["5", "6", "4", "7"], "5",
               "El español tiene 5 vocales: a, e, i, o, u.", "🔤", 1),
            ex("¿Qué es un adjetivo?",
               ["Una palabra que acompaña al nombre para calificarlo", "Una acción", "Una persona", "Un lugar"], "Una palabra que acompaña al nombre para calificarlo",
               "El adjetivo califica al nombre. Ej: 'casa grande' — 'grande' es el adjetivo.", "📝", 1),
            ex("¿Cuándo se usa el subjuntivo?",
               ["Para expresar duda, deseo o posibilidad", "Para afirmar hechos ciertos", "Para el pasado", "Para preguntar"], "Para expresar duda, deseo o posibilidad",
               "Ej: 'Espero que vengas' — 'vengas' está en subjuntivo porque expresa deseo.", "❓", 2),
            ex("¿Cuál es la diferencia entre 'ser' y 'estar'?",
               ["'Ser' para características permanentes; 'estar' para estados temporales", "Son sinónimos", "'Ser' es solo para personas", "'Estar' es solo para lugares"], "'Ser' para características permanentes; 'estar' para estados temporales",
               "'Soy alto' (permanente) vs 'Estoy cansado' (temporal). Es una distinción única del español.", "⚖️", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("¿Qué es una metáfora?",
                   ["Una comparación sin 'como'", "Una comparación con 'como'", "Una exageración", "Una repetición"], "Una comparación sin 'como'",
                   "Ej: 'Tus ojos son estrellas' — no usa 'como', es una metáfora.", "🌟", 2),
                ex("¿Quién escribió 'Don Quijote de la Mancha'?",
                   ["Miguel de Cervantes", "Lope de Vega", "Francisco de Quevedo", "Calderón de la Barca"], "Miguel de Cervantes",
                   "El Quijote (1605/1615) de Cervantes es considerado la primera novela moderna.", "📚", 3),
                ex("¿Cuándo se pone tilde en los monosílabos?",
                   ["Solo en los que tienen acento diacrítico (tú/tu, él/el...)", "Nunca", "Siempre", "Solo en verbos"], "Solo en los que tienen acento diacrítico (tú/tu, él/el...)",
                   "Los monosílabos llevan tilde solo para distinguir palabras: tú (pronombre) / tu (posesivo).", "✍️", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇵🇹 Língua Portuguesa
    private static func portuguese(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Qual é o sujeito em: 'O gato bebe o leite'?",
               ["O gato", "bebe", "o leite", "bebe o leite"], "O gato",
               "O sujeito é quem pratica a ação. 'O gato' é quem bebe.", "🐱", 1),
            ex("Qual é o plural de 'cidadão'?",
               ["cidadãos", "cidadões", "cidadãs", "cidadãoes"], "cidadãos",
               "Palavras terminadas em -ão podem ter plural em -ãos, -ões ou -ães. 'Cidadão' → 'cidadãos'.", "📝", 2),
            ex("O que é uma metáfora?",
               ["Uma comparação sem 'como'", "Uma comparação com 'como'", "Uma repetição", "Uma exageração"], "Uma comparação sem 'como'",
               "Metáfora: 'A vida é uma viagem'. Não usa 'como' (isso seria uma comparação/símile).", "🌊", 2),
            ex("Luis de Camões escreveu:",
               ["Os Lusíadas", "Dom Quixote", "A Mensagem", "Os Maias"], "Os Lusíadas",
               "'Os Lusíadas' (1572) de Luís de Camões é o grande épico da língua portuguesa.", "📚", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("O que é o pretérito imperfeito?",
                   ["Um tempo passado que indica ação habitual ou contínua", "O passado simples", "O futuro", "O presente"], "Um tempo passado que indica ação habitual ou contínua",
                   "Ex: 'Quando era criança, brincava todos os dias.' — ação passada repetida.", "⏰", 3),
                ex("Fernando Pessoa tem heterónimos. Qual destes é um deles?",
                   ["Alberto Caeiro", "Eça de Queirós", "Almeida Garrett", "Camilo Castelo Branco"], "Alberto Caeiro",
                   "Fernando Pessoa criou heterónimos com personalidades distintas: Alberto Caeiro, Ricardo Reis, Álvaro de Campos.", "🎭", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇮🇹 Italiano
    private static func italian(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Qual è il soggetto in: 'Il gatto beve il latte'?",
               ["Il gatto", "beve", "il latte", "beve il latte"], "Il gatto",
               "Il soggetto compie l'azione. 'Il gatto' è chi beve.", "🐱", 1),
            ex("Vero o Falso: In italiano, il congiuntivo si usa per esprimere dubbi o desideri.",
               ["Vero", "Falso"], "Vero",
               "Es: 'Spero che tu venga' — 'venga' è congiuntivo perché esprime speranza/desiderio.", "❓", 2),
            ex("Chi scrisse la Divina Commedia?",
               ["Dante Alighieri", "Francesco Petrarca", "Giovanni Boccaccio", "Ludovico Ariosto"], "Dante Alighieri",
               "La Divina Commedia (1304-1321) di Dante è il capolavoro della letteratura italiana medievale.", "📚", 2),
            ex("Cosa studia la morfologia?",
               ["La struttura delle parole", "La sintassi delle frasi", "La fonetica", "La storia della lingua"], "La struttura delle parole",
               "La morfologia studia la forma e la struttura delle parole: radice, prefissi, suffissi.", "🔤", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Qual è la differenza tra passato prossimo e passato remoto?",
                   ["Passato prossimo: azioni recenti; passato remoto: azioni lontane nel tempo", "Sono sinonimi", "Passato remoto è più formale", "Dipende dal verbo"], "Passato prossimo: azioni recenti; passato remoto: azioni lontane nel tempo",
                   "Nel parlato: 'Ho mangiato' (recente) vs 'Mangiai' (remoto, usato al Sud o nel passato storico).", "⏰", 3),
                ex("Chi è il protagonista dei 'Promessi Sposi' di Manzoni?",
                   ["Renzo e Lucia", "Don Abbondio", "Don Rodrigo", "Fra Cristoforo"], "Renzo e Lucia",
                   "'I Promessi Sposi' (1827/1842) di Alessandro Manzoni racconta la storia d'amore di Renzo e Lucia nell'Italia secentesca.", "💏", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇩🇪 Deutsch
    private static func german(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Was ist das Subjekt in: 'Der Hund frisst den Knochen'?",
               ["Der Hund", "frisst", "den Knochen", "Hund"], "Der Hund",
               "Das Subjekt führt die Handlung aus. 'Der Hund' (Nominativ) ist das Subjekt.", "🐕", 1),
            ex("Welcher Artikel gehört zu 'Hund'?",
               ["der", "die", "das", "ein"], "der",
               "'Der Hund' — maskulin. Artikel zeigen Genus: der (m), die (f/pl), das (n).", "📝", 1),
            ex("Was ist der Akkusativ?",
               ["Der Fall des direkten Objekts", "Der Fall des Subjekts", "Der Fall des indirekten Objekts", "Der Genitiv"], "Der Fall des direkten Objekts",
               "Akkusativ = das direkte Objekt. 'Ich sehe den Hund.' — 'den Hund' ist Akkusativ.", "📐", 2),
            ex("Wer schrieb 'Die Leiden des jungen Werthers'?",
               ["Johann Wolfgang von Goethe", "Friedrich Schiller", "Thomas Mann", "Bertolt Brecht"], "Johann Wolfgang von Goethe",
               "'Die Leiden des jungen Werthers' (1774) von Goethe ist ein Briefroman der Sturm-und-Drang-Epoche.", "📚", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Was unterscheidet den Konjunktiv II vom Indikativ?",
                   ["Er drückt Möglichkeit, Wunsch oder Irrealität aus", "Er ist eine Vergangenheitsform", "Er ist formeller", "Er wird nur in Bayern benutzt"], "Er drückt Möglichkeit, Wunsch oder Irrealität aus",
                   "'Ich würde gerne kommen' — Konjunktiv II drückt einen Wunsch aus.", "❓", 3),
                ex("Was ist eine Metapher?",
                   ["Ein Vergleich ohne 'wie'", "Ein Vergleich mit 'wie'", "Eine Übertreibung", "Eine Wiederholung"], "Ein Vergleich ohne 'wie'",
                   "Metapher: 'Das Leben ist eine Reise'. Vergleich: 'Das Leben ist wie eine Reise'.", "🌟", 2),
                ex("Nenne zwei Werke von Friedrich Schiller.", [], "Die Räuber / Wilhelm Tell / Don Carlos / Maria Stuart",
                   "Schiller ist einer der bedeutendsten deutschen Dichter. Seine Dramen sind Teil des Schulkanons.", "🎭", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇸🇦 اللغة العربية
    private static func arabic(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("ما هو المبتدأ في جملة: 'الطالبُ يقرأُ الكتابَ' ؟",
               ["الطالبُ", "يقرأُ", "الكتابَ", "يقرأُ الكتابَ"], "الطالبُ",
               "المبتدأ هو الاسم المرفوع في أول الجملة الاسمية. 'الطالبُ' مرفوع لأنه مبتدأ.", "📖", 1),
            ex("ما هو جمع كلمة 'كتاب'؟",
               ["كُتُب", "كتابات", "كتابون", "كتابين"], "كُتُب",
               "جمع التكسير: كتاب → كُتُب. جموع التكسير تتغير بنية الكلمة.", "📚", 1),
            ex("صح أم خطأ: الفعل المضارع يدل على الحاضر أو المستقبل.",
               ["صح", "خطأ"], "صح",
               "الفعل المضارع يصف حدثاً في الحاضر أو المستقبل. مثال: 'يكتبُ الطالبُ الآن / غداً'.", "⏰", 1),
            ex("ما هو الفاعل في: 'فتحَ الطالبُ الكتابَ'؟",
               ["الطالبُ", "فتحَ", "الكتابَ", "فتحَ الطالبُ"], "الطالبُ",
               "الفاعل هو من قام بالفعل. 'الطالبُ' هو من فتح الكتاب، وهو مرفوع.", "✍️", 2),
            ex("ما هو علم البلاغة؟",
               ["دراسة أساليب التعبير المؤثرة في اللغة", "دراسة قواعد النحو", "دراسة الأصوات", "دراسة المعجم"], "دراسة أساليب التعبير المؤثرة في اللغة",
               "البلاغة تشمل علم البيان (الاستعارة، التشبيه) وعلم البديع وعلم المعاني.", "🌟", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("ما الفرق بين الاستعارة والتشبيه؟",
                   ["التشبيه يستخدم 'كأن/مثل'؛ الاستعارة بدون أداة تشبيه", "هما نفس الشيء", "الاستعارة أقل تأثيراً", "التشبيه أكثر شيوعاً في الشعر"], "التشبيه يستخدم 'كأن/مثل'؛ الاستعارة بدون أداة تشبيه",
                   "تشبيه: 'الولدُ كالأسد شجاعةً'. استعارة: 'الأسدُ يتقدم نحو العدو' (يقصد الولد الشجاع).", "🦁", 3),
                ex("اذكر ديوان شاعر عربي كلاسيكي.", [], "المتنبي: ديوان المتنبي / المعري: سقط الزند / امرؤ القيس: المعلقة",
                   "المتنبي وأبو العلاء المعري وامرؤ القيس من أعظم شعراء العرب عبر التاريخ.", "📜", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇳🇱 Nederlands
    private static func dutch(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Wat is het onderwerp in: 'De hond eet het bot'?",
               ["De hond", "eet", "het bot", "eet het bot"], "De hond",
               "Het onderwerp voert de handeling uit. 'De hond' is wie eet.", "🐕", 1),
            ex("Wat is het meervoud van 'kind'?",
               ["kinderen", "kinds", "kinders", "kindes"], "kinderen",
               "'Kind' heeft een onregelmatig meervoud: kinderen. Net als 'ei → eieren'.", "📝", 1),
            ex("Wat is een metafoor?",
               ["Een vergelijking zonder 'als'", "Een vergelijking met 'als'", "Een overdrijving", "Een herhaling"], "Een vergelijking zonder 'als'",
               "Metafoor: 'Het leven is een reis.' Vergelijking: 'Het leven is als een reis.'", "🌟", 2),
            ex("Wie schreef 'De Aanslag'?",
               ["Harry Mulisch", "Gerard Reve", "Willem Frederik Hermans", "Cees Nooteboom"], "Harry Mulisch",
               "'De Aanslag' (1982) van Harry Mulisch is een van de bekendste Nederlandse naoorlogse romans.", "📚", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Wat is het verschil tussen 'de' en 'het'?",
                   ["'De' voor mannelijke/vrouwelijke woorden; 'het' voor onzijdige woorden", "Ze zijn uitwisselbaar", "'Het' is formeler", "'De' is ouder"], "'De' voor mannelijke/vrouwelijke woorden; 'het' voor onzijdige woorden",
                   "In het Nederlands zijn er twee soorten lidwoorden: 'de' (de-woorden) en 'het' (het-woorden).", "📐", 3),
                ex("Wat is een bijvoeglijk naamwoord?",
                   ["Een woord dat een zelfstandig naamwoord beschrijft", "Een werkwoord", "Een bijwoord", "Een voornaamwoord"], "Een woord dat een zelfstandig naamwoord beschrijft",
                   "Bijvoeglijk naamwoord = adjectief. Bijv: 'de grote hond' — 'grote' beschrijft 'hond'.", "📝", 2),
                ex("Noem twee werken uit de Nederlandse literatuur.", [], "De Aanslag (Mulisch) / Het Achterhuis (Anne Frank) / Max Havelaar (Multatuli)",
                   "Anne Franks 'Het Achterhuis', Multatulis 'Max Havelaar' en Mulisch' 'De Aanslag' zijn klassiekers.", "📚", 3),
            ]
        }
        return pool
    }
}
