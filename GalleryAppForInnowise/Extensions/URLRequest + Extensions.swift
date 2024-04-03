//
//  URLRequest + Extensions.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

import Foundation

extension URLRequest {
    static func createRequest(from requestData: RequestData) -> URLRequest? {
        var urlPath: String = requestData.endPoint
        if !requestData.parametres.isEmpty {
            urlPath += "?"
            requestData.parametres.enumerated().forEach({
                if $0.offset > 0 {
                    urlPath += "&"
                }
                urlPath += $0.element.key + "=" + String(describing: $0.element.value)
            })
        }
        guard let url = URL(string: urlPath) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestData.httpMethod.name
        request.allHTTPHeaderFields = requestData.headers
        return request
    }
}
