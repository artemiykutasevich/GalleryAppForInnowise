//
//  ImageDetailViewController.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 31.03.24.
//

import UIKit

// MARK: - ImageDetailControllerProtocol

protocol ImageDetailControllerProtocol {}

// MARK: - ImageDetailViewController

final class ImageDetailViewController: BaseViewController, ImageDetailControllerProtocol {

    // @IBOutlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var blurredImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descritionLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var likeButton: LikeButton!

    // Properties

    var viewModel: ImageDetailViewModelProtocol!

    // override

    override func viewDidLoad() {
        super.viewDidLoad()
        configureOutlets()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("👀 Image Detail Screen")
    }

    // Functions

    private func configureOutlets() {
        let currentItem = viewModel.currentItem
        likeButton.configure(isLiked: currentItem.isFavorite)
        likeButton.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        titleLabel.text = currentItem.post.title
        let description: String = currentItem.post.description ?? String()
        descritionLabel.text = description.isEmpty ? "No description" : description
        dataLabel.text = currentItem.createAt.toString()
        guard let url = URL(string: currentItem.urls.regular) else { return }
        imageView.kf.setImage(with: url)
        blurredImageView.kf.setImage(with: url)
    }

    // @objc Functions

    @objc private func likeButtonAction() {
        TapticEngine.select()
        viewModel.currentItem.isFavorite.toggle()
        likeButton.configure(isLiked: viewModel.currentItem.isFavorite)
        let coreDataService: CoreDataServiceProtocol = serviceLocator.getService()
        if viewModel.currentItem.isFavorite {
            coreDataService.addFavorite(item: viewModel.currentItem)
        } else {
            coreDataService.removeFavorite(item: viewModel.currentItem)
        }
    }
}
