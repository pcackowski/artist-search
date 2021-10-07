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
    private var artist: ArtistDTO?
    
    init(albumDTO: AlbumDTO, artist: ArtistDTO?) {
        self.albumDTO = albumDTO
        self.artist = artist
        
    }

    var body: some View {
        VStack {
            WrappedImageView(imageURL: albumDTO.coverMedium)
                .inject(container)
            VStack(alignment: .leading, spacing: 10) {
                Text("\(albumDTO.title)")
                    .foregroundColor(Color.white)
                Text("\(artist?.name ?? "")")
                    .foregroundColor(Color.white)
            }

        }
    }
}

//struct AlbumGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumGridView()
//    }
//}
