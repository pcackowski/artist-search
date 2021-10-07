//
//  MainView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI


struct MainView: View {
    
    @ObservedObject var artistsViewModel: ArtistsViewModel
    @State var isDetailsViewPresented: Bool = false
    private let container: DIContainer
    private var gridViewColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
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
                        .onTapGesture {
                            artistsViewModel.currentArtist = artistDTO
                            artistsViewModel.fetchForAlbums(of: artistDTO)
                            withAnimation {
                                artistsViewModel.mainViewmode = .artist
                            }

                        }


                }
                
            }
        }
    }
    
    
    var gridAlbumView: some View {
            ScrollView(.vertical) {
               LazyVGrid(columns: gridViewColumns, alignment: .center) {
                   ForEach(self.artistsViewModel.currentArtistAlbums, id:\.id) { albumDTO in
                    AlbumGridCellView(albumDTO: albumDTO, artist: self.artistsViewModel.currentArtist)
                        .inject(container)
                        .frame(height: 250)
                     .onTapGesture {
                        self.isDetailsViewPresented.toggle()
                         self.artistsViewModel.currentAlbum = albumDTO
                     }
                   }
                   
               }
           }
            .edgesIgnoringSafeArea(.all)
            .background(Color.black)

    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Search Text", text: $artistsViewModel.searchText)
                    .padding(.horizontal, 40)
                    .frame(height: 45, alignment: .center)
                    .background(Color.white)
                    .clipped()
                    .cornerRadius(45 / 2.0)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                         }
                     )
             }
            .padding()
            .padding(.top, 30)
            
            Spacer()
            switch self.artistsViewModel.mainViewmode {
            case .artist:
                gridAlbumView
            case .search:
                searchListView
            }


        }
        .fullScreenCover(isPresented: $isDetailsViewPresented, content: {
            AlbumDetailsView(albumDTO: artistsViewModel.currentAlbum, artist: artistsViewModel.currentArtist, container: container)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)

            
        })
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(container: AppEnvironment.initialSetup().container)
    }
}
