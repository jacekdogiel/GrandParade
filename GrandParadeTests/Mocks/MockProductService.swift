//
//  MockProductService.swift
//  GrandParadeTests
//
//  Created by Jacek Dogiel on 08/03/2023.
//

import Foundation
@testable import GrandParade


class MockProductService: ProductServicing {
    var isFetchMethodCalled: Bool = false
    
    func fetchProducts(refresh: Bool, completion: @escaping (Result<[GrandParade.Product], Error>) -> Void) {
        isFetchMethodCalled = true
        completion(.success([]))
    }
}
