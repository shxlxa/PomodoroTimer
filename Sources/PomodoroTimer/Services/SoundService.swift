import AudioToolbox

final class SoundService {
    static let shared = SoundService()

    private init() {}

    func playCompletionSound() {
        AudioServicesPlaySystemSound(1005)
    }
}
