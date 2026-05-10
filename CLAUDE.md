# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test

```bash
# Build
swift build

# Run (macOS)
swift run

# Run all tests
swift test

# Run specific test
swift test --filter TimerViewModelTests/testInitialState

# Build for iOS
xcodebuild -scheme PomodoroTimer -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests via xcodebuild
xcodebuild -scheme PomodoroTimer -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Architecture

MVVM with SwiftUI, targeting iOS 17+ and macOS 14+.

- **App entry**: `Sources/PomodoroTimer/PomodoroApp.swift` — `@main` struct, cross-platform WindowGroup
- **ViewModels**: `TimerViewModel` — single ObservableObject driving all views, uses Combine `Timer.publish` for countdown, `@AppStorage` for settings persistence
- **Views**: `TimerView` (main timer + controls), `SettingsView` (form for durations/toggles), `CircularProgressView` (reusable progress ring)
- **Models**: `TimerPhase` (work/shortBreak/longBreak), `TimerStatus` (idle/running/paused), `SettingsKey` for UserDefaults keys
- **Services**: `SoundService` (singleton, uses AudioServicesPlaySystemSound), `NotificationService` (singleton, UNUserNotificationCenter wrapper, disables on macOS when not in app bundle)

## Git Commit Convention

Use Conventional Commits:

- `feat:` — 新功能
- `fix:` — Bug 修复
- `chore:` — 杂务（配置文件、gitignore 等）
- `test:` — 测试相关
- `refactor:` — 重构
- `docs:` — 文档

格式：`type: 简短描述`，正文可补充细节。

## Slash Commands

- `/git` — 执行完整提交流程：stage 所有改动、review diff、生成 Conventional Commits 格式的提交信息并推送到 GitHub

## Key Patterns

- No external dependencies — pure SwiftUI + Combine + Foundation
- Settings persisted via `@AppStorage` / UserDefaults
- TimerViewModel uses `@Published` properties; views use `@ObservedObject`
- Phase transitions: work → shortBreak (or longBreak every N intervals) → work
- `SoundService.shared.playCompletionSound()` uses system sound ID 1005
- `NotificationService` uses `Bundle.main.bundleIdentifier` check to detect macOS app bundle vs CLI context
