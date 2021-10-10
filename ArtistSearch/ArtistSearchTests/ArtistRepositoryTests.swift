//
//  ArtistSearchTests.swift
//  ArtistSearchTests
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import XCTest
import Combine

@testable import ArtistSearch

class ArtistRepositoryTests: XCTestCase {
    
    private var sut: ArtistsRepositoryInstance!
    private var subscriptions = Set<AnyCancellable>()
    private var mockBaseUrl: String = "test.com"

    override func setUpWithError() throws {
        subscriptions = Set<AnyCancellable>()
        sut = ArtistsRepositoryInstance(session: URLSession.mockedResponsesOnly, baseUrl: mockBaseUrl)


    }

    override func tearDownWithError() throws {
        RequestMock.removeAllMocks()

        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_artistsSearch() throws {
        let mockData = ArtistResultPage.testData
        let query = "Lenny"
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getArtisRequest(with: query).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsSearch")
        sut.getArtists(for: "Lenny").sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error)")
            }

        }, receiveValue: { resultPage in
            XCTAssertEqual(resultPage, mockData)
            exp.fulfill()

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsSearchFail() throws {
        let mockData = ArtistResultPage.testData
        let query = "Lenny"
        let httpErrorCode = 401
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getArtisRequest(with: query).url!
        try mock(url, result: .success(mockData),httpCode: httpErrorCode)
        let exp = XCTestExpectation(description: "test_artistsSearchFail")
        sut.getArtists(for: query).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error.localizedDescription)")

                XCTAssertEqual((error as! APIError).localizedDescription, APIError.httpCode(httpErrorCode).localizedDescription)
                exp.fulfill()

            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsSearchCatchFail() throws {
        sut = ArtistsRepositoryInstance(session: URLSession.mockedResponsesOnly, baseUrl: "failed url")

        let mockData = ArtistResultPage.testData
        let query = "Lenny"
        let httpErrorCode = 401
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getArtisRequest(with: query).url!
        try mock(url, result: .success(mockData),httpCode: httpErrorCode)
        let exp = XCTestExpectation(description: "test_artistsSearchFail")
        sut.getArtists(for: query).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error.localizedDescription)")

                XCTAssertEqual((error as! APIError).localizedDescription, APIError.invalidURL.localizedDescription)
                exp.fulfill()

            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsNextSearch() throws {
        let mockData = ArtistResultPage.testData
        let nextLink = "\(mockBaseUrl)/artist/330314/albums?index=25"
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getNextAlbumRequest(for: nextLink).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsNextSearch")
        sut.getNextArtists(with: nextLink).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error)")
            }

        }, receiveValue: { resultPage in
            XCTAssertEqual(resultPage, mockData)
            exp.fulfill()

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsNextSearchFail() throws {
        let mockData = ArtistResultPage.testData
        let nextLink = "\(mockBaseUrl)/artist/330314/albums?index=25"
        let httpErrorCode = 401
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getNextAlbumRequest(for: nextLink).url!
        try mock(url, result: .success(mockData),httpCode: httpErrorCode)
        let exp = XCTestExpectation(description: "test_artistsNextSearchFail")
        sut.getNextArtists(with: nextLink).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error.localizedDescription)")

                XCTAssertEqual((error as! APIError).localizedDescription, APIError.httpCode(httpErrorCode).localizedDescription)
                exp.fulfill()

            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsNextSearchCatchFail() throws {
        let mockData = ArtistResultPage.testData
        let nextLink = "\(mockBaseUrl)/artist/330314/albums?index=25"
        let wrongNextLink = "failed url"

        let url = try EndPointAPI(baseUrl: mockBaseUrl).getNextAlbumRequest(for: nextLink).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsNextSearchCatchFail")
        sut.getNextArtists(with: wrongNextLink).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error.localizedDescription)")

                XCTAssertEqual((error as! APIError).localizedDescription, APIError.invalidURL.localizedDescription)
                exp.fulfill()

            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    
    func test_artistsAlbums() throws {
        let mockData = AlbumResultPage.testData
        let albumID = 1
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getAlbumRequest(for: albumID).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsAlbums")
        sut.getArtistAlbums(with: albumID).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error)")
            }

        }, receiveValue: { resultPage in
            XCTAssertEqual(resultPage, mockData)
            exp.fulfill()

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsAlbumsFail() throws {
        let mockData = AlbumResultPage.testData
        let albumID = 1
        let httpErrorCode = 401

        let url = try EndPointAPI(baseUrl: mockBaseUrl).getAlbumRequest(for: albumID).url!
        try mock(url, result: .success(mockData), httpCode: httpErrorCode)
        let exp = XCTestExpectation(description: "test_artistsAlbumsFail")
        sut.getArtistAlbums(with: albumID).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.httpCode(httpErrorCode).localizedDescription)
                exp.fulfill()

                print("error = \(error)")
            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsAlbumsCatchFail() throws {
        sut = ArtistsRepositoryInstance(session: URLSession.mockedResponsesOnly, baseUrl: "failed url")

        let mockData = AlbumResultPage.testData
        let albumID = 1

        let url = try EndPointAPI(baseUrl: mockBaseUrl).getAlbumRequest(for: albumID).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsAlbumsFail")
        sut.getArtistAlbums(with: albumID).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.invalidURL.localizedDescription)
                exp.fulfill()

                print("error = \(error)")
            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsNextAlbums() throws {
        let mockData = AlbumResultPage.testData
        let nextLink = "\(mockBaseUrl)/artist/330314/albums?index=25"

        let url = try EndPointAPI(baseUrl: mockBaseUrl).getNextAlbumRequest(for: nextLink).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsNextAlbums")
        sut.getNextAlbums(with: nextLink).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error)")
            }

        }, receiveValue: { resultPage in
            XCTAssertEqual(resultPage, mockData)
            exp.fulfill()

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsNextAlbumsFail() throws {
        let httpErrorCode = 401

        let mockData = AlbumResultPage.testData
        let nextLink = "\(mockBaseUrl)/artist/330314/albums?index=25"
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getNextAlbumRequest(for: nextLink).url!
        try mock(url, result: .success(mockData), httpCode: httpErrorCode)
        let exp = XCTestExpectation(description: "test_artistsNextAlbumsFail")
        sut.getNextAlbums(with: nextLink).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error)")
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.httpCode(httpErrorCode).localizedDescription)
                exp.fulfill()

            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    

    func test_artistsNextAlbumsCatchFail() throws {

        let mockData = AlbumResultPage.testData
        let wrongLextLink = "failed url"
        let correctLink = "https://api.deezer.com/artist/330314/albums?index=25"
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getNextAlbumRequest(for: correctLink).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsNextAlbumsCatchFail")
        sut.getNextAlbums(with: wrongLextLink).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.invalidURL.localizedDescription)
                exp.fulfill()
                print("error = \(error)")

            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    
    
    func test_artistsAlbumsDetails() throws {
        let mockData = TracksResultPage.testData
        let albumID = 1
        let url = try EndPointAPI(baseUrl: mockBaseUrl).getAlbumDetailsRequest(for: albumID).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsAlbumsDetails")
        sut.getAlbumDetails(with: albumID).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error = \(error)")
            }

        }, receiveValue: { resultPage in
            XCTAssertEqual(resultPage, mockData)
            exp.fulfill()

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsAlbumsDetailsFail() throws {
        let mockData = TracksResultPage.testData
        let albumID = 1
        let httpErrorCode = 401

        let url = try EndPointAPI(baseUrl: mockBaseUrl).getAlbumDetailsRequest(for: albumID).url!
        try mock(url, result: .success(mockData), httpCode: httpErrorCode)
        let exp = XCTestExpectation(description: "test_artistsAlbumsDetailsFail")
        sut.getAlbumDetails(with: albumID).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.httpCode(httpErrorCode).localizedDescription)
                exp.fulfill()

                print("error = \(error)")
            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    func test_artistsAlbumsDetailsCatchFail() throws {
        sut = ArtistsRepositoryInstance(session: URLSession.mockedResponsesOnly, baseUrl: "failed url")

        let mockData = TracksResultPage.testData
        let albumID = 1

        let url = try EndPointAPI(baseUrl: mockBaseUrl).getAlbumDetailsRequest(for: albumID).url!
        try mock(url, result: .success(mockData))
        let exp = XCTestExpectation(description: "test_artistsAlbumsDetailsCatchFail")
        sut.getAlbumDetails(with: albumID).sink(receiveCompletion: { sub in
            switch sub {
            
            case .finished:
                print("Finished")
            case .failure(let error):
                XCTAssertEqual((error as! APIError).localizedDescription, APIError.invalidURL.localizedDescription)
                exp.fulfill()

                print("error = \(error)")
            }

        }, receiveValue: { resultPage in

        })
        .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: - Helper
    
    private func mock<T>(_ url: URL, result: Result<T, Swift.Error>,
                         httpCode: Int = 200) throws where T: Encodable {
        let responseMock = try ResponseMock(url: url, result: result, httpCode: httpCode, headers: [:], loadingTime: 0.1)
        RequestMock.add(mock: responseMock)
    }

}
