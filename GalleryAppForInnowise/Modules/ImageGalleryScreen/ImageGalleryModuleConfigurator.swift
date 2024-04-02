//
//  ImageGalleryModuleConfigurator.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 3.04.24.
//

import UIKit

// MARK: - ImageGalleryModuleConfigurator

final class ImageGalleryModuleConfigurator {

    static func instantiateModule() -> ImageGalleryViewController {
        let controller = ImageGalleryViewController()
        let viewModel = ImageGalleryViewModel()
        viewModel.view = controller
        controller.viewModel = viewModel
        return controller
    }
}
