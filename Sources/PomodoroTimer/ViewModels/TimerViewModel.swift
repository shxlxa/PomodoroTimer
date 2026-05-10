import Combine
import SwiftUI

final class TimerViewModel: ObservableObject {
    // MARK: - Published State

    @Published var phase: TimerPhase = .work
    @Published var status: TimerStatus = .idle
    @Published var timeRemaining: TimeInterval
    @Published var completedPomodoros: Int = 0

    // MARK: - Settings

    @AppStorage(SettingsKey.workDuration.rawValue) var workDuration: Double = 25
    @AppStorage(SettingsKey.shortBreakDuration.rawValue) var shortBreakDuration: Double = 5
    @AppStorage(SettingsKey.longBreakDuration.rawValue) var longBreakDuration: Double = 15
    @AppStorage(SettingsKey.longBreakInterval.rawValue) var longBreakInterval: Int = 4
    @AppStorage(SettingsKey.soundEnabled.rawValue) var soundEnabled: Bool = true
    @AppStorage(SettingsKey.notificationEnabled.rawValue) var notificationEnabled: Bool = true

    // MARK: - Computed Properties

    var totalDuration: TimeInterval {
        switch phase {
        case .work: return max(workDuration, 1) * 60
        case .shortBreak: return max(shortBreakDuration, 1) * 60
        case .longBreak: return max(longBreakDuration, 1) * 60
        }
    }

    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return 1 - (timeRemaining / totalDuration)
    }

    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Private

    private var cancellable: AnyCancellable?

    // MARK: - Init

    init() {
        timeRemaining = 25 * 60
    }

    // MARK: - Actions

    func start() {
        guard status != .running else { return }
        if status == .idle {
            phase = .work
            timeRemaining = totalDuration
        }
        status = .running
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func pause() {
        status = .paused
        cancellable?.cancel()
        cancellable = nil
    }

    func reset() {
        status = .idle
        cancellable?.cancel()
        cancellable = nil
        phase = .work
        timeRemaining = totalDuration
    }

    // MARK: - Private Helpers

    private func tick() {
        guard timeRemaining > 0 else {
            phaseComplete()
            return
        }
        timeRemaining -= 1
    }

    private func phaseComplete() {
        if soundEnabled {
            SoundService.shared.playCompletionSound()
        }
        if notificationEnabled {
            let title = phase == .work ? "专注完成！" : "休息结束！"
            let body = phase == .work ? "该休息一下了。" : "该继续专注了。"
            NotificationService.shared.sendNotification(title: title, body: body)
        }

        if phase == .work {
            completedPomodoros += 1
            phase = completedPomodoros % longBreakInterval == 0 ? .longBreak : .shortBreak
        } else {
            phase = .work
        }

        timeRemaining = totalDuration
        status = .idle
        cancellable?.cancel()
        cancellable = nil
    }
}
