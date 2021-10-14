//
//  AppEnvironment.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
    
    static func initialSetup() -> AppEnvironment {
        let repositories = configureRepositories()
        let interactors = configureInteractors(artistsRepository: repositories.artistsRepository, imageRepository: repositories.imageRepository)
        let diContainer = DIContainer(interactors: interactors)
        return AppEnvironment(container: diContainer)

        
    }
    
    
    private static func configureInteractors(artistsRepository: ArtistsRepository, imageRepository: ImageRepository) -> DIContainer.Interactors {
        
        let artistsInteractor = ArtistsInteractorInstance(repository: artistsRepository)
        let imageInteractor = ImagesInteractorInstance(imageRepository: imageRepository)

        return .init(artistsInteractor: artistsInteractor, imageInteractor: imageInteractor)
    }
    
    private static func configureRepositories() -> DIContainer.Repositories {
        let artistsRepository = ArtistsRepositoryInstance()
        let imageRepository = ImageRepositoryInstance()

        return .init(artistsRepository: artistsRepository, imageRepository: imageRepository)
    }
}

