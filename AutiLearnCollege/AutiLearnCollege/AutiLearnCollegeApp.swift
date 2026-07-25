import SwiftUI

@main
struct AutiLearnCollegeApp: App {
    @StateObject private var dataStore = CollegeDataStore()
    @StateObject private var sub = CollegeSubscriptionService()

    var body: some Scene {
        WindowGroup {
            CollegeRootView()
                .environmentObject(dataStore)
                .environmentObject(sub)
                .onAppear { CollegeNotificationService.requestPermission() }
        }
    }
}
