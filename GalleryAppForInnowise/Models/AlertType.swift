//
//  AlertTypes.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 7.04.24.
//

import Foundation

// MARK: - AlertTypeProtocol

protocol AlertTypeProtocol {
    var title: String { get }
    var messege: String { get }
}

// MARK: - AlertType

enum AlertType {
    enum Warning: AlertTypeProtocol {
        case pageLoading
        case unknown

        var title: String {
            switch self {
            case .pageLoading:
                return "⚠️ Can't load page"
            case .unknown:
                return "⚠️ Ooops"
            }
        }

        var messege: String {
            switch self {
            case .pageLoading:
                return "Check internet connection and try again"
            case .unknown:
                return "Something went wrong"
            }
        }
    }
}
