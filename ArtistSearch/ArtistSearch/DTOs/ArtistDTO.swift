//
//  ArtistDTO.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

struct ArtistResultPage: Codable, Equatable {
    let data : [ArtistDTO]
    let total: Int?
    let next: String?

    enum CodingKeys: String, CodingKey {
        case data
        case total
        case next
    }
    
}

struct ArtistDTO: Codable, Equatable, Identifiable {
    let id : Int
    let name: String
    let picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
    }
    
}

extension ArtistDTO {
    static let testData: [ArtistDTO] = [ArtistDTO(id: -1, name: "Lenny Kravitz", picture: "")]
}

extension ArtistResultPage {
    static let testData: ArtistResultPage = ArtistResultPage(data: ArtistDTO.testData, total: ArtistDTO.testData.count, next: nil)

}
