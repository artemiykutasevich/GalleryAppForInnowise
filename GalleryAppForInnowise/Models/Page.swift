//
//  Page.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 7.04.24.
//

import Foundation

// MARK: - Page

/// typealias of `[PageItem]`
typealias Page = [PageItem]

// MARK: - PageItem

class PageItem {
    let id: String
    var isFavorite: Bool
    let createAt: Date
    let size: CGSize
    let post: PageItemPost
    let urls: PageItemURL

    init(id: String, isFavorite: Bool, createAt: Date, size: CGSize, post: PageItemPost, urls: PageItemURL) {
        self.id = id
        self.isFavorite = isFavorite
        self.createAt = createAt
        self.size = size
        self.post = post
        self.urls = urls
    }
}

// MARK: - PageItemPost

class PageItemPost {
    let title: String
    let description: String?

    init(title: String, description: String?) {
        self.title = title
        self.description = description
    }
}

// MARK: - PageItemURL

class PageItemURL {
    let small: String
    let regular: String

    init(small: String, regular: String) {
        self.small = small
        self.regular = regular
    }
}
