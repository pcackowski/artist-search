//
//  ArtistsViewModelTest.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 08/10/2021.
//

import XCTest

import Combine

@testable import ArtistSearch


class ArtistsViewModelTest: XCTestCase {

    var sut: ArtistsViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = ArtistsViewModel(container: DIContainer(interactors: DIContainer.Interactors.stub))
    }

    override func tearDownWithError() throws {
        subscriptions = Set<AnyCancellable>()
    }
    
    func test_fetchAlbums() {
        let exp = XCTestExpectation(description: #function)

        Future<Void, Never> { completion in
            self.sut.fetchForArtists()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(()))
            }
        }.eraseToAnyPublisher().sink { () in
            XCTAssertEqual(ArtistResultPage.testData.data, self.sut.artists)
            exp.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)


    }
    
//    func test_setupSearch() {
//        let exp = XCTestExpectation(description: #function)
//        let query = "query"
// 
//        self.sut.$searchText.sink { _ in
//            XCTAssertEqual(query, self.sut.getCurrentSearchText())
//            XCTAssertTrue(self.sut.artists.count == 0)
//            XCTAssertTrue(self.sut.mainViewmode == .search)
//            exp.fulfill()
//        }
//        .store(in: &subscriptions)
//        self.sut.searchText = query
//        self.sut.$searchText
//            .delayPublish().sink { string in
//                
//            }
//            .store(in: &subscriptions)
//
//
//        wait(for: [exp], timeout: 2)
//
//
//    }

}
