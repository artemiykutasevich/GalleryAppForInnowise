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

final class ImageGalleryViewController: UIViewController {

    var viewModel: ImageGalleryViewModelProtocol?

    let welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcom to Image Gallery Screen"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayout()
    }

    fileprivate func configureLayout() {
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomLabel)
        NSLayoutConstraint.activate([
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ImageGalleryViewController: ImageGalleryViewControllerProtocol {}
