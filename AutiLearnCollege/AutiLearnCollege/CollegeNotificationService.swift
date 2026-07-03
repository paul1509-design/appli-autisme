import UserNotifications
import Foundation

struct CollegeNotificationService {

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // Planifie une notification quotidienne à l'heure choisie
    static func scheduleDailyReminder(studentName: String, hour: Int, language: CollegeLanguage) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["college_daily_reminder"])

        let content = UNMutableNotificationContent()
        content.title = notificationTitle(name: studentName, language: language)
        content.body  = notificationBody(name: studentName, language: language)
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour   = hour
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "college_daily_reminder",
                                            content: content,
                                            trigger: trigger)
        center.add(request)
    }

    static func cancelReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["college_daily_reminder"])
    }

    // MARK: - Textes multilingues
    private static func notificationTitle(name: String, language: CollegeLanguage) -> String {
        switch language {
        case .french:     return "C'est l'heure de la session de \(name) ! 🎓"
        case .english:    return "\(name)'s learning session is ready! 🎓"
        case .spanish:    return "¡Es la hora de la sesión de \(name)! 🎓"
        case .portuguese: return "É hora da sessão de \(name)! 🎓"
        case .italian:    return "È l'ora della sessione di \(name)! 🎓"
        case .german:     return "Zeit für \(name)s Lerneinheit! 🎓"
        case .arabic:     return "!حان وقت جلسة \(name) 🎓"
        case .dutch:      return "Het is tijd voor de sessie van \(name)! 🎓"
        }
    }

    private static func notificationBody(name: String, language: CollegeLanguage) -> String {
        switch language {
        case .french:     return "15 minutes par jour maintiennent la progression. Bonne session ! 💪"
        case .english:    return "15 minutes a day keeps the progress going. Great session! 💪"
        case .spanish:    return "15 minutos al día mantienen el progreso. ¡Buena sesión! 💪"
        case .portuguese: return "15 minutos por dia mantêm o progresso. Boa sessão! 💪"
        case .italian:    return "15 minuti al giorno mantengono il progresso. Buona sessione! 💪"
        case .german:     return "15 Minuten täglich erhalten den Fortschritt. Viel Erfolg! 💪"
        case .arabic:     return "15 دقيقة يومياً تحافظ على التقدم. جلسة موفقة! 💪"
        case .dutch:      return "15 minuten per dag houden de voortgang gaande. Goede sessie! 💪"
        }
    }
}
