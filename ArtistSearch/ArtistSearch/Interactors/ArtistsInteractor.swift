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
    func searchForArtists(with query: String) -> AnyPublisher<ArtistResultPage, Error>
    func loadAlbums(of artistId: Int) -> AnyPublisher<AlbumResultPage, Error>
    func loadDetails(of albumId: Int) -> AnyPublisher<Void, Error>
}

struct ArtistsInteractorInstance: ArtistsInteractor {
    
    let repository: ArtistsRepository

    init(repository: ArtistsRepository) {
        self.repository = repository
    }
    func searchForArtists(with query: String) -> AnyPublisher<ArtistResultPage, Error> {
        return repository.getArtists(for: query)
    }
    
    func loadAlbums(of artistId: Int) -> AnyPublisher<AlbumResultPage, Error> {
        return repository.getArtistAlbums(with: artistId)
    }
    
    func loadDetails(of albumId: Int) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }
    
    
}
