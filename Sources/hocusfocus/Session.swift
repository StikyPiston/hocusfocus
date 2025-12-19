import Foundation

struct Session: Codable, Identifiable {
    let id: Int
    let task: Task
    let start: Date
    let stop: Date?

    var isActive: Bool { stop == nil }

    var duration: TimeInterval {
        (stop ?? Date()).timeIntervalSince(start)
    }
}
