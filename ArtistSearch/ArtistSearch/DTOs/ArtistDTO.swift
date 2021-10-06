//
//  ArtistDTO.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

struct ArtistResultPage: Codable {
    let data : [ArtistDTO]
    let total: Int?
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

struct ArtistDTO: Codable {
    let id : Int
    let name: String
    let picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
    }
    
    init() {
        id = 1
        name = "Test"
        picture = "https://cdns-images.dzcdn.net/images/artist/5687721fc3a05cf67f9cd81310f93ff9/120x120-000000-80-0-0.jpg"
    }
}
