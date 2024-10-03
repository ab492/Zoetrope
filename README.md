<p align="center">
  <img src="assets/Zoetrope.png" alt="Zoetrope" width="200" />
</p>

# Zoetrope: Video Player for iPad
> **Note:**  
> *This project, though no longer supported on the App Store, was a fun learning experience that I want to showcase.”*

I built Zoetrope for iPad using SwiftUI and AVFoundation. It allows users to create playlists of videos, reorder them, loop them, and navigate them frame by frame. I started working on it in 2021, so some of the SwiftUI code may contain workarounds for features not available in earlier versions.

Here are a few key files that demonstrate my approach and style:

- `WrappedAVPlayer` provides a more user-friendly interface for working with Apple’s `AVPlayer` and allows easy mocking and custom control of the video player.
- `VideoQueuePlayer` is a custom queue player built on top of `WrappedAVPlayer` enabling additional playback behaviours like skipping between content and looping items.
- `VideoQueuePlayerTests` showcases my testing approach, particularly for core application functionality. Although the dependency on AVPlayerItem in the tests could be improved, it doesn't impact the confidence I have in the tests.
- `PlaylistDetailView` and `PlaylistDetailViewModel` demonstrate how I separate view and logic, with corresponding tests in `PlaylistDetailViewModelTests`.

### Fastlane Notes

1. Install  bundler:`sudo gem install bundler`. Bundler is a Ruby tool that manages Ruby packages, known as gems.

2. Run `bundle update` which will download any gems declared in the Gemfile.

Note: When using Fastlane commands, adding `bundle exec` beforehand means that you’ll get the exact version of a gem that you specified in your Gemfile, instead of a different version installed elsewhere on your computer.

### Support

Here are the old support pages:
[Project Repository](https://github.com/ab492/ZoetropePages)
[Support Page](https://ab492.github.io/ZoetropePages)