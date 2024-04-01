//
//  URLRequest + Extensions.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

import Foundation

extension URLRequest {
    static func createRequest(from requestData: RequestData) -> URLRequest? {
        guard let url = URL(string: requestData.endPoint) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestData.httpMethod.name
        request.allHTTPHeaderFields = requestData.headers
        requestData.parametres.forEach({
            request.setValue($0.key, forHTTPHeaderField: String(describing: $0.value))
        })
        return request
    }
}
