//
//  ImageGalleryViewModel.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import Foundation
import Combine

// MARK: - ImageGalleryViewModelProtocol

protocol ImageGalleryViewModelProtocol {
    var pages: UnsplasPage { get set }
    
    func loadPage(with number: Int, completion success: @escaping (Bool) -> Void)
}

// MARK: - ImageGalleryViewModel

final class ImageGalleryViewModel {
    weak var view: ImageGalleryViewControllerProtocol?
    
    var pages: UnsplasPage = []
}

extension ImageGalleryViewModel: ImageGalleryViewModelProtocol {
    func loadPage(with number: Int, completion success: @escaping (Bool) -> Void) {
        let provider: BaseProviderProtocol = serviceLocator.getService()
        provider.getPage(with: number) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPages):
                pages += newPages
                success(true)
            case .failure(let failure):
                debugPrint("❌ page downloading")
                success(false)
            }
        }
    }
}
