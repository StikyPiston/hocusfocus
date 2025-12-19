import SwiftTUI
import Foundation

struct StatsView: View {
    let sessions: [Session]
    let onBack: () -> Void

    var totals: [Task: TimeInterval] {
        var result: [Task: TimeInterval] = [:]
        Task.allCases.forEach { result[$0] = 0 }
        for session in sessions {
            let duration = (session.stop ?? Date()).timeIntervalSince(session.start)
            result[session.task, default: 0] += duration
        }
        return result
    }

    var body: some View {
        VStack(spacing: 1) {
            Text(" Stats")
                .bold()
                .foregroundColor(.blue)

            Divider()

            ForEach(Task.allCases, id: \.self) { task in
                HStack {
                    Text(task.rawValue)
                        .foregroundColor(.brightBlue)
                    Spacer()
                    Text(durationString(totals[task]!))
                        .foregroundColor(.cyan)
                }
            }

            Divider()

            Button("Back") {
                onBack()
            }
                .foregroundColor(.green)
        }
        .padding()
    }

    private func durationString(_ interval: TimeInterval) -> String {
        let hours = Int(interval / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours):\(minutes)"
    }
}

