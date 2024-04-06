//
//  Page.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 7.04.24.
//

import Foundation

typealias Page = [PageItem]

struct PageItem {
    let id: String
    let isFavorite: Bool
    let createAt: Date
    let size: CGSize
    let post: PageItemPost
    let urls: PageItemURL
}

struct PageItemPost {
    let title: String
    let description: String?
}

struct PageItemURL {
    let small: String
    let regular: String
}
