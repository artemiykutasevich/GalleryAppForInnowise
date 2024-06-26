//
//  ImageGalleryViewModel.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import UIKit
import Combine

// MARK: - ImageGalleryViewModelProtocol

protocol ImageGalleryViewModelProtocol {
    var currentPage: Int { get set }
    var isLoading: Bool { get set }
    var pages: Page { get }
    var isLiked: Bool { get set }

    func loadPage(completion success: @escaping (Bool) -> Void)
    func checkIfNeedToLoadNextPage(_ scrollView: UIScrollView, completion success: @escaping (Bool) -> Void)
}

// MARK: - ImageGalleryViewModel

final class ImageGalleryViewModel {
    var currentPage: Int = 0
    var isLoading: Bool = false
    var pages: Page {
        get { isLiked ? likedPages : downloadedPages }
    }

    var isLiked: Bool = false

    var downloadedPages: Page = []

    lazy var coreDataService: CoreDataServiceProtocol = serviceLocator.getService()

    var likedPages: Page {
        get { coreDataService.getFavorites().filter({ $0.isFavorite }) }
    }
}

extension ImageGalleryViewModel: ImageGalleryViewModelProtocol {
    func loadPage(completion success: @escaping (Bool) -> Void) {
        guard !isLoading, !isLiked else { return }
        isLoading = true
        let provider: BaseProviderProtocol = serviceLocator.getService()
        provider.getPage(with: currentPage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPages):
                downloadedPages.append(contentsOf: newPages.toPage())
                currentPage += 1
                success(true)
            case .failure(let failure):
                debugPrint("❌ page downloading error: \(failure.localizedDescription)")
                success(false)
            }
            isLoading = false
        }
    }

    func checkIfNeedToLoadNextPage(_ scrollView: UIScrollView, completion success: @escaping (Bool) -> Void) {
        guard !isLiked else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            // Load next page when user reaches the bottom
            loadPage(completion: success)
        }
    }
}
