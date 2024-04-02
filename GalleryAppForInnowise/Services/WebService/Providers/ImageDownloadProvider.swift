//
//  ImageDownloadProvider.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 2.04.24.
//

import UIKit

// MARK: - ImageDownloadProviderProtocol

protocol ImageDownloadProviderProtocol {
    func downloadImage(fromURL url: String, completion: @escaping (Result<UIImage, InternalError>) -> Void)
}

// MARK: - BaseProvider

extension BaseProvider: ImageDownloadProviderProtocol {
    func downloadImage(fromURL url: String, completion: @escaping (Result<UIImage, InternalError>) -> Void) {
        let requestData = RequestData(endPoint: url)
        webService.perform(requestData: requestData, completion: completion)
    }
}
