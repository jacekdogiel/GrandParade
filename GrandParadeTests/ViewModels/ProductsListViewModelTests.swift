//
//  ProductsListViewModelTests.swift
//  GrandParadeTests
//
//  Created by Jacek Dogiel on 08/03/2023.
//

import XCTest
@testable import GrandParade

class ProductsListViewModelTests: XCTestCase {
    
    var mockProductService: MockProductService!
    var sut: ProductsListViewModel!

    override func setUp() async throws {
        mockProductService = MockProductService()
        sut = await ProductsListViewModel(productService: mockProductService)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockProductService = nil
        sut = nil
    }
    
    func testProductsListViewModel_WhenRefreshFunctionIsCalled_ShouldCallFetchProducts() async {
        // Arrange

        // Act
        await sut.refreshProducts()
        
        // Assert
        XCTAssertTrue(mockProductService.isFetchMethodCalled, "The fetch method was not called in the ProductService class")
    }
}
