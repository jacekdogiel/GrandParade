//
//  ProductsListViewModel.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import Foundation

class ProductsListViewModel: ObservableObject {
    private var productService: ProductServicing
    @Published var products = [Product]()
    
    init(productService: ProductServicing) {
        self.productService = productService
        self.fetchProductsWith(refresh: false)
    }
    
    func refreshProducts() {
        fetchProductsWith(refresh: true)
    }
    
    private func fetchProductsWith(refresh: Bool) {
        productService.fetchProducts(refresh: refresh) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let products):
                    self.products = products
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
