import Foundation

// MARK: - Histoire par pays — programmes scolaires localisés
struct CollegeHistoryLibrary {

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
        case .ukrainian, .polish: return english(level)
        }
    }

    private static func ex(_ q: String, _ choices: [String], _ answer: String,
                            _ explanation: String, _ emoji: String, _ diff: Int) -> CollegeExercise {
        CollegeExercise(subject: .histoire,
                        mode: choices.isEmpty ? .shortAnswer : (choices.count == 2 && (choices.contains("Vrai") || choices.contains("True") || choices.contains("Verdad")) ? .trueFalse : .multipleChoice),
                        question: q, choices: choices, correctAnswer: answer,
                        explanation: explanation, emoji: emoji, difficulty: diff)
    }

    // MARK: - 🇫🇷 France
    private static func french(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("La Révolution française a eu lieu en :", ["1789", "1815", "1848", "1870"], "1789",
               "La Révolution française débute le 14 juillet 1789 avec la prise de la Bastille.", "🗼", 1),
            ex("Quel est le plus grand pays du monde ?", ["Russie", "Canada", "Chine", "USA"], "Russie",
               "La Russie s'étend sur 17 millions de km², elle est la plus grande du monde.", "🌍", 1),
            ex("Charlemagne a été couronné empereur en :", ["800", "987", "1066", "732"], "800",
               "Charlemagne est couronné le 25 décembre 800 par le pape Léon III à Rome.", "👑", 1),
            ex("En quelle année a débuté la Première Guerre mondiale ?", ["1914", "1918", "1939", "1905"], "1914",
               "La Grande Guerre (1914-1918) débute après l'assassinat de François-Ferdinand à Sarajevo.", "🏛️", 2),
            ex("La Déclaration des droits de l'homme date de :", ["1789", "1792", "1804", "1815"], "1789",
               "La DDHC est adoptée par l'Assemblée nationale le 26 août 1789.", "📜", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Le mur de Berlin est tombé en :", ["1989", "1979", "1991", "1985"], "1989",
                   "Le mur de Berlin tombe le 9 novembre 1989, symbolisant la fin de la Guerre froide.", "🧱", 2),
                ex("Cite deux causes de la Seconde Guerre mondiale.", [], "Montée du nazisme / Crise de 1929 / Traité de Versailles",
                   "Le traité de Versailles humiliant, la crise économique et la montée du nazisme sont les causes majeures.", "📜", 3),
                ex("Napoléon Bonaparte a été exilé à :", ["Sainte-Hélène", "l'île d'Elbe (2e exil)", "Corse", "Waterloo"], "Sainte-Hélène",
                   "Après Waterloo (1815), Napoléon est exilé à Sainte-Hélène où il meurt en 1821.", "⚔️", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("La décolonisation africaine s'est principalement déroulée dans les années :", ["1950-1970", "1920-1930", "1900-1910", "1980-1990"], "1950-1970",
                   "Les années 1950-1960 voient une vague d'indépendances africaines, dont l'Algérie en 1962.", "🌍", 3),
                ex("Cite deux enjeux géopolitiques majeurs du XXIe siècle.", [], "Réchauffement climatique / Montée de la Chine / Terrorisme",
                   "Le changement climatique, la rivalité USA-Chine et les crises sanitaires définissent notre époque.", "🌐", 3),
                ex("La Ve République française a été fondée en :", ["1958", "1946", "1944", "1968"], "1958",
                   "La Ve République est créée par de Gaulle en 1958, avec une nouvelle Constitution renforçant l'exécutif.", "🇫🇷", 2),
                ex("Quel événement déclenche la crise du 16 mai 1877 ?", ["Le coup de force de Mac-Mahon contre la chambre républicaine", "La mort de Napoléon III", "L'invasion prussienne", "L'assassinat de Gambetta"], "Le coup de force de Mac-Mahon contre la chambre républicaine",
                   "Mac-Mahon dissout la chambre en 1877. Les républicains gagnent les élections, consolidant la IIIe République.", "📜", 3),
                ex("Le Plan Marshall (1947) avait pour objectif :", ["Reconstruire l'Europe après la guerre grâce à l'aide américaine", "Créer l'OTAN", "Partager Berlin en quatre zones", "Fonder la CEE"], "Reconstruire l'Europe après la guerre grâce à l'aide américaine",
                   "Les États-Unis accordent 13 milliards de dollars pour reconstruire l'Europe occidentale et stopper le communisme.", "🇺🇸", 3),
            ]
        }
        // Exercices supplémentaires Moyen Âge et époque moderne
        pool += [
            ex("Jeanne d'Arc est brûlée vive à :", ["Rouen en 1431", "Paris en 1415", "Orléans en 1429", "Reims en 1429"], "Rouen en 1431",
               "Capturée par les Anglais, Jeanne d'Arc est condamnée pour hérésie et brûlée à Rouen le 30 mai 1431.", "🔥", 2),
            ex("Qui était Clovis ?", ["Le premier roi franc chrétien", "Un évêque médiéval", "Un chevalier croisé", "Un roi carolingien"], "Le premier roi franc chrétien",
               "Clovis (481-511) unifie les Francs et se convertit au christianisme, fondant la monarchie franque.", "👑", 1),
            ex("Les guerres de Religion en France opposent :", ["Catholiques et protestants (huguenots)", "Français et Anglais", "Nobles et paysans", "Paris et les provinces"], "Catholiques et protestants (huguenots)",
               "Les guerres de Religion (1562-1598) déchirent la France. L'Édit de Nantes (1598) y met fin.", "⚔️", 2),
            ex("L'Édit de Nantes (1598) est signé par :", ["Henri IV", "François Ier", "Louis XIV", "Richelieu"], "Henri IV",
               "Henri IV signe l'Édit de Nantes pour mettre fin aux guerres de Religion et accorder des droits aux protestants.", "📜", 2),
            ex("Louis XIV règne pendant environ :", ["72 ans (1643-1715)", "30 ans", "50 ans", "20 ans"], "72 ans (1643-1715)",
               "Louis XIV est le plus long règne de l'histoire de France. Il incarne la monarchie absolue.", "☀️", 1),
        ]
        return pool
    }

    // MARK: - 🇬🇧 United Kingdom
    private static func english(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("When was the Magna Carta signed?", ["1215", "1066", "1348", "1509"], "1215",
               "The Magna Carta (1215) limited the king's power and is a foundation of British constitutional law.", "📜", 1),
            ex("The Norman Conquest of England took place in:", ["1066", "1215", "1348", "1485"], "1066",
               "William the Conqueror defeated Harold II at the Battle of Hastings on 14 October 1066.", "⚔️", 1),
            ex("True or False: The Black Death killed about a third of Europe's population.", ["True", "False"], "True",
               "The Black Death (1347-1351) killed an estimated 30-50% of Europe's population.", "🐀", 2),
            ex("Who was the first Tudor monarch?", ["Henry VII", "Henry VIII", "Elizabeth I", "Edward VI"], "Henry VII",
               "Henry VII became king after defeating Richard III at Bosworth Field in 1485.", "👑", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("In what year did World War I begin?", ["1914", "1939", "1918", "1905"], "1914",
                   "WWI began in 1914 after the assassination of Archduke Franz Ferdinand in Sarajevo.", "🏛️", 2),
                ex("The Battle of Britain took place in:", ["1940", "1939", "1941", "1944"], "1940",
                   "The Battle of Britain (summer 1940) was a key air campaign in which the RAF defended the UK against the Luftwaffe.", "✈️", 2),
                ex("Name two causes of World War II.", [], "Rise of Nazi Germany / Great Depression / Treaty of Versailles",
                   "The harsh terms of Versailles, economic depression and the rise of fascism led to WWII.", "📜", 3),
                ex("The Berlin Wall fell in:", ["1989", "1979", "1991", "1985"], "1989",
                   "The Berlin Wall fell on 9 November 1989, ending the Cold War division of Europe.", "🧱", 2),
            ]
        }
        if level.isLycee {
            pool += [
                ex("When did India gain independence from Britain?", ["1947", "1956", "1939", "1960"], "1947",
                   "India gained independence on 15 August 1947, partitioned into India and Pakistan.", "🇮🇳", 3),
                ex("What was the significance of the 1973 oil crisis?", [], "OPEC embargo caused energy shortages, recession, end of post-war boom",
                   "The 1973 OPEC oil embargo triggered inflation, recession and transformed global energy policy.", "🛢️", 3),
                ex("Brexit referendum took place in:", ["2016", "2019", "2020", "2015"], "2016",
                   "The UK voted 52% to 48% to leave the EU on 23 June 2016.", "🇬🇧", 2),
                ex("The Welfare State in Britain was created mainly after:", ["World War II (1945)", "World War I", "The Great Depression (1930s)", "The Victorian era"], "World War II (1945)",
                   "The post-war Labour government (1945) created the NHS and expanded the welfare state.", "🏥", 3),
                ex("The English Civil War ended with:", ["The execution of King Charles I in 1649", "The restoration of the monarchy in 1649", "A peace treaty with France", "The coronation of Oliver Cromwell"], "The execution of King Charles I in 1649",
                   "Charles I was executed in 1649. England became a republic (Commonwealth) under Oliver Cromwell.", "⚔️", 3),
            ]
        }
        // Additional medieval and early modern exercises
        pool += [
            ex("Which battle in 1066 decided the Norman Conquest?", ["The Battle of Hastings", "The Battle of Bosworth", "The Battle of Agincourt", "The Battle of Crécy"], "The Battle of Hastings",
               "William the Conqueror defeated Harold II at Hastings on 14 October 1066, changing English history forever.", "⚔️", 1),
            ex("The Hundred Years' War was fought between:", ["England and France (1337-1453)", "England and Spain", "England and Scotland", "France and Germany"], "England and France (1337-1453)",
               "The Hundred Years' War began over claims to the French crown and ended with France victorious.", "🏰", 2),
            ex("The Great Fire of London occurred in:", ["1666", "1665", "1688", "1707"], "1666",
               "The Great Fire of London (1666) destroyed most of the medieval city and led to rebuilding in brick and stone.", "🔥", 2),
            ex("The Industrial Revolution began in:", ["Britain in the 18th century", "France in the 17th century", "Germany in the 19th century", "America in the 18th century"], "Britain in the 18th century",
               "Britain led the Industrial Revolution thanks to coal, steam power, canals and the factory system.", "🏭", 2),
            ex("The suffragette movement campaigned for:", ["Women's right to vote", "Workers' rights", "Irish independence", "Free trade"], "Women's right to vote",
               "Suffragettes like Emmeline Pankhurst fought for women's suffrage; women over 30 gained the vote in 1918.", "✊", 2),
            ex("True or False: Scotland joined England and Wales to form Great Britain in 1707.", ["True", "False"], "True",
               "The Acts of Union (1707) united England and Scotland into the Kingdom of Great Britain.", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", 2),
        ]
        return pool
    }

    // MARK: - 🇪🇸 España
    private static func spanish(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("¿En qué año llegó Colón a América?", ["1492", "1516", "1478", "1588"], "1492",
               "Cristóbal Colón llegó a América el 12 de octubre de 1492, financiado por los Reyes Católicos.", "⛵", 1),
            ex("¿Qué fue la Reconquista?", ["La recuperación de la Península Ibérica del dominio musulmán", "Una cruzada en Tierra Santa", "La conquista de América", "Una guerra civil"], "La recuperación de la Península Ibérica del dominio musulmán",
               "La Reconquista (718-1492) fue el proceso por el que los reinos cristianos recuperaron la Península Ibérica.", "🏰", 1),
            ex("¿En qué año se expulsaron los judíos de España?", ["1492", "1478", "1516", "1588"], "1492",
               "El Edicto de Granada (1492) de los Reyes Católicos expulsó a los judíos de España.", "📜", 2),
            ex("¿Cuándo fue la Armada Invencible derrotada?", ["1588", "1492", "1519", "1605"], "1588",
               "La Armada Invencible fue derrotada por Inglaterra en 1588, iniciando el declive del poder español.", "⚓", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("¿Cuándo comenzó la Guerra Civil Española?", ["1936", "1931", "1939", "1923"], "1936",
                   "La Guerra Civil Española comenzó el 18 de julio de 1936 con el levantamiento militar de Franco.", "⚔️", 2),
                ex("¿Quién fue Francisco Franco?", ["Dictador de España (1939-1975)", "Presidente democrático", "Rey de España", "General republicano"], "Dictador de España (1939-1975)",
                   "Francisco Franco gobernó España como dictador desde el fin de la Guerra Civil hasta su muerte en 1975.", "🎖️", 3),
                ex("La Constitución española democrática se aprobó en:", ["1978", "1975", "1931", "1982"], "1978",
                   "La Constitución de 1978 estableció la democracia parlamentaria tras la muerte de Franco.", "📜", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("¿Cuándo ingresó España en la Unión Europea?", ["1986", "1975", "1992", "1999"], "1986",
                   "España ingresó en la Comunidad Económica Europea el 1 de enero de 1986.", "🇪🇺", 2),
                ex("Cita dos consecuencias del colonialismo español en América.", [], "Mestizaje / Evangelización / Explotación de recursos / Enfermedades",
                   "El colonialismo español generó mestizaje cultural, evangelización forzada y explotación de recursos.", "🌎", 3),
                ex("¿Cuándo se restauró la democracia en España tras el franquismo?", ["1975-1978 (Transición)", "1968", "1982", "1992"], "1975-1978 (Transición)",
                   "Tras la muerte de Franco en 1975, España vivió la Transición democrática que culminó con la Constitución de 1978.", "🗳️", 3),
                ex("¿Qué fue el Siglo de Oro español?", ["Un período de esplendor cultural (ss. XVI-XVII)", "Un período de guerras", "El reinado de Carlos III", "La época de Felipe II solamente"], "Un período de esplendor cultural (ss. XVI-XVII)",
                   "El Siglo de Oro abarca los siglos XVI y XVII: Cervantes, Lope de Vega, Velázquez y El Greco.", "🎨", 2),
            ]
        }
        // Ejercicios adicionales medievales y modernos
        pool += [
            ex("¿Quién fue El Cid Campeador?", ["Un caballero cristiano que también luchó con los musulmanes", "Un rey de Castilla", "Un papa medieval", "Un explorador"], "Un caballero cristiano que también luchó con los musulmanes",
               "Rodrigo Díaz de Vivar, El Cid, fue un caballero del siglo XI que luchó para varios señores, cristiano y musulmán.", "⚔️", 2),
            ex("¿Cuándo fue la batalla de Las Navas de Tolosa?", ["1212", "1492", "1085", "1340"], "1212",
               "La batalla de Las Navas de Tolosa (1212) fue una victoria decisiva cristiana que aceleró la Reconquista.", "🏰", 2),
            ex("¿Quién era Carlos I de España?", ["El primer rey Habsburgo de España, también Carlos V del Sacro Imperio", "El hijo de los Reyes Católicos", "El fundador de la Inquisición", "El rey que descubrió América"], "El primer rey Habsburgo de España, también Carlos V del Sacro Imperio",
               "Carlos I (1516-1556) heredó un enorme imperio que incluía España, Países Bajos, partes de Italia y América.", "👑", 2),
            ex("¿Qué fue la Inquisición española?", ["Un tribunal eclesiástico para juzgar herejías", "Un ejército real", "Un consejo de nobles", "Un tribunal civil"], "Un tribunal eclesiástico para juzgar herejías",
               "La Inquisición española (1478-1834) fue creada por los Reyes Católicos para mantener la ortodoxia religiosa.", "⚖️", 2),
            ex("¿En qué año Hernán Cortés conquistó el Imperio azteca?", ["1521", "1492", "1519", "1535"], "1521",
               "Hernán Cortés tomó Tenochtitlán en 1521, poniendo fin al Imperio azteca e iniciando la Nueva España.", "🏛️", 2),
            ex("La batalla de Trafalgar (1805) fue una derrota para:", ["España y Francia frente a Inglaterra", "España frente a Francia", "Francia frente a Inglaterra y España", "Inglaterra frente a España"], "España y Francia frente a Inglaterra",
               "La batalla de Trafalgar supuso la destrucción de la flota franco-española por Nelson e inició el declive naval español.", "⚓", 3),
        ]
        return pool
    }

    // MARK: - 🇵🇹 Portugal
    private static func portuguese(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Quem foi Vasco da Gama?", ["O navegador que descobriu a rota marítima para a Índia", "Um rei português", "Um explorador espanhol", "Um pirata famoso"], "O navegador que descobriu a rota marítima para a Índia",
               "Vasco da Gama chegou à Índia em 1498, abrindo a rota marítima para o Oriente.", "⛵", 1),
            ex("Em que ano ocorreu a Revolução dos Cravos?", ["1974", "1968", "1926", "1910"], "1974",
               "A Revolução dos Cravos (25 de abril de 1974) pôs fim à ditadura do Estado Novo.", "🌸", 1),
            ex("Pedro Álvares Cabral chegou ao Brasil em:", ["1500", "1492", "1519", "1488"], "1500",
               "Pedro Álvares Cabral chegou ao Brasil em 22 de abril de 1500, reivindicando o território para Portugal.", "🌊", 2),
            ex("A ditadura de Salazar durou aproximadamente:", ["40 anos", "10 anos", "20 anos", "5 anos"], "40 anos",
               "António de Oliveira Salazar governou Portugal de 1932 a 1968, num total de cerca de 40 anos.", "🏛️", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Portugal aderiu à CEE (atual UE) em:", ["1986", "1974", "1992", "1999"], "1986",
                   "Portugal aderiu à Comunidade Económica Europeia em 1986, juntamente com a Espanha.", "🇪🇺", 2),
                ex("O que foi o Tratado de Tordesilhas?", ["Um acordo entre Portugal e Espanha para dividir o mundo", "Um tratado de paz europeu", "Uma aliança militar", "Um acordo comercial com a Índia"], "Um acordo entre Portugal e Espanha para dividir o mundo",
                   "O Tratado de Tordesilhas (1494) dividiu o mundo colonial entre Portugal e Espanha.", "🗺️", 3),
                ex("O que foi o Estado Novo de Salazar?", ["Uma ditadura conservadora (1933-1974)", "Uma monarquia constitucional", "Uma república democrática", "Um regime socialista"], "Uma ditadura conservadora (1933-1974)",
                   "O Estado Novo foi um regime autoritário criado por Salazar, caracterizado pelo corporativismo e censura.", "🏛️", 3),
                ex("A independência do Brasil de Portugal ocorreu em:", ["1822", "1808", "1889", "1910"], "1822",
                   "O Brasil declarou independência em 7 de setembro de 1822, com D. Pedro I como imperador.", "🇧🇷", 2),
                ex("Quem foi Afonso Henriques?", ["O primeiro rei de Portugal (1139)", "Um explorador do século XV", "Um general napoleónico", "O fundador do Brasil"], "O primeiro rei de Portugal (1139)",
                   "Afonso Henriques fundou o Reino de Portugal após a batalha de Ourique (1139) e expulsou os mouros do norte.", "👑", 2),
            ]
        }
        pool += [
            ex("Qual foi a importância da batalha de Aljubarrota (1385)?", ["Garantiu a independência de Portugal face a Castela", "Conquistou o Brasil", "Fundou Lisboa", "Expulsou os mouros"], "Garantiu a independência de Portugal face a Castela",
               "Aljubarrota (1385) consolidou a dinastia de Avis e a independência portuguesa face à Espanha.", "⚔️", 2),
            ex("O Marquês de Pombal ficou famoso por:", ["Reconstruir Lisboa após o terramoto de 1755 e reformar o Estado", "Descobrir o Brasil", "Iniciar a Inquisição", "Assinar a Revolução dos Cravos"], "Reconstruir Lisboa após o terramoto de 1755 e reformar o Estado",
               "Pombal foi o grande reformador do Portugal do século XVIII, com um governo iluminado e centralizador.", "🏙️", 2),
            ex("Em que século foram as Descobertas portuguesas mais intensas?", ["Séculos XV e XVI", "Séculos XII e XIII", "Século XVII", "Século XVIII"], "Séculos XV e XVI",
               "Portugal explorou a costa africana, chegou à Índia (1498) e ao Brasil (1500) nos séculos XV-XVI.", "⛵", 1),
            ex("A Primeira República portuguesa foi proclamada em:", ["1910", "1926", "1974", "1890"], "1910",
               "A República foi proclamada em 5 de outubro de 1910 após a revolução que derrubou a monarquia.", "🗳️", 2),
            ex("A Batalha de Alcácer Quibir (1578) teve como consequência:", ["A perda da independência portuguesa para a Espanha (60 anos)", "A conquista de Marrocos", "A fundação do Brasil", "A derrota dos holandeses"], "A perda da independência portuguesa para a Espanha (60 anos)",
               "A morte do rei D. Sebastião sem herdeiros levou à anexação de Portugal por Filipe II de Espanha até 1640.", "⚔️", 3),
        ]
        return pool
    }

    // MARK: - 🇮🇹 Italia
    private static func italian(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Cosa fu il Rinascimento?", ["Un periodo di fioritura artistica e culturale (XIV-XVI sec.)", "Una guerra medievale", "Una rivoluzione politica", "Una dinastia reale"], "Un periodo di fioritura artistica e culturale (XIV-XVI sec.)",
               "Il Rinascimento (XIV-XVI sec.) fu un movimento culturale e artistico che ebbe origine in Italia.", "🎨", 1),
            ex("Chi dipinse la Cappella Sistina?", ["Michelangelo", "Leonardo da Vinci", "Raffaello", "Botticelli"], "Michelangelo",
               "Michelangelo dipinse la volta della Cappella Sistina tra il 1508 e il 1512.", "🖌️", 1),
            ex("Il Risorgimento italiano portò all'unificazione nel:", ["1861", "1848", "1815", "1871"], "1861",
               "Il Regno d'Italia fu proclamato il 17 marzo 1861 con Vittorio Emanuele II come primo re.", "🇮🇹", 2),
            ex("Chi fu Benito Mussolini?", ["Il fondatore del fascismo e dittatore d'Italia (1922-1943)", "Un re d'Italia", "Un generale della Prima Guerra Mondiale", "Un politico democratico"], "Il fondatore del fascismo e dittatore d'Italia (1922-1943)",
               "Mussolini fondò il Partito Fascista e governò l'Italia come duce dal 1922 al 1943.", "🎖️", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("L'Italia è diventata una Repubblica nel:", ["1946", "1948", "1943", "1922"], "1946",
                   "Il referendum del 2 giugno 1946 decise la forma repubblicana dell'Italia.", "🗳️", 2),
                ex("Cita due conseguenze della Seconda Guerra Mondiale per l'Italia.", [], "Perdita di territori / Fine della monarchia / Piano Marshall / Costituzione 1948",
                   "L'Italia perse territori, divenne Repubblica, ricevette aiuti dal Piano Marshall e adottò la Costituzione nel 1948.", "📜", 3),
                ex("Quando fu fondata la CEE di cui l'Italia era membro fondatore?", ["1957 (Trattato di Roma)", "1951", "1945", "1963"], "1957 (Trattato di Roma)",
                   "L'Italia fu uno dei sei paesi fondatori della Comunità Economica Europea con il Trattato di Roma del 1957.", "🇪🇺", 2),
                ex("Chi fu Garibaldi?", ["Il generale che unificò l'Italia con la spedizione dei Mille (1860)", "Il primo re d'Italia", "Un pittore del Risorgimento", "Un filosofo politico"], "Il generale che unificò l'Italia con la spedizione dei Mille (1860)",
                   "Giuseppe Garibaldi guidò i Mille (volontari) conquistando il Regno delle Due Sicilie e favorendo l'unificazione.", "🇮🇹", 2),
                ex("Cosa fu la Resistenza italiana (1943-1945)?", ["Il movimento partigiano contro l'occupazione nazifascista", "Un partito politico", "Una corrente artistica", "Una rivolta operaia"], "Il movimento partigiano contro l'occupazione nazifascista",
                   "I partigiani italiani combatterono contro i tedeschi e i fascisti della Repubblica Sociale di Salò.", "⚔️", 3),
            ]
        }
        pool += [
            ex("Chi fu Leonardo da Vinci?", ["Artista, scienziato e inventore del Rinascimento", "Un papa del Rinascimento", "Un re di Firenze", "Un generale medievale"], "Artista, scienziato e inventore del Rinascimento",
               "Leonardo da Vinci (1452-1519) dipinse la Gioconda e L'Ultima Cena e progettò macchine secoli prima del loro tempo.", "🎨", 1),
            ex("Dove fu fondata la Repubblica di Venezia?", ["Nelle lagune dell'Adriatico settentrionale (V-VI sec.)", "In Sicilia", "A Roma", "In Toscana"], "Nelle lagune dell'Adriatico settentrionale (V-VI sec.)",
               "Venezia fu una potente Repubblica marinara per oltre mille anni, centro commerciale tra Oriente e Occidente.", "🚢", 1),
            ex("Chi fu Giulio Cesare?", ["Un generale e politico romano che fu assassinato alle Idi di Marzo del 44 a.C.", "Il primo imperatore romano", "Un filosofo greco", "Un re medievale"], "Un generale e politico romano che fu assassinato alle Idi di Marzo del 44 a.C.",
               "Giulio Cesare conquistò la Gallia e fu assassinato il 15 marzo 44 a.C. da Bruto e Cassio.", "🏛️", 1),
            ex("Quando cadde l'Impero Romano d'Occidente?", ["476 d.C.", "410 d.C.", "395 d.C.", "313 d.C."], "476 d.C.",
               "L'Impero Romano d'Occidente cadde nel 476 d.C. con la deposizione di Romolo Augustolo da parte di Odoacre.", "🏛️", 2),
            ex("La Prima Guerra Mondiale fu per l'Italia anche chiamata:", ["La Quarta guerra d'indipendenza", "La Grande Vittoria", "La guerra inutile", "La Marcia su Roma"], "La Quarta guerra d'indipendenza",
               "L'Italia entrò in guerra nel 1915 con la speranza di completare l'unità nazionale e ottenere Trento e Trieste.", "🏔️", 3),
        ]
        return pool
    }

    // MARK: - 🇩🇪 Deutschland
    private static func german(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Wann begann die Reformation in Deutschland?", ["1517", "1648", "1415", "1555"], "1517",
               "Martin Luther veröffentlichte 1517 seine 95 Thesen und leitete damit die Reformation ein.", "⛪", 1),
            ex("Wann wurde das Deutsche Reich gegründet?", ["1871", "1848", "1815", "1866"], "1871",
               "Das Deutsche Reich wurde am 18. Januar 1871 im Spiegelsaal von Versailles ausgerufen.", "🇩🇪", 1),
            ex("Wann begann der Erste Weltkrieg?", ["1914", "1939", "1918", "1905"], "1914",
               "Der Erste Weltkrieg begann 1914 nach dem Attentat auf Erzherzog Franz Ferdinand.", "🏛️", 2),
            ex("Adolf Hitler wurde Reichskanzler im Jahr:", ["1933", "1939", "1929", "1936"], "1933",
               "Hitler wurde am 30. Januar 1933 Reichskanzler und errichtete die nationalsozialistische Diktatur.", "📜", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Wann fiel die Berliner Mauer?", ["1989", "1991", "1979", "1985"], "1989",
                   "Die Berliner Mauer fiel am 9. November 1989 und symbolisierte das Ende des Kalten Krieges.", "🧱", 2),
                ex("Die Wiedervereinigung Deutschlands fand statt im:", ["1990", "1989", "1991", "1992"], "1990",
                   "Die deutsche Wiedervereinigung erfolgte offiziell am 3. Oktober 1990.", "🇩🇪", 2),
                ex("Nenne zwei Ursachen des Zweiten Weltkriegs.", [], "Aufstieg des Nationalsozialismus / Weltwirtschaftskrise / Versailler Vertrag",
                   "Der Vertrag von Versailles, die Weltwirtschaftskrise und der Aufstieg der NSDAP führten zum Krieg.", "📜", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("Was ist das Grundgesetz?", ["Die Verfassung der Bundesrepublik Deutschland (1949)", "Ein Schulgesetz", "Ein Handelsvertrag", "Eine Verfassung der DDR"], "Die Verfassung der Bundesrepublik Deutschland (1949)",
                   "Das Grundgesetz (1949) ist die Verfassung Deutschlands und Grundlage der demokratischen Ordnung.", "📋", 2),
                ex("Was war die Weimarer Republik?", ["Deutschlands erste Demokratie (1919-1933)", "Eine Monarchie", "Ein sozialistischer Staat", "Ein Kaiserreich"], "Deutschlands erste Demokratie (1919-1933)",
                   "Die Weimarer Republik entstand nach dem Ersten Weltkrieg, litt unter Inflation und Krisen und endete 1933 mit Hitlers Machtergreifung.", "🏛️", 3),
                ex("Was geschah am 9. November 1938 (Reichspogromnacht)?", ["Zerstörung jüdischer Synagogen und Geschäfte durch die Nazis", "Beginn des Zweiten Weltkriegs", "Fall der Berliner Mauer", "Ausrufung der Republik"], "Zerstörung jüdischer Synagogen und Geschäfte durch die Nazis",
                   "In der Pogromnacht wurden Synagogen angezündet, Geschäfte verwüstet und Juden verhaftet und ermordet.", "📜", 3),
            ]
        }
        pool += [
            ex("Welche Sprache sprach man im Heiligen Römischen Reich?", ["Viele Sprachen — Deutsch, Latein, Französisch, Tschechisch...", "Nur Latein", "Nur Deutsch", "Nur Französisch"], "Viele Sprachen — Deutsch, Latein, Französisch, Tschechisch...",
               "Das Heilige Römische Reich (962-1806) war ein Vielvölkerstaat. Latein war die Verwaltungssprache.", "🏰", 2),
            ex("Wann endete das Heilige Römische Reich Deutscher Nation?", ["1806", "1648", "1871", "1517"], "1806",
               "Napoleon zwang Kaiser Franz II. 1806 zur Auflösung des Reiches. Es folgte der Rheinbund.", "👑", 2),
            ex("Was war der Dreißigjährige Krieg?", ["Ein Religionskrieg (1618-1648), der Europa verwüstete", "Ein Krieg gegen Frankreich", "Eine Bauernrevolte", "Ein Kreuzzug"], "Ein Religionskrieg (1618-1648), der Europa verwüstete",
               "Der Dreißigjährige Krieg begann als Religionskrieg und endete mit dem Westfälischen Frieden 1648.", "⚔️", 2),
            ex("Was war die Berliner Luftbrücke (1948-49)?", ["Westliche Versorgungsflüge zur Umgehung der sowjetischen Blockade West-Berlins", "Ein Militärangriff", "Eine diplomatische Konferenz", "Eine Rüstungsaktion"], "Westliche Versorgungsflüge zur Umgehung der sowjetischen Blockade West-Berlins",
               "Als die Sowjets West-Berlin blockierten, versorgten die Alliierten die Stadt über 11 Monate per Flugzeug.", "✈️", 3),
            ex("Wann begann die nationalsozialistische Verfolgung der Juden systematisch?", ["Ab 1933, Höhepunkt 1942 (Wannsee-Konferenz)", "Erst 1939", "Erst 1941", "Schon 1920"], "Ab 1933, Höhepunkt 1942 (Wannsee-Konferenz)",
               "Die Nürnberger Gesetze (1935) entzogen Juden die Bürgerrechte. Die Wannsee-Konferenz (1942) plante den Holocaust.", "📜", 3),
        ]
        return pool
    }

    // MARK: - 🇸🇦 العالم العربي
    private static func arabic(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("متى بدأ الإسلام؟", ["في القرن السابع الميلادي (610 م)", "في القرن الخامس", "في القرن الثامن", "في القرن العاشر"], "في القرن السابع الميلادي (610 م)",
               "بدأ الإسلام بنزول الوحي على النبي محمد ﷺ عام 610 م في غار حراء بمكة المكرمة.", "🕌", 1),
            ex("ما هي عاصمة الخلافة العباسية؟", ["بغداد", "دمشق", "القاهرة", "مكة"], "بغداد",
               "بغداد أسسها الخليفة المنصور عام 762 م وكانت مركز العلم والحضارة الإسلامية.", "🏛️", 1),
            ex("من فتح مصر للعرب؟", ["عمرو بن العاص", "خالد بن الوليد", "أبو بكر الصديق", "صلاح الدين"], "عمرو بن العاص",
               "فتح عمرو بن العاص مصر بين عامَي 639 و641 م في عهد الخليفة عمر بن الخطاب.", "⚔️", 2),
            ex("متى كانت معركة حطين؟", ["1187", "1099", "1258", "1453"], "1187",
               "في معركة حطين (1187م) انتصر صلاح الدين الأيوبي على الصليبيين واستعاد القدس.", "🏰", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("متى سقطت الخلافة العثمانية؟", ["1924", "1918", "1908", "1945"], "1924",
                   "ألغى مصطفى كمال أتاتورك الخلافة العثمانية في مارس 1924 وأعلن الجمهورية التركية.", "🗺️", 2),
                ex("اذكر نتيجتين للاستعمار الأوروبي في العالم العربي.", [], "تفتيت الوحدة العربية / رسم حدود اصطناعية / استغلال الموارد / نشر اللغات الأوروبية",
                   "خلّف الاستعمار حدوداً اصطناعية وتبعية اقتصادية وصراعات لا تزال مستمرة.", "📜", 3),
                ex("ما هو اتفاق سايكس-بيكو (1916)؟", ["اتفاق سري بريطاني-فرنسي لتقسيم المشرق العربي", "معاهدة سلام مع العثمانيين", "اتفاقية لحماية المسلمين", "حلف عسكري عربي"], "اتفاق سري بريطاني-فرنسي لتقسيم المشرق العربي",
                   "رسم سايكس-بيكو حدود سوريا والعراق ولبنان وفلسطين لخدمة المصالح الاستعمارية الأوروبية.", "🗺️", 3),
                ex("متى استقلت مصر عن بريطانيا؟", ["1922 (رسمياً)، وفعلياً 1952 بعد ثورة الضباط", "1945", "1919", "1956"], "1922 (رسمياً)، وفعلياً 1952 بعد ثورة الضباط",
                   "حصلت مصر على استقلال شكلي عام 1922، لكن ثورة 1952 بقيادة ناصر أنهت النفوذ البريطاني فعلياً.", "🇪🇬", 3),
            ]
        }
        pool += [
            ex("ما هو عصر ازدهار الحضارة الإسلامية؟", ["العصر العباسي (750-1258م) — العصر الذهبي", "العصر الأموي فقط", "القرن العشرون", "العصر الراشدي فقط"], "العصر العباسي (750-1258م) — العصر الذهبي",
               "في العصر العباسي ازدهرت العلوم والفلسفة والطب والرياضيات. ترجمت العلوم اليونانية وطورت.", "📚", 1),
            ex("ما هو دور ابن سينا في تاريخ العلوم؟", ["طبيب وفيلسوف وضع القانون في الطب، مرجعاً لقرون", "شاعر عربي كلاسيكي", "قائد عسكري أموي", "مؤسس علم الكيمياء"], "طبيب وفيلسوف وضع القانون في الطب، مرجعاً لقرون",
               "ابن سينا (980-1037م) كتب 'القانون في الطب' الذي ظل مرجعاً طبياً في أوروبا حتى القرن XVII.", "🏥", 2),
            ex("ما هي الأندلس؟", ["الأراضي الإسلامية في شبه الجزيرة الإيبيرية (711-1492م)", "إقليم عربي في أفريقيا", "مدينة في المغرب", "جزيرة إسلامية"], "الأراضي الإسلامية في شبه الجزيرة الإيبيرية (711-1492م)",
               "الأندلس كانت مركزاً للحضارة الإسلامية في أوروبا، ومنه انتقلت العلوم العربية إلى الغرب.", "🏰", 1),
            ex("من هو صلاح الدين الأيوبي؟", ["محرر القدس من الصليبيين عام 1187م", "خليفة عباسي", "قائد عثماني", "ملك مغربي"], "محرر القدس من الصليبيين عام 1187م",
               "صلاح الدين مؤسس الأسرة الأيوبية، انتصر في حطين واستعاد القدس من الصليبيين عام 1187م.", "⚔️", 1),
            ex("متى تأسست جامعة الأزهر في القاهرة؟", ["970م في عهد الفاطميين", "1000م", "850م", "1200م"], "970م في عهد الفاطميين",
               "الأزهر أُسِّس عام 970م ويُعدّ من أقدم الجامعات في العالم، ولا يزال مرجعاً للعلم الإسلامي.", "🕌", 1),
        ]
        return pool
    }

    // MARK: - 🇳🇱 Nederland
    private static func dutch(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Wanneer was de Gouden Eeuw van Nederland?", ["17e eeuw", "16e eeuw", "18e eeuw", "15e eeuw"], "17e eeuw",
               "De Gouden Eeuw (17e eeuw) was een periode van grote welvaart, kunst en handelsexpansie voor Nederland.", "🌟", 1),
            ex("Wat was de VOC?", ["De Vereenigde Oost-Indische Compagnie — eerste multinational ter wereld", "Een militaire vloot", "Een politieke partij", "Een kunstverzameling"], "De Vereenigde Oost-Indische Compagnie — eerste multinational ter wereld",
               "De VOC (1602) was 's werelds eerste naamloze vennootschap en domineerde de Aziatische handel.", "⛵", 1),
            ex("Wanneer werd Nederland onafhankelijk van Spanje?", ["1648", "1588", "1515", "1700"], "1648",
               "De Vrede van Münster (1648) erkende officieel de onafhankelijkheid van de Republiek der Zeven Verenigde Nederlanden.", "📜", 2),
            ex("Wanneer was de bevrijding van Nederland in WOII?", ["1945", "1944", "1943", "1940"], "1945",
               "Nederland werd in mei 1945 bevrijd door geallieerde troepen, na vijf jaar Duitse bezetting.", "🌷", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Wanneer trad Nederland toe tot de EEG?", ["1957", "1973", "1945", "1986"], "1957",
                   "Nederland was een van de zes oprichtende leden van de EEG bij het Verdrag van Rome (1957).", "🇪🇺", 2),
                ex("Noem twee gevolgen van de Nederlandse kolonisatie.", [], "Handel en welvaart / Slavernij / Culturele uitwisseling / Verlies inheemse culturen",
                   "De Nederlandse kolonisatie bracht welvaart via handel maar ook slavernij en onderdrukking van inheemse volken.", "🌍", 3),
                ex("Wat was de Tachtigjarige Oorlog?", ["De Nederlandse onafhankelijkheidsstrijd tegen Spanje (1568-1648)", "Een oorlog met Frankrijk", "Een religieuze strijd in Duitsland", "Een handelsoorlog"], "De Nederlandse onafhankelijkheidsstrijd tegen Spanje (1568-1648)",
                   "De Opstand (1568-1648) leidde tot de onafhankelijkheid van de Republiek der Zeven Verenigde Nederlanden.", "⚔️", 2),
                ex("Wanneer begon de Duitse bezetting van Nederland?", ["Mei 1940", "September 1939", "Juni 1941", "April 1940"], "Mei 1940",
                   "Duitsland viel Nederland op 10 mei 1940 binnen. Na vijf dagen capituleerde het Nederlandse leger.", "🪖", 2),
                ex("Wat was de Hongerwinter?", ["De winter 1944-45 waarbij duizenden Nederlanders verhongerden door de bezetting", "Een strenge winter in 1814", "Een misoogst in de 18e eeuw", "Een economische crisis na de oorlog"], "De winter 1944-45 waarbij duizenden Nederlanders verhongerden door de bezetting",
                   "De Hongerwinter (1944-45) doodde naar schatting 18.000-22.000 mensen in het bezette westen van Nederland.", "❄️", 3),
            ]
        }
        pool += [
            ex("Wie was Willem van Oranje?", ["De leider van de Nederlandse Opstand tegen Spanje (16e eeuw)", "Een schilder van de Gouden Eeuw", "Een VOC-directeur", "Een Nederlandse koning"], "De leider van de Nederlandse Opstand tegen Spanje (16e eeuw)",
               "Willem van Oranje (1533-1584) leidde de opstand tegen Filips II van Spanje en wordt 'Vader des Vaderlands' genoemd.", "🍊", 1),
            ex("Waar was Amsterdam beroemd om in de Gouden Eeuw?", ["Handel, bankwezen, kunst en tolerantie", "Militaire kracht", "Landbouw", "Mijnbouw"], "Handel, bankwezen, kunst en tolerantie",
               "Amsterdam was in de 17e eeuw de rijkste stad ter wereld dankzij de VOC-handel en het financiële systeem.", "💰", 1),
            ex("Wanneer werd het Koninkrijk der Nederlanden gesticht?", ["1815", "1648", "1830", "1945"], "1815",
               "Na de napoleontische periode werd het Koninkrijk der Nederlanden gesticht met Willem I als eerste koning.", "👑", 2),
            ex("Wat was de Watersnoodramp?", ["De grote overstroming van 1953 in Zeeland en Zuid-Holland", "Een stormvloed in de 17e eeuw", "Een dijkdoorbraak in Friesland", "De overstroming van de Waal in 1995"], "De grote overstroming van 1953 in Zeeland en Zuid-Holland",
               "De ramp van 1 februari 1953 kostte 1.836 mensen het leven en leidde tot de aanleg van de Deltawerken.", "🌊", 2),
            ex("Wat was de betekenis van het Verdrag van Münster (1648) voor Nederland?", ["Het erkende officieel de Nederlandse onafhankelijkheid van Spanje", "Het beëindigde de Eerste Wereldoorlog", "Het stichtte de VOC", "Het verenigde Noord en Zuid"], "Het erkende officieel de Nederlandse onafhankelijkheid van Spanje",
               "Het Verdrag van Münster was deel van de Vrede van Westfalen en beëindigde tachtig jaar oorlog.", "📜", 2),
            ex("Welke Nederlandse schilder is beroemd om 'De Nachtwacht'?", ["Rembrandt van Rijn", "Johannes Vermeer", "Jan Steen", "Frans Hals"], "Rembrandt van Rijn",
               "'De Nachtwacht' (1642) is het beroemdste schilderij van Rembrandt en hangt in het Rijksmuseum Amsterdam.", "🖌️", 1),
        ]
        return pool
    }
}
