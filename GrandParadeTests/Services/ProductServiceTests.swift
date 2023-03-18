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
    
    
    func testProductService_WhenGivenSuccessfullResponse_ReturnsSuccess() async {
        
        // Arrange
        MockURLProtocol.stubResponseData =  MockProductResponse.jsonString.data(using: .utf8)
        
        // Act
        do {
            let products = try await sut.fetchProducts(refresh: true)
            XCTAssertEqual(products.count, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testProductService_WhenURLRequestFailsWithError_ReturnsFailure() async {
        
        // Arrange
        let description = "Invalid HTTP response"
        MockURLProtocol.error = NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
        
        // Act
        do {
            let products = try await sut.fetchProducts(refresh: true)
            XCTAssertFalse(products.count > 0)
        } catch {
            XCTAssertTrue(error.localizedDescription == description)
        }
    }
    
    func testProductService_WhenGivenInvalidResponse_ReturnsFailure() async {
        
        // Arrange
        let jsonString = "{\"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)
        
        // Act
        do {
            let products = try await sut.fetchProducts(refresh: true)
            XCTAssertFalse(products.count > 0)
        } catch {
            //
        }
    }
    
    func testProductService_WhenGivenResponseWithErrorStatusCode_ReturnsFailure() async {
        
        // Arrange
        MockURLProtocol.stubResponseData =  MockProductResponse.jsonString.data(using: .utf8)
        MockURLProtocol.statusCode = 400
                
        // Act
        do {
            let products = try await sut.fetchProducts(refresh: true)
            XCTAssertFalse(products.count > 0)
        } catch {
            XCTAssertEqual(error.localizedDescription, "Invalid HTTP response")
        }
    }
    
    func testProductService_WhenEmptyURLStringProvided_ReturnsError() async {
        // Arrange
        sut = ProductService(urlString: "")
        
        // Act
        do {
            let products = try await sut.fetchProducts(refresh: true)
            XCTAssertFalse(products.count > 0)
        } catch {
            XCTAssertEqual(error.localizedDescription, "Invalid URL")
        }
    }
}

