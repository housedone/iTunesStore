//
//  MediaItem.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

import Foundation

protocol MediaItem {
    var title: String { get }
    var subtitle: String { get }
    var imageUrl: String? { get }
}
