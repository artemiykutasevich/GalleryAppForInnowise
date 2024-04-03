//
//  ReusableView.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 3.04.24.
//

import UIKit

// MARK: - ReusableView

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

// MARK: - extension

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

