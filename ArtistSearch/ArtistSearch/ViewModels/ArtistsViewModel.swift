//
//  MainViewModel.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI
import Combine


enum MainViewMode {
    case search
    case artist
}


class ArtistsViewModel: ObservableObject {
    @Published var searchText: String = String()
    @Published var artists: [ArtistDTO] = []
    @Published var currentArtist: ArtistDTO?
    @Published var currentArtistAlbums: [AlbumDTO] = []
    @Published var currentAlbum: AlbumDTO = AlbumDTO()

    @Published var mainViewmode = MainViewMode.search
    @Published var isArtistsFetching = false

    
    private var container: DIContainer
    private var artistsSubscriptions = Set<AnyCancellable>()
    private var searchSubscriptions = Set<AnyCancellable>()
    private var nextLink: String = ""

    init(container: DIContainer) {
        self.container = container
        
        setupSearch()
        
    }
    
    private func setupSearch() {
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
                withAnimation {
                    mainViewmode = .search
                }
                fetchForArtists(with: searchField)
            }.store(in: &searchSubscriptions)
    }
    
    func fetchForArtists(with query: String) {
        artistsSubscriptions.removeAll()

        let publisher = container.interactors.artistsInteractor.searchForArtists(with: query)
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("failure \(error)")
                }
            
        } receiveValue: { artistsResultPege in
            self.nextLink = artistsResultPege.next ?? ""
            withAnimation {
                self.artists = artistsResultPege.data
            }
            print(artistsResultPege)
        }.store(in: &artistsSubscriptions)
        
    }
    

    
    func fetchMoreIfNeeded(curentScrolledArtist: ArtistDTO) {
        let thresholdIndex = artists.index(artists.endIndex, offsetBy: -5)
        if artists.firstIndex(where: { $0.id == curentScrolledArtist.id }) == thresholdIndex {
            if !nextLink.isEmpty {
                fetchNextArtist()
            }
        }
    }
    
    func fetchNextArtist() {
        let publisher = container.interactors.artistsInteractor.loadNextArtists(with: self.nextLink)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("failuer \(error)")
                }
            
        } receiveValue: { artistsResultPage in
            self.nextLink = artistsResultPage.next ?? ""
            withAnimation {
                self.artists.append(contentsOf: artistsResultPage.data)
            }

            print(artistsResultPage)
        }.store(in: &artistsSubscriptions)
    }

}
