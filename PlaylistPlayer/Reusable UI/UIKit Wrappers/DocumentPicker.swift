//
//  DocumentPicker.swift
//  Quickfire
//
//  Created by Andy Brown on 01/11/2020.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {

    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    @Binding var urls: [URL]

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie])
        pickerViewController.allowsMultipleSelection = true
        pickerViewController.delegate = context.coordinator

        return pickerViewController
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) { }
    
    // MARK: - Coordinator

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.urls = urls
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
