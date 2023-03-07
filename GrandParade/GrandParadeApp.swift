//
//  GrandParadeApp.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import SwiftUI

@main
struct GrandParadeApp: App {
    var body: some Scene {
        WindowGroup {
            let productService = ProductService()
            let viewModel = ProductsListViewModel(productService: productService)
            ProductsListView(viewModel: viewModel)
        }
    }
}
