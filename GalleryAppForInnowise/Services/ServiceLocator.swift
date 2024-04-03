//
//  ServiceLocator.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 3.04.24.
//

import Foundation

// MARK: - ServiceLocator

protocol ServiceLocator {
    func getService<T>() -> T
    func getService<T>(_: T.Type) -> T?
}

// MARK: - LazyServiceLocator

final class LazyServiceLocator: ServiceLocator {

    enum RegistryRecord {
        case instance(Any)
        case recipe(() -> Any)
    }

    fileprivate lazy var registry: [String: RegistryRecord] = [:]

    func addService<T>(_ recipe: @escaping () -> T) {
        let key = getTypeName(T.self)
        registry[key] = .recipe(recipe)
        debugPrint("✅ ServiceLocator: did register \(T.self)")
    }

    func addService<T>(_ instance: T) {
        let key = getTypeName(T.self)
        registry[key] = .instance(instance)
    }

    func getService<T>(_: T.Type) -> T? {
        let instanceToFind: T?
        if let registryRec = registry[getTypeName(T.self)] {
            switch registryRec {
            case .instance(let newInstance):
                instanceToFind = newInstance as? T
            case .recipe(let recipe):
                instanceToFind = recipe() as? T
                if let instance = instanceToFind {
                    addService(instance)
                }
            }
        } else {
            instanceToFind = nil
            debugPrint("❌ ServiceLocator: \(T.self) not register")
        }
        return instanceToFind
    }

    func getService<T>() -> T {
        return getService(T.self)!
    }

    private func getTypeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
}
