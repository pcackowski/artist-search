//
//  ImageViewModelTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 11/10/2021.
//

import XCTest
import Combine
import SwiftUI

@testable import ArtistSearch

class ImageViewModelTests: XCTestCase {
    
    var sut: ImageViewModel!
    var subscriptions = Set<AnyCancellable>()
    let testImage = Image(systemName: "magnifyingglass")
    let imageURL = String("fail")

    override func setUpWithError() throws {
        sut = ImageViewModel(imageURL: imageURL, container: DIContainer.init(interactors: DIContainer.Interactors.stub), image: .constant(testImage))
    }

    override func tearDownWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }

    func test_fetchImageFail() {
        let exp = XCTestExpectation(description: #function)

        Future<Void, Error> { completion in
            self.sut.loadImage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(()))
            }
        }.eraseToAnyPublisher().sink(receiveCompletion: { sub in
        }, receiveValue: { () in
            XCTAssertEqual(self.sut.getImage(), Image(systemName: "magnifyingglass"))
            exp.fulfill()


        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)


    }
    
    func test_fetchImage() {
        let exp = XCTestExpectation(description: #function)

        Future<Void, Never> { completion in
            self.sut.loadImage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(()))
            }
        }.eraseToAnyPublisher().sink { () in
            XCTAssertEqual(self.testImage, self.sut.getImage())
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)


    }

}
