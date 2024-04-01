//
//  InternalError.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

enum InternalError: Error {
    case unknown
    case incorectURL
    case incorectRequest
    case incorectJSON
    case incorectResponse
    case notAuthorizedException
    case noInternetConnection
    case emptyData
    case serverError
}
