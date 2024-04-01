//
//  Constants.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import Foundation

final class Constants {
    enum Unsplash {
        static let applicationID: Int = PrivateConstants.Unsplash.applicationID
        static let accessKey: String = PrivateConstants.Unsplash.accessKey
        static let secretKey: String = PrivateConstants.Unsplash.secretKey
        static let itemsPerPage: Int = 30
    }
}
