//
//  AlbumDetailsViewModelTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 11/10/2021.
//

import XCTest

import Combine

@testable import ArtistSearch
class AlbumDetailsViewModelTests: XCTestCase {

    var sut: AlbumDetailsViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        sut = AlbumDetailsViewModel(container: DIContainer(interactors: DIContainer.Interactors.stub))
    }

    override func tearDownWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }

    func test_fetchAlbumDetails() {
        let exp = XCTestExpectation(description: #function)

        Future<Void, Never> { completion in
            self.sut.fetchForAlbumDetails(with: -1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(()))
            }
        }.eraseToAnyPublisher().sink { () in
            XCTAssertEqual(TracksResultPage.testData.data, self.sut.tracks)
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)


    }

}
