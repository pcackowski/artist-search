//
//  AlbumViewModelTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 08/10/2021.
//

import XCTest

import Combine

@testable import ArtistSearch


class AlbumViewModelTests: XCTestCase {

    var sut: AlbumsViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = AlbumsViewModel(container: DIContainer(interactors: DIContainer.Interactors.stub), currentArtist: ArtistDTO.testData[0])
    }

    override func tearDownWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }
    
    func test_fetchAlbums() {
        let exp = XCTestExpectation(description: #function)

        Future<Void, Never> { completion in
            self.sut.fetchForAlbums()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(()))
            }
        }.eraseToAnyPublisher().sink { () in
            XCTAssertEqual(AlbumResultPage.testData.data, self.sut.currentArtistAlbums)
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)


    }

}
