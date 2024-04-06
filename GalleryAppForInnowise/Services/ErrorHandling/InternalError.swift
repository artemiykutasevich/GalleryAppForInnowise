//
//  InternalError.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

import Foundation

enum InternalError: LocalizedError {
    case unknown
    case incorectURL
    case incorectRequest
    case incorectJSON
    case incorectResponse
    case incorectData
    case notAuthorizedException
    case noInternetConnection
    case emptyData
    case serverError
    case clientError
    
    var errorDescription: String? {
        switch self {
        default:
            return String(describing: self)
        }
    }
}
