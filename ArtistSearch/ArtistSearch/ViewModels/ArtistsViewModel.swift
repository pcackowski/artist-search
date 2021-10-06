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
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.artists = []
                    return nil
                }
                
                return string
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                fetchForArtists(with: searchField)
            }.store(in: &subscriptions)
        
    }
    
    func fetchForArtists(with query: String) {
        
        let publisher = container.interactors.artistsInteractor.searchForArtists(with: query)
        publisher.sink { sub in
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
