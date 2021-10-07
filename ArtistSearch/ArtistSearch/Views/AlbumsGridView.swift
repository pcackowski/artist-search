//
//  AlbumsGridView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import SwiftUI
import Combine

struct AlbumsGridView: View {
    @ObservedObject var albumsViewModel: AlbumsViewModel
    @State var isDetailsViewPresented: Bool = false

    private var container: DIContainer

    private var gridViewColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(container: DIContainer, currentArtist: ArtistDTO, currentArtistAlbums: [AlbumDTO]) {
        self.container = container
        self.albumsViewModel = AlbumsViewModel(container: container, currentArtist: currentArtist)
    }
    

    var body: some View {
        ScrollView(.vertical) {
           LazyVGrid(columns: gridViewColumns, alignment: .center) {
               ForEach(self.albumsViewModel.currentArtistAlbums, id:\.id) { albumDTO in
                AlbumGridCellView(albumDTO: albumDTO, artistName: self.albumsViewModel.currentArtist?.name ?? "")
                    .inject(container)
                    .frame(height: 250)
                 .onTapGesture {
                    self.isDetailsViewPresented.toggle()
                    self.albumsViewModel.currentAlbum = albumDTO
                 }
               }
               
           }
       }
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
        .fullScreenCover(isPresented: $isDetailsViewPresented, content: {
            AlbumDetailsView(albumDTO: albumsViewModel.currentAlbum, artist: albumsViewModel.currentArtist, container: container)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
        })
    }
}

struct AlbumsGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsGridView(container: AppEnvironment.initialSetup().container, currentArtist: ArtistDTO(), currentArtistAlbums: [])
    }
}
