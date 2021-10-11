//
//  AlbumDetailsView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import SwiftUI

struct AlbumDetailsView: View {
    
    @ObservedObject private var viewModel: AlbumDetailsViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    private var albumDTO : AlbumDTO
    private var artist: ArtistDTO?
    private var container: DIContainer
    
    init(albumDTO: AlbumDTO, artist: ArtistDTO?, container: DIContainer) {
        self.albumDTO = albumDTO
        self.artist = artist
        self.container = container
        self.viewModel = AlbumDetailsViewModel(container: container)
    }
    
    private func fetch() {
        self.viewModel.fetchForAlbumDetails(with: self.albumDTO.id)
    }
    
    var trackListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.tracks, id:\.id) { trackDTO in
                    VStack {
                        HStack {
                            Text("\(trackDTO.position)")
                                .foregroundColor(Color.white)
                                .padding(15)
                            Spacer()
                            HStack {
                                VStack (alignment: .leading, spacing: 5) {
                                    Text("\(trackDTO.title)")
                                        .foregroundColor(Color.white)
                                    Text("\(artist?.name ?? "")")
                                        .foregroundColor(Color.gray)


                                }

                                Spacer()
                            }
                            
                            Spacer()
                            Text("\(Double(trackDTO.duration).formatToString(style: .positional))")
                                .foregroundColor(Color.gray)
                                .padding(.trailing, 15)


                        }
                        Divider()
                            .foregroundColor(Color.gray)

                    }

                }
                
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Close")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 15)

                    })
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(albumDTO.title)")
                        .foregroundColor(Color.white)
                    Text("\(artist?.name ?? "")")
                        .foregroundColor(Color.gray )
                    
                }
                .padding(.top, 15)
                .padding([.leading, .trailing], 50)

            }

            WrappedImageView(imageURL: albumDTO.coverBig)
                .inject(container)
                .padding(.bottom, 10)
            
            trackListView

        }
        .onAppear {
            self.fetch()
        }
        .padding(.top, 30)
    }

}

struct AlbumDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailsView(albumDTO: AlbumDTO.testData[0], artist: ArtistDTO.testData[0], container: DIContainer(interactors: DIContainer.Interactors.stub))
    }
}
