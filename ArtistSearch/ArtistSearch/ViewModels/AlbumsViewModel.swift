//
//  AlbumsViewModel.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import Combine
import Foundation
import SwiftUI

class AlbumsViewModel: ObservableObject {
    @Published var currentArtist: ArtistDTO?
    @Published var currentArtistAlbums: [AlbumDTO] = []
    @Published var currentAlbum: AlbumDTO = AlbumDTO.testData[0]
    
    private var container: DIContainer
    private var albumsSubscriptions = Set<AnyCancellable>()
    private var nextLink: String = ""

    init(container: DIContainer, currentArtist: ArtistDTO) {
        self.container = container
        self.currentArtist = currentArtist
        self.fetchForAlbums()
    }
    
    func fetchForAlbums() {
        if let currentArtist = self.currentArtist {
            albumsSubscriptions.removeAll()

            let publisher = container.interactors.artistsInteractor.loadAlbums(of: currentArtist.id, with: self.nextLink)
            
            publisher
                .receive(on: DispatchQueue.main)
                .sink { sub in
                    switch sub {
                    
                    case .finished:
                        Log(.debug,"finished")
                    case .failure(let error):
                        Log(.debug,"failuer \(error)")
                    }
                
            } receiveValue: { albumsResultPage in
                self.nextLink = albumsResultPage.next ?? ""
                withAnimation {
                    self.currentArtistAlbums.append(contentsOf: albumsResultPage.data)
                }

                Log(.debug, "\(albumsResultPage)")
            }.store(in: &albumsSubscriptions)
        }

        
    }
    
    func fetchMoreIfNeeded(cuurentScrolledAlbum: AlbumDTO) {
        let thresholdIndex = currentArtistAlbums.index(currentArtistAlbums.endIndex, offsetBy: -5)
        if currentArtistAlbums.firstIndex(where: { $0.id == cuurentScrolledAlbum.id }) == thresholdIndex {
            if !nextLink.isEmpty {
                fetchForAlbums()
            }
        }
    }
}
