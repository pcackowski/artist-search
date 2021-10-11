//
//  ImageViewModel.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 11/10/2021.
//

import Foundation
import SwiftUI
import Combine

class ImageViewModel {
    private let imageURL: String
    private var container: DIContainer
    var subscriptions = Set<AnyCancellable>()
    @Binding private var image: Image?
    
    func getImage() -> Image? {
        return image
    }

    init(imageURL: String, container: DIContainer, image: Binding<Image?>) {
        self.imageURL = imageURL
        self.container = container
        self._image = image
    }

    
    func loadImage() {
        
        let publisher = container.interactors.imageInteractor.load(url: imageURL)
        publisher.sink { sub in
            switch sub {
            
            case .finished:
                print("finished")
            case .failure(let error):
                print("\(error)")
                self.image = Image(systemName: "magnifyingglass")
            }
        } receiveValue: { image in
            self.image = Image(uiImage: image)
        }.store(in: &subscriptions)
    }
}
