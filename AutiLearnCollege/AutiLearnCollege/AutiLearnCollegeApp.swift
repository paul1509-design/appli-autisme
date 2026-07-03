import SwiftUI
import SwiftData

@main
struct AutiLearnCollegeApp: App {
    var body: some Scene {
        WindowGroup {
            CollegeRootView()
                .modelContainer(for: [CollegeProfile.self, CollegeSession.self, CollegeExerciseProgress.self])
                .onAppear { CollegeNotificationService.requestPermission() }
        }
    }
}
