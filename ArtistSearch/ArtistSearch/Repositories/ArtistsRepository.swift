//
//  ArtistsRepository.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

import Combine
import SwiftUI


enum APIError: Swift.Error {
    case invalidURL
    case httpCode(Int)
    case unexpectedResponse
}

struct EndPointAPI {
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    let baseURL = "https://api.deezer.com"
    
    func urlRequest(for path: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Accept": "application/json"]
        return request
    }
    
    private func getArtistPath(with query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return "/search/artist?q=\(encodedQuery ?? "")"
    }
    
    func getArtisRequest(with query: String) throws -> URLRequest {
        let path = self.getArtistPath(with: query)
        let resultUrlRequest = try self.urlRequest(for: path)
        return resultUrlRequest
    }

}
enum DeezerError: Error {
    case unknownError
}

protocol ArtistsRepository {
    func getArtists(for query: String) -> AnyPublisher<ArtistResultPage, Error>
    func getArtistAlbums(with artistId: String) -> AnyPublisher<Void, Error>
    func getAlbumDetails(with albumId: String) -> AnyPublisher<Void, Error>
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
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()

            
        } catch {
            return Fail<ArtistResultPage, Error>(error: error).eraseToAnyPublisher()

        }
    }
    
    func getArtistAlbums(with artistId: String) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }
    
    func getAlbumDetails(with albumId: String) -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }
    
    
}
