import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        #if os(macOS)
        TimerView(viewModel: viewModel)
            .frame(minWidth: 400, minHeight: 500)
            .onAppear {
                NotificationService.shared.requestAuthorization()
            }
        #else
        NavigationStack {
            TimerView(viewModel: viewModel)
                .onAppear {
                    NotificationService.shared.requestAuthorization()
                }
        }
        #endif
    }
}
