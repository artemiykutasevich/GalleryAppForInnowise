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

final class ImageDetailViewController: BaseViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var blurredImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descritionLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    
    var viewModel: ImageDetailViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentItem = viewModel.currentItem
        titleLabel.text = currentItem.altDescription
        
        let description: String = currentItem.description ?? String()
        descritionLabel.text = description.isEmpty ? "No description" : description
        
        let date: String = currentItem.createdAt.toDate()?.toString() ?? "No Date"
        dataLabel.text = date
        
        guard let url = URL(string: currentItem.urls.regular) else { return }
        imageView.kf.setImage(with: url)
        blurredImageView.kf.setImage(with: url)
    }
}

extension ImageDetailViewController: ImageDetailControllerProtocol {}
