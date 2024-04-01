//
//  BaseProvider.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

// MARK: - BaseProviderProtocol

protocol BaseProviderProtocol: UnsplashProviderProtocol {}

// MARK: - BaseProvider

final class BaseProvider: BaseProviderProtocol {
    lazy var webService: WebServiceProtocol = WebService()
}
