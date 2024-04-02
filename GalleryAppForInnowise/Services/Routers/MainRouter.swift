//
//  MainRouter.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 3.04.24.
//

import UIKit

// MARK: - MainRouterProtocol

protocol MainRouterProtocol {
    func showImageGalleryScreen()
}

// MARK: - MainRouter

final class MainRouter {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}

extension MainRouter: MainRouterProtocol {
    func showImageGalleryScreen() {
        let imageGalleryScreen = ImageGalleryModuleConfigurator.instantiateModule()
        window.rootViewController = imageGalleryScreen
        UIWindow.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: nil)
    }
}
