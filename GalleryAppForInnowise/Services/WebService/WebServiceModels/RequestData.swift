//
//  RequestData.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

import Foundation

struct RequestData {
    let endPoint: String
    let httpMethod: HTTPMEthod
    let parametres: RequestParametres
    let headers: RequestHeaders
    
    init(endPoint: String, httpMethod: HTTPMEthod = .get, parametres: RequestParametres = [:], headers: RequestHeaders = [:]) {
        self.endPoint = endPoint
        self.httpMethod = httpMethod
        self.parametres = parametres
        self.headers = headers
    }
}

enum HTTPMEthod {
    case get

    var name: String {
        return String(describing: self).uppercased()
    }
}

typealias RequestParametres = [String: Any]
typealias RequestHeaders = [String: String]
