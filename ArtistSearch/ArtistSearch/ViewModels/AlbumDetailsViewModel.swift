//
//  AlbumDetailsViewModel.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import Foundation
import Combine
import SwiftUI

class AlbumDetailsViewModel: ObservableObject {
    @Published var tracks: [TracksDTO] = []
    
    private var container: DIContainer
    private var albumSubscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func fetchForAlbumDetails(with albumId: Int) {
        
        let publisher = container.interactors.artistsInteractor.loadDetails(of: albumId)
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                switch sub {
                
                case .finished:
                    Log(.debug,"finished")
                case .failure(let error):
                    Log(.debug,"failuer \(error)")
                }
            
        } receiveValue: { tracksResultPage in
            withAnimation {
                self.tracks = tracksResultPage.data
            }

        }.store(in: &albumSubscriptions)
        
    }
}
