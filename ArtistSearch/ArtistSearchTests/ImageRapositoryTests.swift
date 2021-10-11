//
//  ImageRapositoryTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 10/10/2021.
//

import XCTest
import Combine
import UIKit

@testable import ArtistSearch

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

class ImageRapositoryTests: XCTestCase {

    private var sut: ImageRepositoryInstance!
    private var subscriptions = Set<AnyCancellable>()
    private var mockBaseUrl: String = "test.com"
    private lazy var responseImage = UIColor.gray.image(CGSize(width: 10, height: 10))


    override func setUpWithError() throws {
        subscriptions = Set<AnyCancellable>()
        sut = ImageRepositoryInstance(session:  URLSession.mockedResponsesOnly)
    }


    override func tearDownWithError() throws {
        RequestMock.removeAllMocks()

    }

    func test_loadImage() throws {

        let imageURL = String("https://api.deezer.com/artist/64740/image")
        let responseData = try XCTUnwrap(responseImage.pngData())
        let urlRequest = try EndPointAPI().linkUrlRequest(for: imageURL)
        let mock = ResponseMock(url: urlRequest.url!, result: .success(responseData))
        RequestMock.add(mock: mock)

        let exp = XCTestExpectation(description: "test_loadImage")
        sut.download(url: imageURL).sink { sub in
            switch sub {
            
            case .finished:
                Log(.debug,"Finished")
            case .failure(let error):
//                Log(.debug,"Failure")
                XCTFail("Failed error: \(error)")

            }
        } receiveValue: { image in
            XCTAssertEqual(image.size, self.responseImage.size)
            exp.fulfill()

        }.store(in: &subscriptions)

        wait(for: [exp], timeout: 2)
    }
    
    func test_loadImageFail() throws {
        let imageURL = String("https://api.deezer.com/artist/64740/image")
        let responseData = try XCTUnwrap(responseImage.pngData())
        let httpErrorCode = 401
        let urlRequest = try EndPointAPI().linkUrlRequest(for: imageURL)
        let mock = try ResponseMock(url: urlRequest.url!, result: .success(responseData), httpCode: httpErrorCode)
        RequestMock.add(mock: mock)

        let exp = XCTestExpectation(description: "test_loadImageFail")
        sut.download(url: imageURL).sink { sub in
            switch sub {
            
            case .finished:
                Log(.debug,"Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.httpCode(httpErrorCode).localizedDescription)
                exp.fulfill()

            }
        } receiveValue: { image in


        }.store(in: &subscriptions)

        wait(for: [exp], timeout: 2)
    }
    
    func test_loadImageFailData() throws {
        let imageURL = String("https://api.deezer.com/artist/64740/image")
        let responseData = try XCTUnwrap(responseImage.pngData())
        let urlRequest = try EndPointAPI().linkUrlRequest(for: imageURL)
        let mock = try ResponseMock(url: urlRequest.url!, result: .success(try JSONEncoder().encode(responseData)))
        RequestMock.add(mock: mock)

        let exp = XCTestExpectation(description: "test_loadImageFail")
        sut.download(url: imageURL).sink { sub in
            switch sub {
            
            case .finished:
                Log(.debug,"Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.imageUrlError.localizedDescription)
                exp.fulfill()

            }
        } receiveValue: { image in


        }.store(in: &subscriptions)

        wait(for: [exp], timeout: 2)
    }
    
    func test_loadImageFailURL() throws {
        let imageURL = String("https://api.deezer.com/artist/64740/image")
        let responseData = try XCTUnwrap(responseImage.pngData())
        let httpErrorCode = 401
        let urlRequest = try EndPointAPI().linkUrlRequest(for: imageURL)
        let mock = try ResponseMock(url: urlRequest.url!, result: .success(responseData), httpCode: httpErrorCode)
        RequestMock.add(mock: mock)

        let exp = XCTestExpectation(description: "test_loadImageFail")
        sut.download(url: "wrong ulr").sink { sub in
            switch sub {
            
            case .finished:
                Log(.debug,"Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.invalidURL.localizedDescription)
                exp.fulfill()

            }
        } receiveValue: { image in


        }.store(in: &subscriptions)

        wait(for: [exp], timeout: 2)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
