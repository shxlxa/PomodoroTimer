import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("时长设置") {
                    VStack(alignment: .leading) {
                        Text("工作时间: \(Int(viewModel.workDuration)) 分钟")
                        Slider(value: $viewModel.workDuration, in: 1...120, step: 1)
                    }

                    VStack(alignment: .leading) {
                        Text("短休息: \(Int(viewModel.shortBreakDuration)) 分钟")
                        Slider(value: $viewModel.shortBreakDuration, in: 1...60, step: 1)
                    }

                    VStack(alignment: .leading) {
                        Text("长休息: \(Int(viewModel.longBreakDuration)) 分钟")
                        Slider(value: $viewModel.longBreakDuration, in: 1...60, step: 1)
                    }

                    Stepper("长休息间隔: 每 \(viewModel.longBreakInterval) 个番茄",
                            value: $viewModel.longBreakInterval, in: 2...10)
                }

                Section("通知") {
                    Toggle("提示音", isOn: $viewModel.soundEnabled)
                    Toggle("系统通知", isOn: $viewModel.notificationEnabled)
                }

                Section {
                    Button("请求通知权限") {
                        NotificationService.shared.requestAuthorization()
                    }
                }
            }
            .navigationTitle("设置")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
