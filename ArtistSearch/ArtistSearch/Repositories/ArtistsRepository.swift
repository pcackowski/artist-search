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
    func getNextAlbums(with link: String) -> AnyPublisher<AlbumResultPage, Error>
    func getNextArtists(with link: String) -> AnyPublisher<ArtistResultPage, Error>
}

struct ArtistsRepositoryInstance: ArtistsRepository {
    
    
    func getNextArtists(with link: String) -> AnyPublisher<ArtistResultPage, Error> {
        do {
            let session = EndPointAPI.configuredURLSession()
            let request = try EndPointAPI().getNextAlbumRequest(for: link)
            return session.dataTaskPublisher(for: request)
                .handleResponse(acceptedHttpCodes: (200..<300))
                .eraseToAnyPublisher()
        } catch {
            return Fail<ArtistResultPage, Error>(error: error).eraseToAnyPublisher()

        }
    }
    
    func getNextAlbums(with link: String) -> AnyPublisher<AlbumResultPage, Error> {
        do {
            let session = EndPointAPI.configuredURLSession()
            let request = try EndPointAPI().getNextAlbumRequest(for: link)
            return session.dataTaskPublisher(for: request)
                .handleResponse(acceptedHttpCodes: (200..<300))
                .eraseToAnyPublisher()

            
        } catch {
            return Fail<AlbumResultPage, Error>(error: error).eraseToAnyPublisher()

        }
    }

    
    func getArtists(for query: String) -> AnyPublisher<ArtistResultPage, Error> {
        
        do {
            let session = EndPointAPI.configuredURLSession()
            let request = try EndPointAPI().getArtisRequest(with: query)
            return session.dataTaskPublisher(for: request)
                .handleResponse(acceptedHttpCodes: (200..<300))
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
                .handleResponse(acceptedHttpCodes: (200..<300))
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
                .handleResponse(acceptedHttpCodes: (200..<300))
                .eraseToAnyPublisher()

            
        } catch {
            return Fail<TracksResultPage, Error>(error: error)
                .eraseToAnyPublisher()

        }

    }
    
    
}


private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func handleResponse<Value>(acceptedHttpCodes: Range<Int>) -> AnyPublisher<Value, Error> where Value: Decodable {
        return tryMap {
                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
                }
                guard acceptedHttpCodes.contains(code) else {
                    throw APIError.httpCode(code)
                }
                return $0.0

        }
        .decode(type: Value.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
