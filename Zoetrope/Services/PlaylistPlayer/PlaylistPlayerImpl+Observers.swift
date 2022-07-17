//
//  PlaylistPlayerImpl+Observers.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 27/03/2021.
//

import Foundation

// MARK: - Observable Helpers

extension PlaylistPlayerImpl {

    func addObserver(_ observer: PlaylistPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = WeakBox(observer)
    }

    func removeObserver(_ observer: PlaylistPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

    internal func notifyLoopModeDidUpdate(newValue: LoopMode) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.loopModeDidUpdate(newValue: newValue)
        }
    }

    internal func notifyPlaybackStateDidChange(to playPauseState: PlayPauseState) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playbackStateDidChange(to: playPauseState)
        }
    }

    internal func notifyPlaybackReadinessDidChange(isReady: Bool) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playbackReadinessDidChange(isReady: isReady)
        }
    }

    internal func notifyPlaybackFastReverseAbilityDidChange(canPlayFastReverse: Bool) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playbackFastReverseAbilityDidChange(canPlayFastReverse: canPlayFastReverse)
        }
    }

    internal func notifyPlaybackFastForwardAbilityDidChange(canPlayFastForward: Bool) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playbackFastForwardAbilityDidChange(canPlayFastForward: canPlayFastForward)
        }
    }

    internal func notifyPlaybackPositionDidChange(to time: MediaTime) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playbackPositionDidChange(to: time)
        }
    }

    internal func notifyPlaybackDurationDidChange(to time: MediaTime) {
        for (id, observation) in observations {
            guard let observer = observation.value else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.playbackDurationDidChange(to: time)
        }
    }
}
