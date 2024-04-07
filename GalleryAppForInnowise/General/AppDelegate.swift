//
//  AppDelegate.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 30.03.24.
//

import UIKit

var serviceLocator: LazyServiceLocator!

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // swiftlint: disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupServices()
        setupRootViewController()
        return true
    }

    fileprivate func setupServices() {
        let registry = LazyServiceLocator()
        serviceLocator = registry
        guard let window = window else { return }
        registry.addService({ MainRouter(window: window) as MainRouterProtocol })
        registry.addService({ WebService() as WebServiceProtocol })
        registry.addService({ BaseProvider() as BaseProviderProtocol })
        registry.addService({ CoreDataService() as CoreDataServiceProtocol })
    }

    fileprivate func setupRootViewController() {
        let mainRouter: MainRouterProtocol = serviceLocator.getService()
        DispatchQueue.main.async {
            mainRouter.showImageGalleryScreen()
        }
    }
}
