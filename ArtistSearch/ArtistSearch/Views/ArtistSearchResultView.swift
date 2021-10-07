//
//  ArtistSearchResultView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI
import Combine

class ImageViewModel {
    private let imageURL: String
    private var container: DIContainer
    var subscriptions = Set<AnyCancellable>()
    @Binding private var image: Image

    init(imageURL: String, container: DIContainer, image: Binding<Image>) {
        self.imageURL = imageURL
        self.container = container
        self._image = image
    }

    
    func loadImage() {
        
        if let imageURL = URL(string: imageURL) {
            let publisher = container.interactors.imageInteractor.load(url: imageURL)
            publisher.sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("\(error)")
                }
            } receiveValue: { image in
                self.image = Image(uiImage: image)
            }.store(in: &subscriptions)

        }
            
    }
}

struct WrappedImageView: View {
    @Environment(\.injected) var container: DIContainer
    @State private var image: Image
    @State private var imageViewModel: ImageViewModel?
    private let imageURL: String

    init(imageURL: String) {
        self.imageURL = imageURL
        self._image = .init(initialValue: Image(systemName: "magnifyingglass"))
    }
    
    func initialize() {
        self.imageViewModel = ImageViewModel(imageURL: imageURL, container: container, image: $image)

    }
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea(.all)

            if let unwrappedImage = self.image {
                unwrappedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            }
        }
        .transition(AnyTransition.opacity)
        .animation(.easeIn(duration: 0.2))
        .onAppear {
            self.initialize()
            self.imageViewModel?.loadImage()
        }

    }
    
}

struct ArtistSearchResultView: View {
    @Environment(\.injected) var container: DIContainer
    @State var artist: ArtistDTO
    
    var body: some View {
        HStack(alignment: .center, spacing: 15)  {
            WrappedImageView(imageURL: artist.picture)
                .frame(width: 50, height: 50, alignment: .center)
                .inject(container)
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
