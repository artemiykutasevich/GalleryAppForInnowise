//
//  AlertRouter.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 7.04.24.
//

import UIKit

// MARK: - AlertRouterProtocol

protocol AlertRouterProtocol {
    func openWarningAlert(of type: AlertType.Warning)
}

// MARK: - AlertRouter

final class AlertRouter {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    private func openAlert(of type: AlertTypeProtocol) {
        let alertController = UIAlertController(title: type.title, message: type.messege, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        window.rootViewController?.present(alertController, animated: true)
    }
}

extension AlertRouter: AlertRouterProtocol {
    func openWarningAlert(of type: AlertType.Warning) {
        openAlert(of: type)
    }
}
