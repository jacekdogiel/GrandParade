//
//  MockURLProtocol.swift
//  GrandParadeTests
//
//  Created by Jacek Dogiel on 08/03/2023.
//

import Foundation


class MockURLProtocol: URLProtocol {
    
    static var stubResponseData: Data?
    static var statusCode: Int = 200
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let headers = ["Content-Type": "application/json"]
        let response = HTTPURLResponse(url: self.request.url!, statusCode: MockURLProtocol.statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
        
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
