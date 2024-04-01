//
//  UnsplashProvider.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

// MARK: - UnsplashProviderProtocol

protocol UnsplashProviderProtocol {
    func getPage(with number: Int, completion: @escaping (Result<UnsplasPage, InternalError>) -> Void)
}

// MARK: - BaseProvider

extension BaseProvider: UnsplashProviderProtocol {
    func getPage(with number: Int, completion: @escaping (Result<UnsplasPage, InternalError>) -> Void) {
        
        // TODO: fix parametres
        let requestData = RequestData(
            endPoint: "https://api.unsplash.com/photos?client_id=\(Constants.Unsplash.accessKey)&page=\(number)&per_page\(Constants.Unsplash.itemsPerPage)",
            httpMethod: .get,
            parametres: [
                "client_id": Constants.Unsplash.accessKey,
                "page": number,
                "per_page": Constants.Unsplash.itemsPerPage
            ],
            headers: [
                "Accept-Version": "v1"
            ]
        )
        webService.perform(requestData: requestData, completion: completion)
    }
}
