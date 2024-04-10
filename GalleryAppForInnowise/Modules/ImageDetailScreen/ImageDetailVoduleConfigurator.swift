//
//  ImageDetailVoduleConfigurator.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 5.04.24.
//

import Foundation

final class ImageDetailModuleConfigurator {

    static func instantiateModule(currentItem: PageItem) -> ImageDetailViewController {
        let controller: ImageDetailViewController = ImageDetailViewController.instantiate()
        let viewModel = ImageDetailViewModel(currentItem: currentItem)
        controller.viewModel = viewModel
        return controller
    }
}
