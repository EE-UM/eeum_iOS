import Foundation
import AVFoundation
import Combine

public final class AudioPlayerService: ObservableObject {
    public static let shared = AudioPlayerService()

    @Published public private(set) var isPlaying: Bool = false
    @Published public private(set) var currentURL: String?

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    public func play(url: String) {
        guard let audioURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        if currentURL == url && isPlaying {
            pause()
            return
        }

        if currentURL == url && !isPlaying {
            resume()
            return
        }

        stop()

        playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .sink { [weak self] _ in
                self?.handlePlaybackEnded()
            }
            .store(in: &cancellables)

        currentURL = url
        player?.play()
        isPlaying = true
    }

    public func pause() {
        player?.pause()
        isPlaying = false
    }

    public func resume() {
        player?.play()
        isPlaying = true
    }

    public func stop() {
        player?.pause()
        player = nil
        playerItem = nil
        currentURL = nil
        isPlaying = false
        cancellables.removeAll()
    }

    public func toggle(url: String) {
        if currentURL == url {
            if isPlaying {
                pause()
            } else {
                resume()
            }
        } else {
            play(url: url)
        }
    }

    public func isCurrentlyPlaying(url: String) -> Bool {
        return currentURL == url && isPlaying
    }

    private func handlePlaybackEnded() {
        isPlaying = false
    }
}
