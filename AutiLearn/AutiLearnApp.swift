import SwiftUI

@main
struct AutiLearnApp: App {
    @StateObject private var dataStore = DataStore()
    @StateObject private var subscriptionService = SubscriptionService()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(dataStore)
                .environmentObject(subscriptionService)
                .environmentObject(appState)
                .onAppear {
                    subscriptionService.checkSubscriptionStatus()
                    ABANotificationService.requestPermission()
                }
        }
    }
}
