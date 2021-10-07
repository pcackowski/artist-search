//
//  AlbumDTO.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation


struct AlbumResultPage: Codable {
    let data : [AlbumDTO]
    let total: Int
    let next: String?

    enum CodingKeys: String, CodingKey {
        case data
        case total
        case next
    }
    
    init() {
        data = []
        total = 0
        next = ""
    }
}

struct AlbumDTO: Codable {
    let id : Int
    let title: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let tracks: [TracksDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case tracks = "data"
    }
    
    init(){
        id = 0
        title = ""
        cover = ""
        tracks = []
        coverSmall = ""
        coverMedium = ""
        coverBig = ""
    }
}



struct TracksResultPage: Codable {
    let data : [TracksDTO]
    let total: Int
    let next: String?

    enum CodingKeys: String, CodingKey {
        case data
        case total
        case next
    }
    
    init() {
        data = []
        total = 0
        next = ""
    }
}

struct TracksDTO: Codable {
    let id : Int
    let title: String
    let duration: Int
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case duration
        case position = "track_position"
    }
    
}
extension Double {
  func formatToString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
