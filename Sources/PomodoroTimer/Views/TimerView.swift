import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.phase.label)
                .font(.title2)
                .foregroundColor(.secondary)

            ZStack {
                CircularProgressView(progress: viewModel.progress, phase: viewModel.phase)

                Text(viewModel.formattedTime)
                    .font(.system(size: 56, weight: .bold, design: .monospaced))
            }
            .frame(maxWidth: 280, maxHeight: 280)

            HStack(spacing: 30) {
                Button(action: viewModel.reset) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .frame(width: 50, height: 50)
                }
                .disabled(viewModel.status == .idle)
                .opacity(viewModel.status == .idle ? 0.4 : 1)

                Button(action: {
                    if viewModel.status == .running {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Image(systemName: viewModel.status == .running ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                        .frame(width: 70, height: 70)
                        .background(buttonColor.opacity(0.2))
                        .clipShape(Circle())
                }

                Color.clear
                    .frame(width: 50, height: 50)
            }

            VStack(spacing: 4) {
                Text("完成番茄: \(viewModel.completedPomodoros)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    ForEach(0..<max(viewModel.longBreakInterval, 1), id: \.self) { i in
                        Circle()
                            .fill(i < viewModel.completedPomodoros % max(viewModel.longBreakInterval, 1)
                                ? Color.orange : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: viewModel)
        }
    }

    private var buttonColor: Color {
        switch viewModel.status {
        case .running: return .red
        default: return .orange
        }
    }
}
