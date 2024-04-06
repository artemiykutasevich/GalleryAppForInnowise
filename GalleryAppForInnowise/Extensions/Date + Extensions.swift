//
//  Date + Extensions.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 6.04.24.
//

import Foundation

extension Date {
   func toString(withFormat format: String = "MMMM dd, YYYY") -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
