//
//  ProductServiceTests.swift
//  GrandParadeTests
//
//  Created by Jacek Dogiel on 08/03/2023.
//

import XCTest
@testable import GrandParade

class ProductServiceTests: XCTestCase {
    
    var sut:ProductService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = ProductService(urlSession: urlSession)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
        MockURLProtocol.statusCode = 200
    }
    
    
    func testProductService_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        
        // Arrange
        MockURLProtocol.stubResponseData =  MockProductResponse.jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Product Service Response Expectation")
        
        // Act
        sut.fetchProducts(refresh: true) { response in
            switch response {
            case .success(let products):
                // Assert
                XCTAssertEqual(products.count, 3)
                XCTAssertEqual(products.first?.name, "Product1")
                expectation.fulfill()
            case .failure(_):
                XCTFail()
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testProductService_WhenURLRequestFailsWithError_ReturnsFailure() {
        
        // Arrange
        let expectation = self.expectation(description: "A failed Request expectation")
        MockURLProtocol.error = NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        
        // Act
        sut.fetchProducts(refresh: true) { response in
            switch response {
            case .success(let products):
                XCTAssertFalse(products.count > 0)
                expectation.fulfill()
            case .failure(_):
                // Assert
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testProductService_WhenGivenInvalidResponse_ReturnsFailure() {
        
        // Arrange
        let jsonString = "{\"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Product Service Failure Response Expectation")
        
        // Act
        sut.fetchProducts(refresh: true) { response in
            switch response {
            case .success(let products):
                XCTAssertFalse(products.count > 0)
                expectation.fulfill()
            case .failure(_):
                // Assert
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testProductService_WhenGivenResponseWithErrorStatusCode_ReturnsFailure() {
        
        // Arrange
        MockURLProtocol.stubResponseData =  MockProductResponse.jsonString.data(using: .utf8)
        MockURLProtocol.statusCode = 400
        
        let expectation = self.expectation(description: "Product Service Failure Response Expectation")
        
        // Act
        sut.fetchProducts(refresh: true) { response in
            switch response {
            case .success(let products):
                XCTAssertFalse(products.count > 0)
                expectation.fulfill()
            case .failure(_):
                // Assert
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testProductService_WhenEmptyURLStringProvided_ReturnsError() {
        // Arrange
        let expectation = self.expectation(description: "An empty request URL string expectation")
        
        sut = ProductService(urlString: "")
        
        // Act
        sut.fetchProducts(refresh: true) { response in
            switch response {
            case .success(let products):
                XCTAssertFalse(products.count > 0)
                expectation.fulfill()
            case .failure(_):
                // Assert
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 2)
    }
}

