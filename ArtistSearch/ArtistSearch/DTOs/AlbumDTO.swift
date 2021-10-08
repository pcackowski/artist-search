//
//  AlbumDTO.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation


struct AlbumResultPage: Codable,Equatable {
    let data : [AlbumDTO]
    let total: Int
    let next: String?

    enum CodingKeys: String, CodingKey {
        case data
        case total
        case next
    }
    
}

struct AlbumDTO: Codable, Equatable, Identifiable {
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
    
}

extension AlbumDTO {
    static let testData: [AlbumDTO] = [AlbumDTO(id: -1, title: "test title", cover: "", coverSmall: "", coverMedium: "", coverBig: "", tracks: [])]
}

extension AlbumResultPage {
    static let testData: AlbumResultPage = AlbumResultPage(data: AlbumDTO.testData, total: AlbumDTO.testData.count, next: nil)

}




struct TracksResultPage: Codable, Equatable {
    let data : [TracksDTO]
    let total: Int
    let next: String?

    enum CodingKeys: String, CodingKey {
        case data
        case total
        case next
    }

}

struct TracksDTO: Codable, Equatable {
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


extension TracksDTO {
    static let testData: [TracksDTO] = [TracksDTO(id: -1, title: "test title", duration: 100, position: 0)]
}

extension TracksResultPage {
    static let testData: TracksResultPage = TracksResultPage(data: TracksDTO.testData, total: TracksDTO.testData.count, next: nil)

}
extension Double {
  func formatToString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
