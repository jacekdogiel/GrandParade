//
//  ProductsListViewModel.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import Foundation

@MainActor
class ProductsListViewModel: ObservableObject {
    private var productService: ProductServicing
    @Published var products = [Product]()
    
    init(productService: ProductServicing) {
        self.productService = productService
    }
    
    func refreshProducts() async {
        await fetchProductsWith(refresh: true)
    }
    
    func fetchProductsWith(refresh: Bool) async {
        do {
            products = try await productService.fetchProducts(refresh: refresh)
        } catch {
            print(error.localizedDescription)
        }
    }
}
