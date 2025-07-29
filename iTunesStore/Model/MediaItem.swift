//
//  MediaItem.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

import Foundation

struct SearchResult: Codable {
    let resultCount: Int
    let results: [MediaItem]
}

struct MediaItem: Codable {
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
}
