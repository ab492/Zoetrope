//
//  MoviePicker.swift
//  PlaylistPlayer
//
//  Created by Andy Brown on 25/06/2022.
//

import PhotosUI
import SwiftUI

struct CameraRollVideoPicker: UIViewControllerRepresentable {
    
    @Binding var movieURLs: [URL]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        config.selectionLimit = 0
        config.preferredAssetRepresentationMode = .current // Important to prevent transcoding on the fly on import, which is very slow.
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: CameraRollVideoPicker
        
        init(_ parent: CameraRollVideoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            
            for result in results {
                let provider = result.itemProvider
                
                guard provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) else { continue }
                
                provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    guard let url = url else { return }
                    let filename = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                    let newURL = URL(fileURLWithPath: NSTemporaryDirectory() + filename)
                    try? FileManager.default.moveItem(at: url, to: newURL)
                    self.parent.movieURLs.append(newURL)
                }
            }
        }
    }
}

