//
//  ArtistsInteractorTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 08/10/2021.
//

import XCTest

import Combine

@testable import ArtistSearch

extension Publisher {
    func delayPublish() -> AnyPublisher<Output, Failure> {
        delay(for: .milliseconds(10), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}



final class MockedArtistsRepository: ArtistsRepository {
    
    var artistsResponse: Result<ArtistResultPage, Error> = .failure(APIError.unexpectedResponse)
    var albumsResponse: Result<AlbumResultPage, Error> = .failure(APIError.unexpectedResponse)
    var tracksResponse: Result<TracksResultPage, Error> = .failure(APIError.unexpectedResponse)

    
    func getArtists(for query: String) -> AnyPublisher<ArtistResultPage, Error> {
        artistsResponse.publisher.delayPublish()
    }
    
    func getArtistAlbums(with artistId: Int) -> AnyPublisher<AlbumResultPage, Error> {
        albumsResponse.publisher.delayPublish()
    }
    
    func getAlbumDetails(with albumId: Int) -> AnyPublisher<TracksResultPage, Error> {
        tracksResponse.publisher.delayPublish()

    }
    
    func getNextAlbums(with link: String) -> AnyPublisher<AlbumResultPage, Error> {
        albumsResponse.publisher.delayPublish()

    }
    
    func getNextArtists(with link: String) -> AnyPublisher<ArtistResultPage, Error> {
        artistsResponse.publisher.delayPublish()

    }
    

}

class ArtistsInteractorTests: XCTestCase {
    
    var mockedArtistsRepo: MockedArtistsRepository!
    var subscriptions = Set<AnyCancellable>()
    var sut: ArtistsInteractor!

    override func setUpWithError() throws {
        mockedArtistsRepo = MockedArtistsRepository()
        sut = ArtistsInteractorInstance(repository: mockedArtistsRepo)
    }

    override func tearDownWithError() throws {
        subscriptions = Set<AnyCancellable>()

    }
    
    func test_searchForArtistsWithQuery() {
        let data = ArtistResultPage.testData
        mockedArtistsRepo.artistsResponse = .success(data)
        let query = "Lenny"
        let nextString = ""
        let exp = XCTestExpectation(description: #function)

        sut.searchForArtists(with: query, with: nextString)
            .sink { sub in
                
            } receiveValue: { resultPage in
                XCTAssertEqual(resultPage, data)
                exp.fulfill()

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_searchForArtistsWithQueryFail() {
        mockedArtistsRepo.artistsResponse = .failure(APIError.unexpectedResponse)
        let query = "Lenny"
        let nextString = ""
        let exp = XCTestExpectation(description: #function)

        sut.searchForArtists(with: query, with: nextString)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    XCTAssertEqual((error as! APIError).localizedDescription, APIError.unexpectedResponse.localizedDescription)
                    exp.fulfill()

                }
            } receiveValue: { resultPage in

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    
    func test_searchForArtistsWithNextFail() {
        mockedArtistsRepo.artistsResponse = .failure(APIError.unexpectedResponse)
        let query = "Lenny"
        let nextString = "nextLink"
        let exp = XCTestExpectation(description: #function)

        sut.searchForArtists(with: query, with: nextString)
            .sink { sub in
                switch sub {
                
                case .finished:
                    print("finished")
                case .failure(let error):
                    XCTAssertEqual((error as! APIError).localizedDescription, APIError.unexpectedResponse.localizedDescription)
                    exp.fulfill()

                }
            } receiveValue: { resultPage in

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_searchForArtistsWithNextLink() {
        let data = ArtistResultPage.testData
        mockedArtistsRepo.artistsResponse = .success(data)
        let query = "Lenny"
        let nextString = "nextLink"
        let exp = XCTestExpectation(description: #function)

        sut.searchForArtists(with: query, with: nextString)
            .sink { sub in
                
            } receiveValue: { resultPage in
                XCTAssertEqual(resultPage, data)
                exp.fulfill()

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    
    func test_loadAlbums() {
        let data = AlbumResultPage.testData
        mockedArtistsRepo.albumsResponse = .success(data)
        let artistId = 1
        let exp = XCTestExpectation(description: #function)
        
        sut.loadAlbums(of: artistId, with: "").sink { sub in
                
            } receiveValue: { resultPage in
                XCTAssertEqual(resultPage, data)
                exp.fulfill()

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadAlbumsWithNext() {
        let data = AlbumResultPage.testData
        mockedArtistsRepo.albumsResponse = .success(data)
        let artistId = 1
        let exp = XCTestExpectation(description: #function)
        
        sut.loadAlbums(of: artistId, with: "someLink").sink { sub in
                
            } receiveValue: { resultPage in
                XCTAssertEqual(resultPage, data)
                exp.fulfill()

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadAlbumsFail() {
        mockedArtistsRepo.albumsResponse = .failure(APIError.unexpectedResponse)
        let artistId = 1
        let exp = XCTestExpectation(description: #function)
        
        sut.loadAlbums(of: artistId, with: "").sink { sub in
            
            switch sub {
                
            case .finished:
                print("finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.unexpectedResponse.localizedDescription)
                exp.fulfill()

            }

            } receiveValue: { resultPage in

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadAlbumsWithNextFail() {
        mockedArtistsRepo.albumsResponse = .failure(APIError.unexpectedResponse)
        let artistId = 1
        let exp = XCTestExpectation(description: #function)
        
        sut.loadAlbums(of: artistId, with: "nextLink").sink { sub in
            
            switch sub {
                
            case .finished:
                print("finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.unexpectedResponse.localizedDescription)
                exp.fulfill()

            }

            } receiveValue: { resultPage in

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    
    func test_loadAlbumsDetails() {
        let data = TracksResultPage.testData
        mockedArtistsRepo.tracksResponse = .success(data)
        let albumId = 1
        let exp = XCTestExpectation(description: #function)
        
        sut.loadDetails(of: albumId).sink { sub in
                
            } receiveValue: { resultPage in
                XCTAssertEqual(resultPage, data)
                exp.fulfill()

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadAlbumsDetailsFail() {
        mockedArtistsRepo.tracksResponse = .failure(APIError.unexpectedResponse)
        let albumId = 1
        let exp = XCTestExpectation(description: #function)
        
        sut.loadDetails(of: albumId).sink { sub in
            
            switch sub {
                
            case .finished:
                print("finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.unexpectedResponse.localizedDescription)
                exp.fulfill()

            }
            
            } receiveValue: { resultPage in

            }
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }




}
