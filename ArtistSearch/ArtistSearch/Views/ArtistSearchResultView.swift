//
//  ArtistSearchResultView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI

struct ArtistSearchResultView: View {
    
    
    @State var artist: ArtistDTO
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text(artist.name)
                .foregroundColor(Color.white)
        }
    }
}

struct ArtistSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSearchResultView(artist: ArtistDTO())
            .frame(height: 50)
    }
}
