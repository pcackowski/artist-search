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
