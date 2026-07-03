import SwiftUI
import SwiftData

@main
struct AutiLearnApp: App {
    let container: ModelContainer
    @StateObject private var subscriptionService = SubscriptionService()
    @StateObject private var appState = AppState()

    init() {
        do {
            container = try ModelContainer(for:
                ChildProfile.self,
                LearningSession.self,
                WordProgress.self,
                WeeklyReport.self
            )
        } catch {
            fatalError("Impossible de créer le ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(container)
                .environmentObject(subscriptionService)
                .environmentObject(appState)
                .onAppear {
                    subscriptionService.checkSubscriptionStatus()
                    ABANotificationService.requestPermission()
                }
        }
    }
}
