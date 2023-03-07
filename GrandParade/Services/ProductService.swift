//
//  ProductService.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import Foundation

protocol ProductServicing {
    func fetchProducts(refresh: Bool, completion: @escaping (Result<[Product], Error>) -> Void)
}

class ProductService: ProductServicing {
    func fetchProducts(refresh: Bool = false, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: Constants.productsURLString) else {
            completion(.failure(NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var urlRequest = URLRequest(url: url)

        urlRequest.cachePolicy = refresh ? .reloadIgnoringLocalCacheData : .returnCacheDataDontLoad
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(NSError(domain: "ProductService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: jsonData)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
