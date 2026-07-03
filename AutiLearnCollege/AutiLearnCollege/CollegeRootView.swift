import SwiftUI
import SwiftData

enum CollegeScreen {
    case splash, onboarding, home
}

@MainActor
class CollegeAppState: ObservableObject {
    @Published var screen: CollegeScreen = .splash
    @Published var currentStudent: CollegeProfile?
}

struct CollegeRootView: View {
    @StateObject private var appState = CollegeAppState()
    @Query private var students: [CollegeProfile]

    var body: some View {
        switch appState.screen {
        case .splash:
            CollegeSplashView {
                if let existing = students.first {
                    appState.currentStudent = existing
                    appState.screen = .home
                } else {
                    appState.screen = .onboarding
                }
            }
        case .onboarding:
            CollegeOnboardingView { profile in
                appState.currentStudent = profile
                appState.screen = .home
            }
        case .home:
            if let student = appState.currentStudent ?? students.first {
                CollegeHomeView(student: student)
                    .environmentObject(appState)
            } else {
                CollegeOnboardingView { profile in
                    appState.currentStudent = profile
                    appState.screen = .home
                }
            }
        }
    }
}
