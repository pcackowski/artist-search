//
//  ArtistDTO.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

struct ArtistResultPage: Codable {
    let data : [ArtistDTO]
    let total: Int
    let next: String

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
    let name: Int
    let picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
    }
}
