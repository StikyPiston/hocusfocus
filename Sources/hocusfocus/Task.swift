enum Task: String, Codable, CaseIterable {
    case work = "WORK"
    case study = "STUDY"
    case waste = "WASTE"

    var label: String {
        switch self {
            case .work: return "󰏪 Work"
            case .study: return " Study"
            case .waste: return " Waste"
        }
    }
}
