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
        GeometryReader { geometry in
            
            ZStack {
                HStack(alignment: .center, spacing: 0)  {
                    WrappedImageView(imageURL: artist.picture)
                        .inject(container)
                        .frame(width: geometry.size.height, height: geometry.size.height)
                    Text(artist.name)
                        .foregroundColor(Color.white)
                        .padding(.leading, 15)
                    Spacer()
                }
                VStack {
                    Spacer()
                    Divider()
                        .background(Color.lightGrayColor)

                }
            }
            


        }


    }
}

struct ArtistSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSearchResultView(artist: ArtistDTO.testData[0])
            .frame(height: 50)
    }
}
