import SwiftTUI

enum Screen {
    case tracker
    case stats
}

struct RootView: View {
    @State private var currentScreen: Screen = .tracker
    @State private var sessions: [Session] = []

    var body: some View {
        Group {
            switch currentScreen {
            case .tracker:
                TrackerView(
                    onShowStats: {
                        sessions = SessionStore().loadSessions()
                        currentScreen = .stats
                    }
                )
            case .stats:
                StatsView(
                    sessions: sessions,
                    onBack: {
                        currentScreen = .tracker
                    }
                )
            }
        }
    }
}

Application(rootView: RootView()).start()
