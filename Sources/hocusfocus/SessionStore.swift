import Foundation

final class SessionStore {
    private let baseURL: URL = {
        let url = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".hocusfocus/sessions")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()

    func loadSessions() -> [Session] {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil)
            return try files.compactMap { url in 
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(Session.self, from: data)
            }.sorted { $0.id < $1.id }
        } catch {
            print(" Error loading sessions: \(error)")
            return []
        }
    }

    func saveSession(_ session: Session) {
        let url = baseURL.appendingPathComponent("\(session.id).json")
        do {
            let data = try JSONEncoder().encode(session)
            try data.write(to: url)
        } catch {
            print(" Error saving session: \(error)")
        }
    }

    func start(task: Task) -> Session {
        let sessions = loadSessions()
        if var last = sessions.last, last.stop == nil {
            last.stop = Date()
            saveSession(last)
        }

        let nextID = (sessions.map(\.id).max() ?? 0) + 1
        let session = Session(id: nextID, task: task, start: Date(), stop: nil)
        saveSession(session)
        return session
    }

    func stopActive() {
        let sessions = loadSessions()
        if var last = sessions.last, last.stop == nil {
            last.stop = Date()
            saveSession(last)
        }
    }
}
