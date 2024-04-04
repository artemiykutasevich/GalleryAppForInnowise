//
//  ImageGalleryCell.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 3.04.24.
//

import UIKit
import Kingfisher

// MARK: -  ImageGalleryCell

class ImageGalleryCell: BaseCollectionViewCell {

    // @IBOutlets

    @IBOutlet private weak var imageView: UIImageView!

    // override

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }

    // Functions

    func configure(with model: UnsplashPageItem) {
        let url = URL(string: model.urls.small)
        imageView.kf.setImage(with: url)
    }
    
    private func configureUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10 * ScaleFactor.scaleCoffee
        self.layer.cornerCurve = .continuous
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemFill.cgColor
    }
}
