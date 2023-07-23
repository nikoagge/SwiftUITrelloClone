//
//  View+Extension.swift
//  SwiftUITrelloClone
//
//  Created by Nikos Aggelidis on 20/7/23.
//

import UIKit
import SwiftUI

extension View {
    func presentAlertTextField(
        title: String,
        message: String? = nil,
        defaultText: String? = nil,
        confirmAction: @escaping (String?) -> ()
    ) {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController else { return }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.text = defaultText
        }
        alertController.addAction(.init(
            title: "Cancel",
            style: .cancel
        ))
        alertController.addAction(.init(
            title: "Save",
            style: .default) { _ in
                guard let textField = alertController.textFields?.first else { return }
                confirmAction(textField.text)
            }
        )
        rootViewController.present(
            alertController,
            animated: true
        )
    }
}
