//
//  MainView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI

extension Color {
    static let darkGrayColor = Color(red: 45 / 255, green: 41 / 255, blue: 41 / 255)
}


struct MainView: View {
    
    @ObservedObject var artistsViewModel: ArtistsViewModel
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
        self.artistsViewModel = ArtistsViewModel(container: container)
    }
    
    var searchListView: some View {
        
         ScrollView(.vertical) {
            LazyVStack {
                ForEach(artistsViewModel.artists, id:\.id) { artistDTO in
                    ArtistSearchResultView(artist: artistDTO)
                        .inject(container)
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
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
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
                        .background(Color.gray)
                        .clipped()
                        .cornerRadius(45 / 2.0)
                        .padding()
                        .padding(.leading, 15)
                    }
                }
                .padding(.top, 30)
            case .search:
                ZStack {
                    HStack {
                        TextField("Enter Search Text", text: $artistsViewModel.searchText)
                            .padding(.horizontal, 40)
                            .frame(height: 45, alignment: .center)
                            .background(Color.gray)
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
                .padding()
                .padding(.top, 30)
            }

            
            Spacer()
            switch self.artistsViewModel.mainViewmode {
            case .artist:
                if let _ = artistsViewModel.currentArtist {
                    AlbumsGridView(container: self.container, currentArtist: artistsViewModel.currentArtist ?? ArtistDTO.testData[0], currentArtistAlbums: artistsViewModel.currentArtistAlbums)
                } else {
                    Spacer()
                    Text("Tap search loop for artist")
                        .foregroundColor(Color.white)
                    Spacer()

                }
            case .search:
                if artistsViewModel.artists.count > 0 {
                    searchListView
                } else {
                    Spacer()
                    Text("No artists found!")
                        .foregroundColor(Color.white)
                    Spacer()
                }
            }
        }
        .background(Color.darkGrayColor)
        .edgesIgnoringSafeArea(.all)

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(container: AppEnvironment.initialSetup().container)
    }
}
