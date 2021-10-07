//
//  MainViewModel.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI
import Combine

class ArtistsViewModel: ObservableObject {
    @Published var searchText: String = String()
    @Published var artists: [ArtistDTO] = []

    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()

    
    init(container: DIContainer) {
        self.container = container

        
        $searchText
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.artists = []
                    return nil
                }
                
                return string
            })
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                fetchForArtists(with: searchField)
            }.store(in: &subscriptions)
        
    }
    
    func fetchForArtists(with query: String) {
        
        let publisher = container.interactors.artistsInteractor.searchForArtists(with: query)
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("failuer \(error)")
                }
            
        } receiveValue: { artistsResultPege in
            self.artists = artistsResultPege.data
            print(artistsResultPege)
        }.store(in: &subscriptions)
        
    }

}
