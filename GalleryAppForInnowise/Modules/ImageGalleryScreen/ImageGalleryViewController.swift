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

    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var collectionViewLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.numberOfColumns = Defaults.CollectionView.numberOfColumns
        layout.cellPadding = Defaults.CollectionView.cellPading
        layout.delegate = self
        return layout
    }()

    var viewModel: ImageGalleryViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPage(with: 0) { [weak self] success in
            guard let self, success else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("👀 Image Gallery Screen")
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(ImageGalleryCell.self)
    }

    private func calculateCellWidth() -> CGFloat {
        let spaceWithoutInserts = collectionView.frame.width - 10.0 - 10.0
        let spaceWithoutPaddings = (Defaults.CollectionView.numberOfColumns - 1).toCGFloat() * Defaults.CollectionView.cellPading
        let cellFreeWidth = spaceWithoutInserts - spaceWithoutPaddings
        let cellWidth = cellFreeWidth / Defaults.CollectionView.numberOfColumns.toCGFloat()
        return cellWidth
    }
}

// MARK: - Collection View

extension ImageGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pages.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: UnsplashPageItem = viewModel.pages[indexPath.row]
        let cell: ImageGalleryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: item)
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate {}

// MARK: - PinterestLayoutDelegate

extension ImageGalleryViewController: PinterestLayoutDelegate {
    // swiftlint:disable:next line_length
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let item = viewModel.pages[indexPath.item]
        let imageAspect: CGFloat = item.height.toCGFloat() / item.width.toCGFloat()
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
        }
    }
}
