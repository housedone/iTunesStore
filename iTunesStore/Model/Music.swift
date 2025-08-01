//
//  Music.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

struct Music: Codable, MediaItem, Hashable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl100: String?

    var title: String { trackName ?? "제목 없음" }
    var subtitle: String { artistName ?? "아티스트 없음" }
    var collectionTitle: String { collectionName ?? "앨범 없음" }
    var imageUrl: String? { artworkUrl100 }
}

/* 예시
 {
     "resultCount": 60,
     "results": [
         {
             "wrapperType": "track",
             "kind": "song",
             "artistId": 1087651007,
             "collectionId": 1144767453,
             "trackId": 1144767459,
             "artistName": "WJSN",
             "collectionName": "The Secret",
             "trackName": "Secret",
             "collectionCensoredName": "The Secret",
             "trackCensoredName": "Secret",
             "artistViewUrl": "https://music.apple.com/us/artist/%EC%9A%B0%EC%A3%BC%EC%86%8C%EB%85%80/1087651007?l=ko&uo=4",
             "collectionViewUrl": "https://music.apple.com/us/album/secret/1144767453?i=1144767459&l=ko&uo=4",
             "trackViewUrl": "https://music.apple.com/us/album/secret/1144767453?i=1144767459&l=ko&uo=4",
             "previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/89/71/35/89713548-b611-769a-72a8-f444ec257fa9/mzaf_611293407140842052.plus.aac.p.m4a",
             "artworkUrl30": "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/94/a2/6e/94a26e08-085a-ff53-500e-b14c508aae5c/COVER-.jpg/30x30bb.jpg",
             "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/94/a2/6e/94a26e08-085a-ff53-500e-b14c508aae5c/COVER-.jpg/60x60bb.jpg",
             "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/94/a2/6e/94a26e08-085a-ff53-500e-b14c508aae5c/COVER-.jpg/100x100bb.jpg",
             "collectionPrice": 6.99,
             "trackPrice": 1.29,
             "releaseDate": "2016-08-17T12:00:00Z",
             "collectionExplicitness": "notExplicit",
             "trackExplicitness": "notExplicit",
             "discCount": 1,
             "discNumber": 1,
             "trackCount": 7,
             "trackNumber": 1,
             "trackTimeMillis": 222582,
             "country": "USA",
             "currency": "USD",
             "primaryGenreName": "K-Pop",
             "isStreamable": true
         }
     ]
 }
 */
