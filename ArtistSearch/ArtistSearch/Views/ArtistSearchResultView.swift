//
//  ArtistSearchResultView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI
import Combine

struct ArtistSearchResultView: View {
    @Environment(\.injected) var container: DIContainer
    @State var artist: ArtistDTO
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 15)  {
                WrappedImageView(imageURL: artist.picture)
                    .frame(width: 50, height: 50, alignment: .center)
                    .inject(container)
                Text(artist.name)
                    .foregroundColor(Color.white)
                Spacer()
                
            }
            Divider()
                .foregroundColor(Color.gray)
        }
    }
}

struct ArtistSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSearchResultView(artist: ArtistDTO())
            .frame(height: 50)
    }
}
