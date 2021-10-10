//
//  ImageRepository.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Combine
import SwiftUI

protocol ImageRepository {
    func download(url: String) -> AnyPublisher<UIImage, Error>
}

struct ImageRepositoryInstance: ImageRepository {
        
    private var repositorySession: URLSession!
    
    init(session: URLSession? = nil) {
        repositorySession = session ?? EndPointAPI.configuredURLSession()
    }
    
    func download(url: String) -> AnyPublisher<UIImage, Error> {
        
        do {
            if let imageURL = try EndPointAPI().linkUrlRequest(for: url).url {
                var urlRequest = URLRequest(url: imageURL)
                urlRequest.httpMethod = "GET"

                return repositorySession.dataTaskPublisher(for: urlRequest)
                    .tryMap { (data, response) in
                        
                        guard let code = (response as? HTTPURLResponse)?.statusCode else {
                            throw APIError.unexpectedResponse
                        }
                        guard (200..<300).contains(code) else {
                            throw APIError.httpCode(code)
                        }

                        guard let image = UIImage(data: data)
                        else {
                            throw APIError.imageUrlError
                        }

                        return image
                    }
                    .eraseToAnyPublisher()
            } else {
                return Fail<UIImage, Error>(error: APIError.imageUrlError).eraseToAnyPublisher()
            }

        } catch {
            return Fail<UIImage, Error>(error: error).eraseToAnyPublisher()

        }


    }
    
}
