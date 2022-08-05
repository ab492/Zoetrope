//
//  ThumbnailGenerator.swift
//  Quickfire
//
//  Created by Andy Brown on 24/11/2020.
//
import UIKit
import AVFoundation
import ImageIO

protocol ThumbnailGenerator {
    func thumbnail(for url: URL) -> UIImage?
}

final class ThumbnailGeneratorImpl: ThumbnailGenerator {

    func thumbnail(for url: URL) -> UIImage? {

        guard let uiImage = generateThumbnail(for: url) else { return nil }

        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 400] as CFDictionary

        guard let imageData = uiImage.pngData(),
              let imageSource = CGImageSourceCreateWithData(imageData as NSData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
        else {
            return nil
        }

        return UIImage(cgImage: image)
    }

    private func generateThumbnail(for url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
