//
//  ImageInteractor.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import UIKit
import Combine

protocol ImagesInteractor {
    func load(url: String) -> AnyPublisher<UIImage, Error>
}

struct ImagesInteractorInstance: ImagesInteractor {
    let imageRepository: ImageRepository

    func load(url: String) -> AnyPublisher<UIImage, Error> {
        
        if let image = ImageCache.shared.image(url: url) {
            return Just(image)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return imageRepository.download(url: url)
                    .flatMap { image -> AnyPublisher<UIImage, Error> in
                        ImageCache.shared.store(image: image, url: url)
                        return Just(image)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
            .eraseToAnyPublisher()
        }
    }
    
    
    
}
