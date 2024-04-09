//
//  InfoPlistWrappers.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 8.04.24.
//

import Foundation

class InfoPlistWrappers {

    // Unsplash
    #warning("Add your unsplash access key in info.plist")
    static let unsplashAccessKey: String? = Bundle.main.infoDictionary?["UnsplashAccessKey"] as? String
}
