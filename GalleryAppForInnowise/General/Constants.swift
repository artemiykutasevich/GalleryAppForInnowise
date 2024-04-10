//
//  Constants.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import Foundation

final class Constants {
    enum Unsplash {
        static let accessKey: String = InfoPlistWrappers.unsplashAccessKey
        static let itemsPerPage: Int = 30
    }
}

typealias RequestAnswer = (data: Data?, response: URLResponse?, error: (any Error)?)
typealias RequestParametres = [String: Any]
typealias RequestHeaders = [String: String]
