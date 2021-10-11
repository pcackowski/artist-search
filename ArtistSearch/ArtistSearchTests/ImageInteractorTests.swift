//
//  ImageInteractorTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 10/10/2021.
//

import XCTest
import Combine

@testable import ArtistSearch
final class MockedImageRepository: ImageRepository {
    func download(url: String) -> AnyPublisher<UIImage, Error> {
        downloadResponse.publisher.delayPublish()
    }
    
    var downloadResponse: Result<UIImage, Error> = .failure(APIError.unexpectedResponse)

}

class ImageInteractorTests: XCTestCase {

    var mockedImageRepo: MockedImageRepository!
    var subscriptions = Set<AnyCancellable>()
    var sut: ImagesInteractor!
    private lazy var responseImage = UIColor.gray.image(CGSize(width: 10, height: 10))

    override func setUpWithError() throws {
        mockedImageRepo = MockedImageRepository()
        sut = ImagesInteractorInstance(imageRepository: mockedImageRepo) 
    }


    override func tearDownWithError() throws {
        subscriptions = Set<AnyCancellable>()
        ImageCache.shared.clearAll()
    }

    func test_getImageTEst() {
        mockedImageRepo.downloadResponse = .success(responseImage)
        let exp = XCTestExpectation(description: #function)
        let imageURL = String("https://api.deezer.com/artist/64740/image")

        sut.load(url: imageURL).sink { sub in
                
            } receiveValue: { resultData in
                XCTAssertEqual(resultData.size, self.responseImage.size)
                exp.fulfill()

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_getImageFromCacheTest() {
        mockedImageRepo.downloadResponse = .success(responseImage)
        let exp = XCTestExpectation(description: #function)
        let imageURL = String("https://api.deezer.com/artist/64740/image")

        var objectFromCache = ImageCache.shared.image(url: imageURL)
        XCTAssertNil(objectFromCache)
        sut.load(url: imageURL).sink { sub in
                
            } receiveValue: { resultData in
                objectFromCache = ImageCache.shared.image(url: imageURL)
                XCTAssertNotNil(objectFromCache)
                exp.fulfill()
            }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    
    func test_getImageViaCacheTEst() {
        mockedImageRepo.downloadResponse = .success(responseImage)
        let exp = XCTestExpectation(description: #function)
        let imageURL = String("https://api.deezer.com/artist/64740/image")

        var objectFromCache = ImageCache.shared.image(url: imageURL)
        XCTAssertNil(objectFromCache)

        sut.load(url: imageURL).flatMap { image in
            return self.sut.load(url: imageURL)
        }.sink { sub in
            
        } receiveValue: { image in
            XCTAssertEqual(image.size, self.responseImage.size)
            objectFromCache = ImageCache.shared.image(url: imageURL)
            XCTAssertNotNil(objectFromCache)

            exp.fulfill()

        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }

}
