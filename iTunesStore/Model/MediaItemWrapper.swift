//
//  MediaItemWrapper.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import Foundation

struct MediaItemWrapper: Hashable {
    let id = UUID()
    let item: MediaItem
    let mediaType: String

    static func == (lhs: MediaItemWrapper, rhs: MediaItemWrapper) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
