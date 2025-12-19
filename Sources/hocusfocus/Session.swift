import Foundation

struct Session: Codable, Identifiable {
    let id: Int
    let task: Task
    let start: Date
    var stop: Date?
}
