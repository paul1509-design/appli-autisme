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
                ex("Qu'est-ce que le théâtre de l'absurde ?",
                   ["Un courant qui montre l'absurdité de la condition humaine (Beckett, Ionesco)", "Une pièce comique", "Un genre médiéval", "Le théâtre de Molière"], "Un courant qui montre l'absurdité de la condition humaine (Beckett, Ionesco)",
                   "Beckett ('En attendant Godot') et Ionesco ('La Cantatrice chauve') ont fondé ce courant au XXe siècle.", "🎭", 3),
                ex("Qu'est-ce qu'une anaphore ?",
                   ["La répétition d'un mot ou groupe de mots en début de phrase", "Une figure de contraste", "Une question rhétorique", "Un mot rare"], "La répétition d'un mot ou groupe de mots en début de phrase",
                   "Ex : 'Il faut travailler, il faut persévérer, il faut réussir.' L'anaphore crée un rythme et insiste.", "🔁", 3),
                ex("Gustave Flaubert a écrit :",
                   ["Madame Bovary", "Les Misérables", "Germinal", "Le Père Goriot"], "Madame Bovary",
                   "'Madame Bovary' (1857) de Flaubert est un chef-d'œuvre du réalisme littéraire français.", "📖", 2),
            ]
        }
        // Exercices variés : QCM, shortAnswer, oral
        pool += [
            ex("Qu'est-ce qu'un complément d'objet direct (COD) ?",
               ["Le mot qui reçoit l'action du verbe, sans préposition", "Le sujet de la phrase", "Un adverbe", "Un mot entre virgules"], "Le mot qui reçoit l'action du verbe, sans préposition",
               "Ex : 'Je mange une pomme.' — 'une pomme' est COD (on peut demander 'je mange quoi ?').", "🍎", 2),
            ex("Le passé composé se forme avec :",
               ["Auxiliaire avoir ou être + participe passé", "Radical + terminaison", "Imparfait + participe", "Futur + infinitif"], "Auxiliaire avoir ou être + participe passé",
               "Ex : 'j'ai mangé' (avoir) ou 'je suis allé(e)' (être). Certains verbes utilisent être : aller, venir, partir...", "⏰", 2),
            ex("Dans la phrase 'Le chien aboie fort', 'fort' est :",
               ["Un adverbe", "Un adjectif", "Un nom", "Un verbe"], "Un adverbe",
               "L'adverbe modifie le verbe. 'Fort' indique comment le chien aboie. Il est invariable.", "📝", 1),
            ex("Comment conjugue-t-on 'venir' au présent pour 'nous' ?",
               ["nous venons", "nous venez", "nous venions", "nous viens"], "nous venons",
               "Venir : je viens, tu viens, il vient, nous venons, vous venez, ils viennent.", "📝", 2),
            // Exercices shortAnswer (réponse courte)
            ex("Quel est le participe passé du verbe 'écrire' ?",
               [], "écrit",
               "Écrire → écrit. Ex : 'J'ai écrit une lettre.' Les participes passés irréguliers s'apprennent par cœur.", "✍️", 2),
            ex("Donne le féminin du mot 'boulanger'.",
               [], "boulangère",
               "Boulanger → boulangère. On ajoute -ère pour former le féminin de nombreux métiers en -er.", "🥖", 1),
            ex("Quelle est la nature du mot 'rapidement' ?",
               [], "adverbe",
               "'Rapidement' est un adverbe de manière, formé de l'adjectif féminin 'rapide' + le suffixe -ment.", "🏃", 1),
            ex("Écris le pluriel de 'œil'.",
               [], "yeux",
               "'Œil' a un pluriel irrégulier : yeux. C'est l'un des pluriels irréguliers les plus courants en français.", "👁️", 2),
            ex("Conjugue 'finir' à la 3e personne du pluriel, présent.",
               [], "ils finissent",
               "Les verbes en -ir du 2e groupe prennent -issent au pluriel : nous finissons, vous finissez, ils finissent.", "📝", 2),
            ex("Quelle est la différence entre 'a' et 'à' ?",
               [], "a = verbe avoir (il a) / à = préposition (il va à Paris)",
               "'A' est le verbe avoir conjugué (il a mangé). 'À' est une préposition (il va à Paris). Astuce : remplace par 'avait' — si ça marche, c'est 'a'.", "✍️", 2),
            // Exercices oral
            ex("Donne un exemple de phrase avec un adjectif qualificatif.",
               [], "Ex : 'Le grand chien noir court vite.'",
               "L'adjectif qualificatif décrit le nom. Il s'accorde en genre et en nombre : grand/grande, noir/noire.", "🗣️", 1),
            ex("Explique à voix haute ce qu'est un verbe.",
               [], "Un verbe exprime une action (manger, courir) ou un état (être, sembler). Il se conjugue selon le sujet et le temps.",
               "Le verbe est le cœur de la phrase. Sans verbe, pas de phrase ! Il indique ce que fait ou ce qu'est le sujet.", "🎤", 1),
        ]
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
                ex("Who wrote 'Pride and Prejudice'?",
                   ["Jane Austen", "Charlotte Brontë", "Mary Shelley", "George Eliot"], "Jane Austen",
                   "'Pride and Prejudice' (1813) by Jane Austen follows Elizabeth Bennet and Mr Darcy in Regency England.", "📚", 2),
                ex("What is an extended metaphor?",
                   ["A metaphor developed over several lines or throughout a whole text", "A very long simile", "Comparing two very different things", "A metaphor with a 'like' or 'as'"], "A metaphor developed over several lines or throughout a whole text",
                   "Extended metaphors are sustained across a poem or passage and deepen the comparison.", "🌿", 3),
                ex("What narrative perspective uses 'I' (first person)?",
                   ["First-person narration", "Third-person omniscient", "Second person", "Free indirect discourse"], "First-person narration",
                   "First-person narrators ('I') give an intimate, limited viewpoint. They may be unreliable narrators.", "📝", 2),
            ]
        }
        pool += [
            ex("What is an antonym?",
               ["A word with the opposite meaning", "A word with the same meaning", "A word from another language", "A word that sounds similar"], "A word with the opposite meaning",
               "Antonyms are opposites: hot/cold, fast/slow, happy/sad. A synonym has the same meaning.", "🔤", 1),
            ex("What is alliteration?",
               ["Repetition of the same consonant sound at the start of nearby words", "Rhyming words at line ends", "Exaggeration for effect", "A comparison using 'like'"], "Repetition of the same consonant sound at the start of nearby words",
               "Example: 'Peter Piper picked a peck of pickled peppers.' Alliteration creates rhythm and emphasis.", "🔤", 1),
            ex("The simple past tense of 'to write' is:",
               ["wrote", "writed", "written", "writ"], "wrote",
               "'Write' is an irregular verb: write → wrote → written. The past simple is 'wrote'.", "✍️", 1),
            ex("What is an apostrophe used for in English?",
               ["Possession ('the dog's bone') and contractions ('don't')", "Plurals", "Questions", "Exclamations"], "Possession ('the dog's bone') and contractions ('don't')",
               "Apostrophes mark possession: 'the girl's bag'. They also show missing letters in contractions.", "📝", 2),
            ex("What is hyperbole?",
               ["Extreme exaggeration for effect", "Saying the opposite of what you mean", "Giving human qualities to objects", "A comparison using 'like' or 'as'"], "Extreme exaggeration for effect",
               "Hyperbole: 'I've told you a million times!' The speaker hasn't literally said it a million times.", "💥", 2),
            ex("In poetry, what is a stanza?",
               ["A group of lines forming a unit (like a paragraph in prose)", "A single line", "A rhyming couplet only", "The title of a poem"], "A group of lines forming a unit (like a paragraph in prose)",
               "Stanzas structure poems: a couplet (2 lines), tercet (3), quatrain (4), sestet (6), octave (8).", "📜", 2),
        ]
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
                ex("¿Qué es un hipérbaton?",
                   ["Una alteración del orden normal de las palabras", "Una exageración", "Una repetición", "Un tipo de rima"], "Una alteración del orden normal de las palabras",
                   "El hipérbaton altera el orden lógico. Ej: 'Del salón en el ángulo oscuro' (en el ángulo oscuro del salón).", "📜", 3),
                ex("¿Qué es la hipérbole?",
                   ["Una exageración para dar énfasis", "Una comparación con 'como'", "Una repetición de sonidos", "Un contraste de ideas"], "Una exageración para dar énfasis",
                   "Ej: 'Te lo he dicho mil veces'. La hipérbole exagera para intensificar el mensaje.", "💥", 3),
            ]
        }
        pool += [
            ex("¿Qué es un verbo transitivo?",
               ["Un verbo que necesita un complemento directo", "Un verbo que no lleva complementos", "Un verbo reflexivo", "Un verbo auxiliar"], "Un verbo que necesita un complemento directo",
               "Ej: 'Comí (qué) una manzana.' — 'manzana' es el CD del verbo 'comer', que es transitivo.", "🍎", 2),
            ex("¿Cuáles son las tres conjugaciones del español?",
               ["-AR, -ER, -IR", "-AR, -OR, -UR", "-ER, -IR, -OR", "-AR, -ER, -OR"], "-AR, -ER, -IR",
               "Los verbos en español se agrupan según su infinitivo: cantar (-AR), comer (-ER), vivir (-IR).", "📝", 1),
            ex("¿Qué es una oración subordinada?",
               ["Una oración que depende de otra (principal)", "Una oración sin verbo", "La frase más importante", "Una oración con dos sujetos"], "Una oración que depende de otra (principal)",
               "Ej: 'Sé que vendrás.' — 'que vendrás' es la oración subordinada sustantiva (CD).", "📐", 2),
            ex("¿Cuál es el antónimo de 'valiente'?",
               ["cobarde", "lento", "triste", "amable"], "cobarde",
               "Los antónimos son palabras de significado opuesto. Valiente ↔ cobarde.", "🔤", 1),
            ex("¿Qué función tiene el adverbio 'muy' en 'Es muy inteligente'?",
               ["Intensificar el adjetivo 'inteligente'", "Sustituir al sujeto", "Indicar tiempo", "Indicar lugar"], "Intensificar el adjetivo 'inteligente'",
               "Los adverbios de cantidad como 'muy', 'bastante', 'poco' intensifican adjetivos o adverbios.", "📝", 2),
            ex("¿Qué es la rima consonante?",
               ["Igualdad de sonidos (vocales y consonantes) desde la última vocal acentuada", "Solo igualdad de vocales", "Sin rima", "Rima en el interior del verso"], "Igualdad de sonidos (vocales y consonantes) desde la última vocal acentuada",
               "Ej: can-ción / pa-sión — desde la 'ó' todo coincide. La rima asonante solo iguala vocales.", "🎵", 3),
        ]
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
                ex("O que é um complemento direto?",
                   ["O constituinte que responde a 'o quê?' do verbo", "O sujeito da frase", "Um adjetivo", "Um advérbio"], "O constituinte que responde a 'o quê?' do verbo",
                   "Ex: 'Ela leu (o quê?) o livro.' — 'o livro' é o complemento direto do verbo 'ler'.", "📝", 2),
                ex("Qual figura de estilo está em: 'A vida é um sonho'?",
                   ["Metáfora", "Comparação", "Hipérbole", "Anáfora"], "Metáfora",
                   "A metáfora identifica dois elementos sem usar 'como'. 'A vida é um sonho' (e não 'como um sonho').", "🌙", 2),
            ]
        }
        pool += [
            ex("Qual é o plural de 'mão'?",
               ["mãos", "mães", "mões", "mãoes"], "mãos",
               "Palavras terminadas em '-ão' variam: mão→mãos, pão→pães, avião→aviões. Cada caso deve ser aprendido.", "✋", 1),
            ex("O que é um adjetivo?",
               ["Uma palavra que qualifica ou caracteriza o substantivo", "Uma ação", "Uma ligação entre palavras", "Um pronome"], "Uma palavra que qualifica ou caracteriza o substantivo",
               "Ex: 'O carro vermelho' — 'vermelho' é o adjetivo que qualifica 'carro'.", "🎨", 1),
            ex("Em que tempo verbal está 'Eles cantavam'?",
               ["Pretérito imperfeito do indicativo", "Presente do indicativo", "Pretérito perfeito", "Futuro"], "Pretérito imperfeito do indicativo",
               "O imperfeito indica ação passada habitual ou contínua. Ex: 'Quando criança, cantavam todas as noites.'", "⏰", 2),
            ex("Eça de Queirós pertence ao movimento literário do:",
               ["Realismo", "Romantismo", "Modernismo", "Classicismo"], "Realismo",
               "Eça de Queirós (1845-1900) foi o principal escritor do Realismo português. Escreveu 'O Crime do Padre Amaro'.", "📚", 2),
            ex("O que é a conjunção coordenativa 'mas'?",
               ["Adversativa — liga ideias opostas", "Aditiva — acrescenta", "Conclusiva — conclui", "Explicativa — explica"], "Adversativa — liga ideias opostas",
               "Ex: 'Ela estuda, mas não aprende.' 'Mas' opõe as duas ideias. 'E' é aditiva, 'logo' é conclusiva.", "🔗", 2),
            ex("Qual é o sujeito de 'Neste livro, aprende-se muito'?",
               ["Sujeito indeterminado", "O livro", "Aprende", "Não tem sujeito"], "Sujeito indeterminado",
               "O pronome 'se' com verbo na 3.ª pessoa indica sujeito indeterminado — não se sabe quem é o sujeito.", "❓", 3),
        ]
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
                ex("Cosa studia la sintassi?",
                   ["La struttura delle frasi e i rapporti tra le parole", "La pronuncia delle parole", "Il significato dei vocaboli", "L'origine storica delle parole"], "La struttura delle frasi e i rapporti tra le parole",
                   "La sintassi analizza come le parole si combinano per formare frasi: soggetto, predicato, complementi.", "📐", 3),
                ex("Qual è la differenza tra similitudine e metafora?",
                   ["La similitudine usa 'come' o 'simile a'; la metafora no", "Sono la stessa cosa", "La metafora usa 'come'", "La similitudine è più letteraria"], "La similitudine usa 'come' o 'simile a'; la metafora no",
                   "Similitudine: 'È forte come un leone.' Metafora: 'È un leone.' La metafora è più diretta.", "🦁", 3),
            ]
        }
        pool += [
            ex("Che cos'è un nome comune?",
               ["Un nome che indica una categoria generale", "Un nome proprio di persona", "Un nome di città", "Un nome straniero"], "Un nome che indica una categoria generale",
               "Nomi comuni: cane, città, libro. Nomi propri: Roma, Marco, Italia. I nomi propri si scrivono con la maiuscola.", "📝", 1),
            ex("Qual è il plurale di 'uomo'?",
               ["uomini", "uomi", "uomoni", "uomines"], "uomini",
               "'Uomo' ha un plurale irregolare: uomo → uomini. Come 'bue → buoi'.", "📝", 1),
            ex("Come si forma il futuro semplice di 'parlare'?",
               ["parlerò, parlerai, parlerà...", "parlo, parli, parla...", "parlavo, parlavi...", "parlerei, parleresti..."], "parlerò, parlerai, parlerà...",
               "Il futuro semplice si forma con il tema dell'infinitivo (senza la -e) + desinenze: -ò, -ai, -à, -emo, -ete, -anno.", "⏰", 2),
            ex("Qual è l'antonimo di 'veloce'?",
               ["lento", "forte", "pesante", "alto"], "lento",
               "Gli antonimi sono parole di significato opposto. Veloce ↔ lento.", "🐢", 1),
            ex("Cosa indica l'avverbio 'molto' in 'È molto bello'?",
               ["Grado di intensità dell'aggettivo", "Il soggetto", "Il complemento oggetto", "Il tempo"], "Grado di intensità dell'aggettivo",
               "'Molto' è un avverbio di quantità che intensifica l'aggettivo 'bello'. Equivale a 'assai' o 'tanto'.", "📝", 1),
            ex("Chi scrisse 'Il Principe'?",
               ["Niccolò Machiavelli", "Dante Alighieri", "Francesco Petrarca", "Ludovico Ariosto"], "Niccolò Machiavelli",
               "'Il Principe' (1513) di Machiavelli è un trattato politico che analizza come conquistare e mantenere il potere.", "👑", 2),
        ]
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
                ex("Was ist ein Relativsatz?",
                   ["Ein Nebensatz, der ein Nomen näher bestimmt", "Ein selbstständiger Hauptsatz", "Ein Fragesatz", "Ein Befehlssatz"], "Ein Nebensatz, der ein Nomen näher bestimmt",
                   "Bsp: 'Der Hund, der bellt, beißt nicht.' Der Relativsatz 'der bellt' bestimmt 'der Hund' näher.", "📐", 3),
                ex("Was ist Epik?",
                   ["Eine Gattung der Literatur: Prosa-Erzählungen (Roman, Novelle, Kurzgeschichte...)", "Lyrik in Versform", "Dramatische Werke", "Reden und Aufsätze"], "Eine Gattung der Literatur: Prosa-Erzählungen (Roman, Novelle, Kurzgeschichte...)",
                   "Die drei Gattungen: Epik (erzählen), Lyrik (lyrisches Ich), Dramatik (Dialog/Bühne).", "📚", 2),
            ]
        }
        pool += [
            ex("Was ist der Unterschied zwischen 'du' und 'Sie'?",
               ["'Du' ist informell (Freunde/Familie); 'Sie' ist formell (Unbekannte/Respektpersonen)", "Sie sind gleich", "'Sie' ist veraltet", "'Du' ist formeller"], "'Du' ist informell (Freunde/Familie); 'Sie' ist formell (Unbekannte/Respektpersonen)",
               "Im Deutschen wird 'Sie' (Großschreibung) zur höflichen Anrede verwendet. 'Du' beim Duzen.", "🤝", 1),
            ex("Was ist der Unterschied zwischen 'das' und 'dass'?",
               ["'das' ist Artikel/Pronomen; 'dass' ist eine Konjunktion", "Sie sind Synonyme", "'dass' ist ein Artikel", "'das' leitet Nebensätze ein"], "'das' ist Artikel/Pronomen; 'dass' ist eine Konjunktion",
               "Bsp: 'Das Buch liegt hier.' (Artikel) vs. 'Ich weiß, dass du kommst.' (Konjunktion).", "📝", 2),
            ex("Was ist das Präteritum?",
               ["Eine Vergangenheitsform der Erzählsprache", "Die Zukunftsform", "Eine Frageform", "Ein Modus"], "Eine Vergangenheitsform der Erzählsprache",
               "Das Präteritum ('er sagte', 'sie ging') wird vor allem in Büchern und Berichten verwendet.", "⏰", 2),
            ex("Was ist eine Alliteration?",
               ["Wiederholung des gleichen Anfangslautes in aufeinanderfolgenden Wörtern", "Reimende Wörter am Versende", "Übertreibung zum Nachdruck", "Ein Vergleich mit 'wie'"], "Wiederholung des gleichen Anfangslautes in aufeinanderfolgenden Wörtern",
               "Bsp: 'Milch macht müde Männer munter.' Alliterationen erzeugen Klang und Rhythmus.", "🔤", 1),
            ex("Welcher Kasus folgt auf die Präposition 'mit'?",
               ["Dativ", "Akkusativ", "Nominativ", "Genitiv"], "Dativ",
               "'Mit' regiert immer den Dativ. Bsp: 'Ich fahre mit dem Auto.' ('dem' = Dativ).", "📐", 2),
            ex("Was ist eine Novelle?",
               ["Eine kürzere Prosaerzählung mit einer unerhörten Begebenheit", "Ein langer Roman", "Ein Theaterstück", "Ein Gedicht"], "Eine kürzere Prosaerzählung mit einer unerhörten Begebenheit",
               "Berühmte Novellen: 'Der Schimmelreiter' (Storm), 'Die Judenbuche' (Droste-Hülshoff). Kürzer als ein Roman.", "📖", 2),
        ]
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
                ex("ما هو التشبيه البليغ؟",
                   ["تشبيه حذفت منه أداة التشبيه ووجه الشبه معاً", "تشبيه كامل الأركان", "استعارة تصريحية", "كناية"], "تشبيه حذفت منه أداة التشبيه ووجه الشبه معاً",
                   "مثال: 'محمدٌ أسدٌ' — حُذفت 'كأن/مثل' ووجه الشبه (الشجاعة). يبقى المشبه والمشبه به فقط.", "🦁", 3),
                ex("ما الفرق بين المعرفة والنكرة في العربية؟",
                   ["المعرفة تدل على شيء محدد (مع 'ال')؛ النكرة غير محددة", "هما متماثلان", "النكرة تُعرَّف بالضمة", "المعرفة دائماً منونة"], "المعرفة تدل على شيء محدد (مع 'ال')؛ النكرة غير محددة",
                   "مثال: 'طالبٌ' (نكرة) → 'الطالبُ' (معرفة). المعرفة تشمل أيضاً الأسماء والضمائر وأسماء الإشارة.", "📝", 2),
            ]
        }
        pool += [
            ex("ما هو المفعول به؟",
               ["الاسم الذي وقع عليه الفعل ويكون منصوباً", "الاسم الذي يقوم بالفعل", "الاسم المجرور", "الاسم المرفوع"], "الاسم الذي وقع عليه الفعل ويكون منصوباً",
               "مثال: 'أكلَ الولدُ التفاحةَ' — 'التفاحةَ' مفعول به منصوب، وعلامة نصبه الفتحة.", "🍎", 1),
            ex("ما الفرق بين الجملة الاسمية والجملة الفعلية؟",
               ["الاسمية تبدأ باسم؛ الفعلية تبدأ بفعل", "الاسمية تحتوي أفعالاً فقط", "لا فرق بينهما", "الفعلية أطول دائماً"], "الاسمية تبدأ باسم؛ الفعلية تبدأ بفعل",
               "'الطالبُ مجتهدٌ' (اسمية: مبتدأ + خبر). 'كتبَ الطالبُ الدرسَ' (فعلية: فعل + فاعل + مفعول).", "📝", 1),
            ex("ما هو الحال في النحو العربي؟",
               ["وصف لهيئة الفاعل أو المفعول وقت حدوث الفعل، منصوب", "خبر المبتدأ", "الفاعل", "المفعول المطلق"], "وصف لهيئة الفاعل أو المفعول وقت حدوث الفعل، منصوب",
               "مثال: 'جاء الطالبُ مسرعاً.' — 'مسرعاً' حال منصوبة تصف هيئة الطالب لحظة المجيء.", "🏃", 2),
            ex("ما هو الكناية في البلاغة؟",
               ["لفظ يُراد به لازم معناه مع جواز إرادة المعنى الأصلي", "مجاز لغوي", "تشبيه بليغ", "استعارة مكنية"], "لفظ يُراد به لازم معناه مع جواز إرادة المعنى الأصلي",
               "مثال: 'فلانٌ كثير الرماد' — تعني كريماً (لأن الرماد يدل على كثرة الطبخ للضيوف).", "🔥", 3),
            ex("صح أم خطأ: المثنى يُرفع بالألف وينصب ويُجر بالياء.",
               ["صح", "خطأ"], "صح",
               "المثنى: 'طالبان' (مرفوع بالألف) — 'طالبين' (منصوب أو مجرور بالياء).", "✅", 2),
            ex("ما هو أسلوب الاستفهام؟",
               ["أسلوب يُستخدم لطلب العلم بشيء مجهول باستخدام أدوات الاستفهام", "أسلوب النداء", "أسلوب الشرط", "أسلوب التعجب"], "أسلوب يُستخدم لطلب العلم بشيء مجهول باستخدام أدوات الاستفهام",
               "أدوات الاستفهام: من؟ ما؟ متى؟ أين؟ كيف؟ هل؟ أَ. مثال: 'من كتب هذا؟'", "❓", 1),
        ]
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
                ex("Wat is een bijzin?",
                   ["Een zin die afhankelijk is van een hoofdzin", "Een zin met een werkwoord vooraan", "Een zin zonder onderwerp", "Een zin met twee werkwoorden"], "Een zin die afhankelijk is van een hoofdzin",
                   "Bijzin: 'Ik weet dat hij komt.' — 'dat hij komt' is de bijzin. Het werkwoord staat achteraan.", "📐", 3),
                ex("Wat is een persoonsvorm?",
                   ["Het werkwoord dat vervoegd is naar persoon en tijd", "Het zelfstandig naamwoord", "Het bijvoeglijk naamwoord", "Het hulpwerkwoord altijd"], "Het werkwoord dat vervoegd is naar persoon en tijd",
                   "De persoonsvorm verandert mee met het onderwerp: ik loop, jij loopt, hij loopt, wij lopen.", "📝", 2),
            ]
        }
        pool += [
            ex("Wat is het verschil tussen een werkwoord en een zelfstandig naamwoord?",
               ["Een werkwoord drukt een handeling uit; een zelfstandig naamwoord benoemt een persoon, ding of begrip", "Ze zijn hetzelfde", "Een zelfstandig naamwoord heeft altijd een lidwoord", "Een werkwoord is altijd kort"], "Een werkwoord drukt een handeling uit; een zelfstandig naamwoord benoemt een persoon, ding of begrip",
               "Werkwoord: lopen, eten, denken. Zelfstandig naamwoord: hond, tafel, vrijheid.", "📝", 1),
            ex("Hoe schrijf je de verleden tijd van 'werken'?",
               ["werkte", "werkde", "werkten", "gewerkt"], "werkte",
               "'Werken' is een regelmatig werkwoord. Stam: 'werk'. Verleden tijd: werkte (enkelvoud), werkten (meervoud).", "⏰", 1),
            ex("Wat is een synoniem van 'blij'?",
               ["gelukkig", "verdrietig", "moe", "boos"], "gelukkig",
               "Synoniemen hebben (bijna) dezelfde betekenis. Blij ≈ gelukkig, vrolijk, opgetogen.", "😊", 1),
            ex("Welk lidwoord gebruik je bij 'boek' (onbepaald)?",
               ["een", "de", "het", "een het"], "een",
               "'Het boek' (bepaald lidwoord) maar 'een boek' (onbepaald lidwoord — altijd 'een', voor de-/het-woorden).", "📖", 1),
            ex("Wat is een vergrotende trap (comparatief)?",
               ["De traptrede die twee dingen vergelijkt (groter, mooier...)", "De overtreffende trap (grootst)", "De stellende trap (groot)", "Een onveranderlijke vorm"], "De traptrede die twee dingen vergelijkt (groter, mooier...)",
               "Stellend: groot. Vergrotend: groter. Overtreffend: grootst. 'Dit huis is groter dan dat huis.'", "📏", 2),
            ex("Wat is de functie van een komma?",
               ["Een korte pauze aangeven, zinsdelen scheiden of bijzinnen afbakenen", "Een zin beëindigen", "Een vraag stellen", "Aanhalingstekens vervangen"], "Een korte pauze aangeven, zinsdelen scheiden of bijzinnen afbakenen",
               "Komma's gebruik je bijv. bij opsommingen: 'Ik koop appels, peren en bananen.' en voor bijzinnen.", "✍️", 2),
        ]
        return pool
    }
}
