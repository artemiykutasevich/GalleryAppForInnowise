//
//  String + Extensions.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 6.04.24.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
