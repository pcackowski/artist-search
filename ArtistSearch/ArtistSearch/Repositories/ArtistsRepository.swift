//
//  ArtistsRepository.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

import Combine
import SwiftUI




protocol ArtistsRepository {
    func getArtists(for query: String) -> AnyPublisher<ArtistResultPage, Error>
    func getArtistAlbums(with artistId: Int) -> AnyPublisher<AlbumResultPage, Error>
    func getAlbumDetails(with albumId: Int) -> AnyPublisher<TracksResultPage, Error>
}

struct ArtistsRepositoryInstance: ArtistsRepository {
    
    func getArtists(for query: String) -> AnyPublisher<ArtistResultPage, Error> {
        
        do {
            let session = EndPointAPI.configuredURLSession()
            let request = try EndPointAPI().getArtisRequest(with: query)
            return session.dataTaskPublisher(for: request)
                .tryMap({ (data: Data, response: URLResponse) in
                    guard let code = (response as? HTTPURLResponse)?.statusCode else {
                        throw APIError.unexpectedResponse
                    }
                    guard (200..<300).contains(code) else {
                        throw APIError.httpCode(code)
                    }
                    return data

                })
                .decode(type: ArtistResultPage.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            
        } catch {
            return Fail<ArtistResultPage, Error>(error: error).eraseToAnyPublisher()

        }
    }
    
    func getArtistAlbums(with artistId: Int) -> AnyPublisher<AlbumResultPage, Error> {
        
        do {
            let session = EndPointAPI.configuredURLSession()
            let request = try EndPointAPI().getAlbumRequest(for: artistId)
            return session.dataTaskPublisher(for: request)
                .tryMap({ (data: Data, response: URLResponse) in
                    guard let code = (response as? HTTPURLResponse)?.statusCode else {
                        throw APIError.unexpectedResponse
                    }
                    guard (200..<300).contains(code) else {
                        throw APIError.httpCode(code)
                    }
                    return data

                })
                .decode(type: AlbumResultPage.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            
        } catch {
            return Fail<AlbumResultPage, Error>(error: error)
                .eraseToAnyPublisher()

        }
        

    }
    
    func getAlbumDetails(with albumId: Int) -> AnyPublisher<TracksResultPage, Error> {
        do {
            let session = EndPointAPI.configuredURLSession()
            let request = try EndPointAPI().getAlbumDetailsRequest(for: albumId)
            return session.dataTaskPublisher(for: request)
                .tryMap({ (data: Data, response: URLResponse) in
                    guard let code = (response as? HTTPURLResponse)?.statusCode else {
                        throw APIError.unexpectedResponse
                    }
                    guard (200..<300).contains(code) else {
                        throw APIError.httpCode(code)
                    }
                    return data

                })
                .decode(type: TracksResultPage.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()

            
        } catch {
            return Fail<TracksResultPage, Error>(error: error)
                .eraseToAnyPublisher()

        }

    }
    
    
}
