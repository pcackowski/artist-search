//
//  ArtistInteractor.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation
import SwiftUI
import Combine

protocol ArtistsInteractor {
    func loadDetails(of albumId: Int) -> AnyPublisher<TracksResultPage, Error>
    func searchForArtists(with query: String, with link: String) -> AnyPublisher<ArtistResultPage, Error>
    func loadAlbums(of artistId: Int, with link: String) -> AnyPublisher<AlbumResultPage, Error>
}

struct ArtistsInteractorInstance: ArtistsInteractor {
    
    let repository: ArtistsRepository

    init(repository: ArtistsRepository) {
        self.repository = repository
    }
    func searchForArtists(with query: String, with link: String) -> AnyPublisher<ArtistResultPage, Error> {
        if link.isEmpty {
            return repository.getArtists(for: query)
        } else {
            return repository.getNextArtists(with: link)
        }
    }
    
    func loadAlbums(of artistId: Int, with link: String) -> AnyPublisher<AlbumResultPage, Error> {
        if link.isEmpty {
            return repository.getArtistAlbums(with: artistId)
        } else {
            return repository.getNextAlbums(with: link)
        }
    }
    
    func loadDetails(of albumId: Int) -> AnyPublisher<TracksResultPage, Error> {
        return repository.getAlbumDetails(with: albumId)
    }
    
}
