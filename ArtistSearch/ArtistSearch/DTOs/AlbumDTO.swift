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
    let tracks: [TracksDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
        case tracks = "data"
    }
    
    init(){
        id = 0
        title = ""
        cover = ""
        tracks = []
    }
}



struct TracksDTO: Codable {
    let id : Int
    let title: Int
    let cover: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
    }
}
