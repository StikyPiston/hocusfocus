import SwiftTUI
import Foundation

struct TrackerView: View {
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

            Divider()

            if let session = activeSession {
                VStack(spacing: 1) {
                    Text("Currently tracking:")

                    Text("\(session.task.rawValue)")
                        .bold()

                    Text("Started at: \(session.start.formatted(.dateTime.hour().minute()))")

                    Button("Stop") {
                        store.stopActive()
                        reloadSessions()
                    }

                    Text("Or switch tasks:")

                    ForEach(Task.allCases, id: \.self) { task in
                        if task != session.task {
                            Button("Switch to \(task.rawValue)") {
                                store.start(task: task)
                                reloadSessions()
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 1) {
                    Text("What do you want to do?")
                        .bold()

                    ForEach(Task.allCases, id: \.self) { task in
                        Button(task.rawValue) {
                            store.start(task: task)
                            reloadSessions()
                        }
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
        }
        .padding()
        .onAppear {
            reloadSessions()
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
