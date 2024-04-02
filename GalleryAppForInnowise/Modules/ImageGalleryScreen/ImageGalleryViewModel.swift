//
//  ImageGalleryViewModel.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import Foundation

// MARK: - ImageGalleryViewModelProtocol

protocol ImageGalleryViewModelProtocol {}

// MARK: - ImageGalleryViewModel

final class ImageGalleryViewModel {
    weak var view: ImageGalleryViewControllerProtocol?
}

extension ImageGalleryViewModel: ImageGalleryViewModelProtocol {}
