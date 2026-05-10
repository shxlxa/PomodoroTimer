import Foundation

// MARK: - Timer Phase

enum TimerPhase: String, CaseIterable, Codable {
    case work
    case shortBreak
    case longBreak

    var label: String {
        switch self {
        case .work: return "专注"
        case .shortBreak: return "短休息"
        case .longBreak: return "长休息"
        }
    }
}

// MARK: - Timer Status

enum TimerStatus: String, Codable {
    case idle
    case running
    case paused
}

// MARK: - Settings Keys & Defaults

enum SettingsKey: String {
    case workDuration
    case shortBreakDuration
    case longBreakDuration
    case longBreakInterval
    case soundEnabled
    case notificationEnabled

    var defaultValue: Any {
        switch self {
        case .workDuration: return 25.0
        case .shortBreakDuration: return 5.0
        case .longBreakDuration: return 15.0
        case .longBreakInterval: return 4
        case .soundEnabled: return true
        case .notificationEnabled: return true
        }
    }
}
