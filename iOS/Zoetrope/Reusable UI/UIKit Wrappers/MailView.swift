//
//  MailView.swift
//  Zoetrope
//
//  Created by Andy Brown on 01/08/2022.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    var recipients: [String]? = nil
    var subject: String? = nil
    
    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        if let subject = subject {
            vc.setSubject(subject)
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) { }
    
    // MARK: - Coordinator

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool

        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            
            isShowing = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }
}
