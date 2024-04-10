//
//  LikeButton.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 7.04.24.
//

import UIKit

// MARK: - LikeButton

final class LikeButton: UIButton {

    // Properties

    var isLiked: Bool = false

    // override

    override func image(for state: UIControl.State) -> UIImage? {
        switch state {
        case .highlighted:
            let selectedImage: UIImage? = Defaults.selectedImage?.withTintColor(.systemRed.withAlphaComponent(0.5), renderingMode: .alwaysOriginal)
            let defaultImage: UIImage? = Defaults.defaultImage?.withTintColor(.label.withAlphaComponent(0.5), renderingMode: .alwaysOriginal)
            return isLiked ? selectedImage : defaultImage
        default:
            let selectedImage: UIImage? = Defaults.selectedImage?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            let defaultImage: UIImage? = Defaults.defaultImage?.withTintColor(.label, renderingMode: .alwaysOriginal)
            return isLiked ? selectedImage : defaultImage
        }
    }

    override func title(for state: UIControl.State) -> String? {
        return ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }

    // Functions

    func configure(isLiked: Bool) {
        self.isLiked = isLiked
        setTitle(title(for: .normal), for: .normal)
        setImage(image(for: .normal), for: .normal)
        setImage(image(for: .highlighted), for: .highlighted)
    }
}

fileprivate extension LikeButton {
    enum Defaults {
        static let defaultImage: UIImage? = UIImage(systemName: "heart")
        static let selectedImage: UIImage? = UIImage(systemName: "heart.fill")
    }
}
