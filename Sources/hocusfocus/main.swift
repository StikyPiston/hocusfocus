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

extension SessionStore {
    func currentTask() -> Task? {
        let sessions = loadSessions()
        return sessions.last(where: { $0.stop == nil })?.task
    }
}

let store = SessionStore()

if CommandLine.arguments.dropFirst().contains("currentsession") {
    if let task = store.currentTask() {
        print(" Current Session: \(task.rawValue)")
    } else {
        print(" No current session")
    }
} else {
    Application(rootView: RootView()).start()
}
