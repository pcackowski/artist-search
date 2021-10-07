//
//  AlbumGridView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import SwiftUI
import Combine

class AlbumViewModel {
    
    private var container: DIContainer
    private var albumDTO : AlbumDTO

    init(albumDTO: AlbumDTO, container: DIContainer) {
        self.albumDTO = albumDTO
        self.container = container
    }
    
}

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
            WrappedImageView(imageURL: albumDTO.cover)
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
