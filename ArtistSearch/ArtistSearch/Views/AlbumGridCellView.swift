//
//  AlbumGridView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import SwiftUI
import Combine

struct AlbumGridCellView: View {
    @Environment(\.injected) var container: DIContainer
    private var albumDTO : AlbumDTO
    private var artistName: String
    
    init(albumDTO: AlbumDTO, artistName: String) {
        self.albumDTO = albumDTO
        self.artistName = artistName
        
    }

    var body: some View {
        VStack {
            WrappedImageView(imageURL: albumDTO.coverMedium)
                .inject(container)
            VStack(alignment: .leading, spacing: 10) {
                Text("\(albumDTO.title)")
                    .foregroundColor(Color.white)
                Text("\(artistName)")
                    .foregroundColor(Color.white)
            }

        }
    }
}

struct AlbumGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGridCellView(albumDTO: AlbumDTO(), artistName: "")
    }
}
