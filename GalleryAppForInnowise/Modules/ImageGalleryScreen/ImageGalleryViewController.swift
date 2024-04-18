//
//  ImageGalleryViewController.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - ImageGalleryViewControllerProtocol

protocol ImageGalleryViewControllerProtocol: AnyObject {}

// MARK: - ImageGalleryViewController

final class ImageGalleryViewController: BaseViewController, ImageGalleryViewControllerProtocol {

    // @IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var likeButton: LikeButton!

    // Properties

    private lazy var collectionViewLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.numberOfColumns = Defaults.CollectionView.numberOfColumns
        layout.cellPadding = Defaults.CollectionView.cellPading
        layout.delegate = self
        return layout
    }()

    var viewModel: ImageGalleryViewModelProtocol!
    private let disposeBag = DisposeBag()

    // override

    override func viewDidLoad() {
        super.viewDidLoad()
        configureOutlets()
        configureCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("👀 Image Gallery Screen")
    }

    // Functions

    private func configureOutlets() {
        likeButton.isHidden = true
//        likeButton.configure(isLiked: viewModel.isLiked)
//        likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(ImageGalleryCell.self)

        viewModel.pages
            .bind(to: collectionView.rx.items(
                cellIdentifier: ImageGalleryCell.defaultReuseIdentifier,
                cellType: ImageGalleryCell.self)
            ) {_, _, _ in }
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] cell, indexPath in
                guard let self, let cell = cell as? ImageGalleryCell else { return }
                cell.configure(with: viewModel.pages.value[indexPath.item])
            }
            .disposed(by: disposeBag)
    }

    private func calculateCellWidth() -> CGFloat {
        let leftInsert: CGFloat = Defaults.CollectionView.insertForSections.left
        let rightInsert: CGFloat = Defaults.CollectionView.insertForSections.right
        let numberOfColumns: Int = collectionViewLayout.numberOfColumns
        let cellPadding: CGFloat = collectionViewLayout.cellPadding
        let spaceWithoutInserts: CGFloat = collectionView.frame.width - leftInsert - rightInsert
        let spaceWithoutPaddings = (numberOfColumns - 1).toCGFloat() * cellPadding
        let cellFreeWidth = spaceWithoutInserts - spaceWithoutPaddings
        let cellWidth = cellFreeWidth / numberOfColumns.toCGFloat()
        return cellWidth
    }

    // @objc Functions

//    @objc private func likeButtonAction() {
//        TapticEngine.select()
//        viewModel.isLiked.toggle()
//        likeButton.configure(isLiked: viewModel.isLiked)
//        collectionView.reloadData()
//    }
}

// MARK: - Collection View

extension ImageGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticEngine.select()
        let pageItem = viewModel.pages.value[indexPath.item]
        let mainRouter: MainRouterProtocol = serviceLocator.getService()
        mainRouter.showImageDetailScreen(with: pageItem)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.checkIfNeedToLoadNextPage(scrollView)
    }
}

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Defaults.CollectionView.insertForSections
    }
}

// MARK: - PinterestLayoutDelegate

extension ImageGalleryViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(collectionView: UICollectionView, sizeForSectionFooterViewForSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let item = viewModel.pages.value[indexPath.item]
        let imageAspect: CGFloat = item.size.height / item.size.width
        let cellWidth: CGFloat = calculateCellWidth()
        return cellWidth * imageAspect
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return .zero
    }
}

// MARK: - Defaults

fileprivate extension ImageGalleryViewController {
    enum Defaults {
        enum CollectionView {
            static let numberOfColumns: Int = 2
            static let cellPading: CGFloat = 10.0
            static let insertForSections: UIEdgeInsets = UIEdgeInsets(top: cellPading, left: cellPading, bottom: cellPading, right: cellPading)
        }
    }
}
