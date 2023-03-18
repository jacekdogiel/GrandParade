//
//  ProductService.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import Foundation

protocol ProductServicing {
    func fetchProducts(refresh: Bool) async throws -> [Product]
}

class ProductService: ProductServicing {
    private var urlSession: URLSession
    private var urlString: String
    
    init(urlString: String = Constants.productsURLString, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func fetchProducts(refresh: Bool = false) async throws -> [Product] {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var urlRequest = URLRequest(url: url)

        urlRequest.cachePolicy = refresh ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }
        
        print(httpResponse.statusCode)
        
        let decoder = JSONDecoder()
        let products = try decoder.decode([Product].self, from: data)
        return products
    }
}
