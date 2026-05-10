import XCTest
@testable import PomodoroTimer

final class TimerViewModelTests: XCTestCase {
    var viewModel: TimerViewModel!

    override func setUp() {
        super.setUp()
        viewModel = TimerViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.status, .idle)
        XCTAssertEqual(viewModel.timeRemaining, 25 * 60)
        XCTAssertEqual(viewModel.completedPomodoros, 0)
    }

    func testStartTransitionsToRunning() {
        viewModel.start()
        XCTAssertEqual(viewModel.status, .running)
    }

    func testPauseTransitionsToPaused() {
        viewModel.start()
        viewModel.pause()
        XCTAssertEqual(viewModel.status, .paused)
    }

    func testResetReturnsToIdle() {
        viewModel.start()
        viewModel.reset()
        XCTAssertEqual(viewModel.status, .idle)
        XCTAssertEqual(viewModel.phase, .work)
    }

    func testFormattedTimeFormat() {
        viewModel.timeRemaining = 1500
        XCTAssertEqual(viewModel.formattedTime, "25:00")
    }

    func testFormattedTimeWithMinutesAndSeconds() {
        viewModel.timeRemaining = 61
        XCTAssertEqual(viewModel.formattedTime, "01:01")
    }

    func testTotalDurationMatchesWorkDuration() {
        viewModel.workDuration = 30
        viewModel.phase = .work
        XCTAssertEqual(viewModel.totalDuration, 30 * 60)
    }

    func testProgressCalculation() {
        viewModel.phase = .work
        viewModel.workDuration = 10
        viewModel.timeRemaining = 5 * 60
        XCTAssertEqual(viewModel.progress, 0.5, accuracy: 0.01)
    }

    func testMultipleStartDoesNotResetTimer() {
        viewModel.start()
        let timeBefore = viewModel.timeRemaining
        viewModel.start()
        XCTAssertEqual(viewModel.timeRemaining, timeBefore)
    }

    func testTimerCountsDown() {
        let expectation = XCTestExpectation(description: "Timer counts down")
        viewModel.start()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertLessThan(self.viewModel.timeRemaining, 25 * 60)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    func testPhaseTransitionsAfterWorkComplete() {
        viewModel.soundEnabled = false
        viewModel.notificationEnabled = false
        viewModel.workDuration = 1

        viewModel.start()
        viewModel.pause()
        viewModel.timeRemaining = 1
        viewModel.start()

        let expectation = XCTestExpectation(description: "Phase transitions to break")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.completedPomodoros, 1)
            XCTAssertEqual(self.viewModel.phase, .shortBreak)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }
}
