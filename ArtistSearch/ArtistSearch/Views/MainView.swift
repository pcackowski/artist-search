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
            
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(artistsViewModel.artists, id:\.id) { artistsDTO in
                        ArtistSearchResultView(artist: artistsDTO)
                            .inject(container)


                    }
                    
                }
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(container: AppEnvironment.initialSetup().container)
    }
}
