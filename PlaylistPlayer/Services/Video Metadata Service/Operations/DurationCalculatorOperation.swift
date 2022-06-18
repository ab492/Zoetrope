////
////  DurationCalculatorOperation.swift
////  PlaylistPlayer
////
////  Created by Andy Brown on 24/02/2021.
////
//
//import Foundation
//
//final class DurationCalculatorOperation: Operation {
//
//    private let durationCalculator = DurationCalculatorImpl()
//
//    private var outputTime: Time?
//    private let inputUrl: URL?
//
//    /// This callback will be run **on the main thread** when the operation completes.
//    var onComplete: ((Time) -> Void)?
//
//    init(url: URL? = nil) {
//        self.inputUrl = url
//        super.init()
//    }
//
//    override func main() {
//        let dependencyURL = dependencies
//            .compactMap { ($0 as? URLProvider)?.url }
//            .first
//
//        guard let inputURL = inputUrl ?? dependencyURL else {
//            print("No url :(")
//            return
//        }
//
//        let time = durationCalculator.durationForAsset(at: inputURL)
//        outputTime = time
//
//        if let onComplete = onComplete {
//            DispatchQueue.main.async {
//                onComplete(time)
//            }
//        }
//    }
//}
