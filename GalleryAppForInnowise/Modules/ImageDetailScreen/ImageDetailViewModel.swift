//
//  ImageDetailViewModel.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import Foundation

// MARK: - ImageDetailViewModelProtocol

protocol ImageDetailViewModelProtocol {
    var currentItem: UnsplashPageItem { get set }
}

// MARK: - ImageDetailViewModel

final class ImageDetailViewModel: ImageDetailViewModelProtocol {
    var currentItem: UnsplashPageItem

    init(currentItem: UnsplashPageItem) {
        self.currentItem = currentItem
    }
}
