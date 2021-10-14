//
//  DIContainer.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import SwiftUI
import Combine

struct DIContainer: EnvironmentKey {
    
    let interactors: Interactors
        
    init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(interactors: .stub)
}

extension DIContainer {
    struct Repositories {
        let artistsRepository: ArtistsRepository
        let imageRepository: ImageRepository

    }

}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(interactors: .stub)
    }
}
#endif

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

extension DIContainer {
    struct Interactors {
        let artistsInteractor: ArtistsInteractor
        let imageInteractor: ImagesInteractor

        init(artistsInteractor: ArtistsInteractor, imageInteractor: ImagesInteractor) {
            self.imageInteractor = imageInteractor
            self.artistsInteractor = artistsInteractor
        }
        
        static var stub: Self {
            .init(artistsInteractor: StubArtistsInteractor(), imageInteractor: StubImageInteractor())
            
        }
    }
}

extension View {
    
    func inject(_ interactors: DIContainer.Interactors) -> some View {
        let container = DIContainer(interactors: interactors)
        return inject(container)
    }
    
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}


struct StubImageInteractor: ImagesInteractor {
    func load(url: String) -> AnyPublisher<UIImage, Error> {
        if url.lowercased() == "fail" {
            return Fail<UIImage, Error>(error: APIError.imageUrlError)
                .eraseToAnyPublisher()

        } else {
            return Just(UIImage(systemName: "magnifyingglass")!)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()

        }
    }
}

struct StubArtistsInteractor: ArtistsInteractor {
    func loadAlbums(of artistId: Int, with link: String) -> AnyPublisher<AlbumResultPage, Error> {
        Just(AlbumResultPage.testData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
    }
    
    func searchForArtists(with query: String, with link: String) -> AnyPublisher<ArtistResultPage, Error> {
        Just(ArtistResultPage.testData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }    
    
    func loadDetails(of albumId: Int) -> AnyPublisher<TracksResultPage, Error> {
        Just(TracksResultPage.testData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()


    }
    
    
}
