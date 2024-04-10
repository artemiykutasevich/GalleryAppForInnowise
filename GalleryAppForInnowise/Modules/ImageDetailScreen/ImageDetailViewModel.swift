//
//  ImageDetailViewModel.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import Foundation

// MARK: - ImageDetailViewModelProtocol

protocol ImageDetailViewModelProtocol {
    var currentItem: PageItem { get set }
}

// MARK: - ImageDetailViewModel

final class ImageDetailViewModel: ImageDetailViewModelProtocol {
    var currentItem: PageItem

    init(currentItem: PageItem) {
        let service: CoreDataServiceProtocol = serviceLocator.getService()
        if service.isFavorite(item: currentItem) {
            currentItem.isFavorite = true
        }
        self.currentItem = currentItem
    }
}
