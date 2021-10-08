//
//  RequestMock.swift
//  ArtistSearchUITests
//
//  Created by Przemyslaw Cackowski on 08/10/2021.
//

import Foundation


struct ResponseMock {
    let url: URL
    let result: Result<Data, Swift.Error>
    let httpCode: Int
    let headers: [String: String]
    let loadingTime: TimeInterval
    let customResponse: URLResponse?
    
    init<T>(url: URL,
            result: Result<T, Swift.Error>,
            httpCode: Int = 200,
            headers: [String: String] = ["Content-Type": "application/json"],
            loadingTime: TimeInterval = 0.1
    ) throws where T: Encodable {

        self.url = url
        switch result {
        case let .success(value):
            self.result = .success(try JSONEncoder().encode(value))
        case let .failure(error):
            self.result = .failure(error)
        }
        self.httpCode = httpCode
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }
}

final class RequestMock: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return mock(for: request) != nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // swiftlint:disable identifier_name
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    // swiftlint:enable identifier_name
        return false
    }

    override func startLoading() {
        if let mock = RequestMock.mock(for: request),
            let url = request.url,
            let response = mock.customResponse ??
                HTTPURLResponse(url: url,
                statusCode: mock.httpCode,
                httpVersion: "HTTP/1.1",
                headerFields: mock.headers) {
            DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
                guard let self = self else { return }
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                switch mock.result {
                case let .success(data):
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)
                case let .failure(error):
                    let failure = NSError(domain: NSURLErrorDomain, code: 1,
                                          userInfo: [NSUnderlyingErrorKey: error])
                    self.client?.urlProtocol(self, didFailWithError: failure)
                }
            }
        }
    }

    override func stopLoading() { }
}

extension URLSession {
    static var mockedResponsesOnly: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [RequestMock.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
}

extension RequestMock {
    static private var requestMocks: [ResponseMock] = []
    
    static func add(mock: ResponseMock) {
        requestMocks.append(mock)
    }
    
    static func removeAllMocks() {
        requestMocks.removeAll()
    }
    
    static private func mock(for request: URLRequest) -> ResponseMock? {
        return requestMocks.first { $0.url == request.url }
    }
}
