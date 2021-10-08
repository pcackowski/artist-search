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
    func loadAlbums(of artistId: Int) -> AnyPublisher<AlbumResultPage, Error>
    func loadNextAlbums(with link: String) -> AnyPublisher<AlbumResultPage, Error>
    func loadDetails(of albumId: Int) -> AnyPublisher<TracksResultPage, Error>
    func searchForArtists(with query: String, with link: String) -> AnyPublisher<ArtistResultPage, Error> 
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
    
    func loadAlbums(of artistId: Int) -> AnyPublisher<AlbumResultPage, Error> {
        return repository.getArtistAlbums(with: artistId)
    }
    
    func loadDetails(of albumId: Int) -> AnyPublisher<TracksResultPage, Error> {
        return repository.getAlbumDetails(with: albumId)
    }
    
    func loadNextAlbums(with link: String) -> AnyPublisher<AlbumResultPage, Error> {
        return repository.getNextAlbums(with: link)

    }
    
    
}
