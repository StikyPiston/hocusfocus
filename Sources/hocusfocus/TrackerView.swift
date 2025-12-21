import SwiftTUI
import Foundation

struct TrackerView: View {
    let onShowStats: () -> Void
    let store = SessionStore()
    @State private var sessions: [Session] = []

    var activeSession: Session? {
        sessions.last(where: { $0.stop == nil })
    }

    var body: some View {
        VStack(spacing: 1) {
            Text(" HocusFocus")
                .bold()
                .padding()
                .foregroundColor(.blue)

            Divider()

            if let session = activeSession {
                VStack(spacing: 1) {
                    Text("Currently tracking:")
                        .foregroundColor(.green)

                    Text("\(session.task.rawValue)")
                        .bold()
                        .foregroundColor(.brightWhite)

                    Text("Started at: \(session.start.formatted(.dateTime.hour().minute()))")
                        .foregroundColor(.green)

                    Button("Stop") {
                        store.stopActive()
                        reloadSessions()
                    }
                        .foregroundColor(.red)

                    Text("Or switch session:")
                        .foregroundColor(.brightBlue)

                    ForEach(Task.allCases, id: \.self) { task in
                        if task != session.task {
                            Button("Switch to \(task.rawValue)") {
                                store.start(task: task)
                                reloadSessions()
                            }
                                .foregroundColor(.cyan)
                        }
                    }
                }
            } else {
                VStack(spacing: 1) {
                    Text("What do you want to do?")
                        .bold()
                        .foregroundColor(.brightBlue)

                    ForEach(Task.allCases, id: \.self) { task in
                        Button(task.rawValue) {
                            store.start(task: task)
                            reloadSessions()
                        }
                            .foregroundColor(.cyan)
                    }
                }
            }

            Divider()

            VStack(spacing: 1) {
                Text("Recent Sessions:")
                    .bold()

                ForEach(sessions.suffix(5), id: \.id) { s in
                    HStack {
                        Text(s.task.rawValue)
                        Spacer()
                        Text(s.stop != nil ? durationString(s) : "Active")
                    }
                }
            }

            Divider()

            Button("Stats") {
                sessions = store.loadSessions()
                onShowStats()
            }
                .foregroundColor(.green)

            Button("Quit") {
                exit(0)
            }
                .foregroundColor(.green)
        }
        .padding()
        .onAppear {
            sessions = store.loadSessions()
        }
    }

    private func reloadSessions() {
        sessions = store.loadSessions()
    }

    private func durationString(_ session: Session) -> String {
        guard let stop = session.stop else { return "Active" }
        let interval = stop.timeIntervalSince(session.start)
        let hours = Int(interval / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours):\(minutes)"
    }
}
