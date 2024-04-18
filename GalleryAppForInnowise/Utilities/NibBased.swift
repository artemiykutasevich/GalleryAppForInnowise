//
//  NibBased.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 3.04.24.
//

import UIKit

// MARK: - NibBased

protocol NibBased {
    static var nibName: String { get }
}

// MARK: - extension

extension NibBased {
    static var nibName: String {
        String(describing: self)
    }
}

extension NibBased where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    static func instantiate() -> Self {
        // swiftlint:disable:next force_cast
        return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! Self
    }
}

extension NibBased where Self: UIViewController {
    static func instantiate() -> Self {
        Self.init(nibName: self.nibName, bundle: Bundle(for: self))
    }
}

extension NibBased where Self: UICollectionViewCell {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}
