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
        self.fetchForAlbums(of: currentArtist)
    }
    
    func fetchForAlbums(of artist: ArtistDTO) {
        albumsSubscriptions.removeAll()
        let publisher = container.interactors.artistsInteractor.loadAlbums(of: artist.id)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("failuer \(error)")
                }
            
        } receiveValue: { albumsResultPage in
            self.nextLink = albumsResultPage.next ?? ""
            withAnimation {
                self.currentArtistAlbums = albumsResultPage.data
            }

            print(albumsResultPage)
        }.store(in: &albumsSubscriptions)
        
    }
    
    func fetchNextAlbums() {
        let publisher = container.interactors.artistsInteractor.loadNextAlbums(with: self.nextLink)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("failuer \(error)")
                }
            
        } receiveValue: { albumsResultPage in
            self.nextLink = albumsResultPage.next ?? ""
            withAnimation {
                self.currentArtistAlbums.append(contentsOf: albumsResultPage.data)
            }

            print(albumsResultPage)
        }.store(in: &albumsSubscriptions)
    }
    
    
    func fetchMoreIfNeeded(cuurentScrolledAlbum: AlbumDTO) {
        let thresholdIndex = currentArtistAlbums.index(currentArtistAlbums.endIndex, offsetBy: -5)
        if currentArtistAlbums.firstIndex(where: { $0.id == cuurentScrolledAlbum.id }) == thresholdIndex {
            if !nextLink.isEmpty {
                fetchNextAlbums()
            }
        }
    }
}
