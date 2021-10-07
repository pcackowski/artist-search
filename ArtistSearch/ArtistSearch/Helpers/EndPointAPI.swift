//
//  EndPointAPI.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Foundation

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(Int)
    case unexpectedResponse
    case imageUrlError
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
    
    func linkUrlRequest(for path: String) throws -> URLRequest {
        guard let url = URL(string: path) else {
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

    private func getAlbumPath(for artistID: Int) -> String {
        return "/artist/\(artistID)/albums"
    }


    private func getAlbumDetailsPath(for albumID: Int) -> String {
        return "/album/\(albumID)/tracks"
    }

    func getArtisRequest(with query: String) throws -> URLRequest {
        let path = self.getArtistPath(with: query)
        let resultUrlRequest = try self.urlRequest(for: path)
        return resultUrlRequest
    }
    
    func getAlbumRequest(for artistId: Int) throws -> URLRequest {
        let path = self.getAlbumPath(for: artistId)
        let resultUrlRequest = try self.urlRequest(for: path)
        return resultUrlRequest
    }

    
    func getAlbumDetailsRequest(for albumId: Int) throws -> URLRequest {
        let path = self.getAlbumDetailsPath(for: albumId)
        let resultUrlRequest = try self.urlRequest(for: path)
        return resultUrlRequest
    }

    
    func getNextAlbumRequest(for nextLink: String) throws -> URLRequest {
        let resultUrlRequest = try self.linkUrlRequest(for: nextLink)
        return resultUrlRequest
    }

}
