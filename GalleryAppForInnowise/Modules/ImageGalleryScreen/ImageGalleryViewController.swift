//
//  ImageGalleryViewController.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import UIKit

// MARK: - ImageGalleryViewControllerProtocol

protocol ImageGalleryViewControllerProtocol: AnyObject {}

// MARK: - ImageGalleryViewController

final class ImageGalleryViewController: BaseViewController, ImageGalleryViewControllerProtocol {

    // @IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // Properties

    private lazy var collectionViewLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.numberOfColumns = Defaults.CollectionView.numberOfColumns
        layout.cellPadding = Defaults.CollectionView.cellPading
        layout.delegate = self
        return layout
    }()

    var viewModel: ImageGalleryViewModelProtocol!

    // override

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPage { [weak self] success in
            guard let self else { return }
            pageLoadingHandler(success: success)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("👀 Image Gallery Screen")
    }

    // Functions

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(ImageGalleryCell.self)
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

    private func pageLoadingHandler(success: Bool) {
        if success {
            collectionView.reloadData()
        } else {
            // TODO: ADD warning alert
        }
    }
}

// MARK: - Collection View

extension ImageGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pages.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.pages[indexPath.row]
        let cell: ImageGalleryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: item)
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageItem = viewModel.pages[indexPath.item]
        let mainRouter: MainRouterProtocol = serviceLocator.getService()
        mainRouter.showImageDetailScreen(with: pageItem)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.checkIfNeedToLoadNextPage(scrollView) { [weak self] success in
            guard let self else { return }
            pageLoadingHandler(success: success)
        }
    }
}

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    // swiftlint:disable:next line_length
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

    // swiftlint:disable:next line_length
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let item = viewModel.pages[indexPath.item]
        let imageAspect: CGFloat = item.size.height / item.size.width
        let cellWidth: CGFloat = calculateCellWidth()
        return cellWidth * imageAspect
    }

    // swiftlint:disable:next line_length
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
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
