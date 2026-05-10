import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let phase: TimerPhase

    private var strokeColor: Color {
        switch phase {
        case .work: return .orange
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(strokeColor.opacity(0.2), lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.2), value: progress)
        }
        .padding(20)
    }
}

#Preview {
    CircularProgressView(progress: 0.35, phase: .work)
        .frame(width: 200, height: 200)
}
