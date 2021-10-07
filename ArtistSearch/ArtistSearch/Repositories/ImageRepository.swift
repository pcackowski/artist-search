//
//  ImageRepository.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import Combine
import SwiftUI

protocol ImageRepository {
    func download(imageURL: URL) -> AnyPublisher<UIImage, Error>
}

struct ImageRepositoryInstance: ImageRepository {
    
    func download(imageURL: URL) -> AnyPublisher<UIImage, Error> {
        let session = EndPointAPI.configuredURLSession()
        var urlRequest = URLRequest(url: imageURL)
        urlRequest.httpMethod = "GET"

        return session.dataTaskPublisher(for: urlRequest)
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

    }
    
}
