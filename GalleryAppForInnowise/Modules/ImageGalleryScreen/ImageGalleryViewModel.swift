//
//  ImageGalleryViewModel.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import UIKit
import RxSwift
import RxRelay

// MARK: - ImageGalleryViewModelProtocol

protocol ImageGalleryViewModelProtocol {
    var currentPage: BehaviorRelay<Int> { get }
    var pages: BehaviorRelay<[PageItem]> { get }
    var scrollEnded: BehaviorRelay<Void> { get }

    func checkIfNeedToLoadNextPage(_ scrollView: UIScrollView)
}

// MARK: - ImageGalleryViewModel

final class ImageGalleryViewModel {
    var currentPage: BehaviorRelay = BehaviorRelay(value: 0)
    var pages: BehaviorRelay<[PageItem]> = BehaviorRelay(value: [])
    var scrollEnded: BehaviorRelay<Void> = BehaviorRelay(value: ())

    private let disposeBag = DisposeBag()
    private let baseProvider: BaseProviderProtocol = serviceLocator.getService()

    init() {
        loadPage(currentPage.value)
        bindScroolEnded()
    }
}

extension ImageGalleryViewModel: ImageGalleryViewModelProtocol {
    func loadPage(_ pageNumber: Int) {
        baseProvider.getPage(with: pageNumber) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPages):
                debugPrint("✅ page downloading success")
                pages.accept(pages.value + newPages.toPage())
            case .failure(let failure):
                debugPrint("❌ page downloading error: \(failure.localizedDescription)")
            }
        }
    }

    func bindScroolEnded() {
        scrollEnded
            .subscribe { [weak self] _ in
                guard let self else { return }
                let newPageNumber = currentPage.value + 1
                currentPage.accept(newPageNumber)
                loadPage(newPageNumber)
            }
            .disposed(by: disposeBag)
    }

    func checkIfNeedToLoadNextPage(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            let newPageNumber = currentPage.value + 1
            currentPage.accept(newPageNumber)
            loadPage(newPageNumber)
        }
    }
}
