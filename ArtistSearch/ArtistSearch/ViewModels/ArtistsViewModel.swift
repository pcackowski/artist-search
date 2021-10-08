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
    @Published var currentAlbum: AlbumDTO = AlbumDTO.testData[0]

    @Published var mainViewmode = MainViewMode.search
    @Published var isArtistsFetching = false

    
    private var container: DIContainer
    private var artistsSubscriptions = Set<AnyCancellable>()
    private var searchSubscriptions = Set<AnyCancellable>()
    private var nextLink: String = ""
    private var currentSearchText: String = ""

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
                self.artists = []
                self.nextLink = ""
                self.currentSearchText = searchField
                fetchForArtists()
            }.store(in: &searchSubscriptions)
    }
    
    func fetchForArtists() {
        let publisher: AnyPublisher<ArtistResultPage, Error>
        artistsSubscriptions.removeAll()
        publisher = container.interactors.artistsInteractor.searchForArtists(with: self.currentSearchText, with: nextLink)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { sub in
                
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("failure \(error)")
                }
            
        } receiveValue: { artistsResultPage in
            self.nextLink = artistsResultPage.next ?? ""
            withAnimation {
                self.artists.append(contentsOf: artistsResultPage.data)
            }
            print(artistsResultPage)
        }.store(in: &artistsSubscriptions)
    }
    
    func fetchMoreIfNeeded(curentScrolledArtist: ArtistDTO) {
        let thresholdIndex = artists.index(artists.endIndex, offsetBy: -5)
        if artists.firstIndex(where: { $0.id == curentScrolledArtist.id }) == thresholdIndex {
            if !nextLink.isEmpty {
                fetchForArtists()
            }
        }
    }
    
}
