//
//  MainView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI


struct MainView: View {
    
    @ObservedObject var artistsViewModel: ArtistsViewModel
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
        self.artistsViewModel = ArtistsViewModel(container: container)
    }
        
    var searchListView: some View {
         ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(artistsViewModel.artists, id:\.id) { artistDTO in
                    ArtistSearchResultView(artist: artistDTO)
                        .frame(width: UIScreen.main.bounds.size.width, height: 60)
                        .inject(container)
                        .contentShape(Rectangle())
                        .onAppear{
                            artistsViewModel.fetchMoreIfNeeded(curentScrolledArtist: artistDTO)
                        }
                        
                        .onTapGesture {
                            artistsViewModel.currentArtist = artistDTO
                            withAnimation {
                                artistsViewModel.mainViewmode = .artist
                            }
                        }
                }
            }
         }
    }
    
    
    var body: some View {
        VStack {
            
            switch self.artistsViewModel.mainViewmode {

            case .artist:
                headerWithButton
                    .padding(.top, 30)
                Spacer()

                if let currentArtist = artistsViewModel.currentArtist {
                    AlbumsGridView(container: self.container, currentArtist: currentArtist, currentArtistAlbums: artistsViewModel.currentArtistAlbums)
                } else {
                    tapForSearchText
                }

            case .search:
                VStack {
                    searchTextField
                        .padding()
                        .padding(.top, 30)
                    Spacer()

                    if artistsViewModel.artists.count > 0 {
                        searchListView
                            .padding([.leading, .trailing, .bottom], 1)
                            .padding(.top, 5)

                    } else {
                        if !artistsViewModel.isArtistsFetching {
                            noArtistText
                        }

                    }
                }

            }

        }
        .background(Color.darkGrayColor)
        .edgesIgnoringSafeArea(.all)

    }
    
    var headerWithButton: some View {
        ZStack {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 10.0) {
                    Text(artistsViewModel.currentArtist?.name ?? "")
                        .foregroundColor(Color.white)
                    
                    Text("Albums")
                        .foregroundColor(Color.gray)
                    
                    
                }
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        switch self.artistsViewModel.mainViewmode {
                        
                        case .search:
                            self.artistsViewModel.mainViewmode = .artist
                        case .artist:
                            self.artistsViewModel.mainViewmode = .search

                        }
                    }
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.darkGrayColor)
                        .frame(width: 45, height: 45, alignment: .center)
                        


                })
                .background(Color.lightGrayColor)
                .clipped()
                .cornerRadius(45 / 2.0)
                .padding()
                .padding(.leading, 15)
            }
        }
    }
    
    var searchTextField: some View {
        ZStack {
            HStack {
                TextField("Enter Search Text", text: $artistsViewModel.searchText)
                    .padding(.horizontal, 40)
                    .frame(height: 45, alignment: .center)
                    .background(Color.lightGrayColor)
                    .clipped()
                    .cornerRadius(45 / 2.0)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.darkGrayColor)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            if artistsViewModel.isArtistsFetching {
                                Spacer()
                                Text("Fetching...")
                                    .frame(height: 45, alignment: .trailing)
                                    .foregroundColor(Color.darkGrayColor)
                                    .padding([.trailing], 5)

                            }

                         }
                     )
            }

        }
    }
    
    var noArtistText: some View {
        VStack {
            Spacer()
            Text("No artists found!")
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    var tapForSearchText: some View {
        VStack {
            Spacer()
            Text("Tap search loop for artist")
                .foregroundColor(Color.white)
            Spacer()
        }
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(container: AppEnvironment.initialSetup().container)
    }
}
