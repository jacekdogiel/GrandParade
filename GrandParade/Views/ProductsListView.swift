//
//  ProductsListView.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import SwiftUI

struct ProductsListView: View {
    @ObservedObject var viewModel: ProductsListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        VStack(alignment: .leading) {
                            Text(product.name ?? "")
                                .padding(.bottom, 5)
                            Text("Price: " + (product.priceString ?? ""))
                                .padding(.bottom, 5)
                            AsyncImage(
                                url: URL(string: product.imageUrlString ?? ""),
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity, maxHeight: 150)
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                        }
                    }
                }
            }
            .toolbar {
                Button(action: {
                    viewModel.fetchProductsWith(refresh: true)
                }) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .navigationTitle("Products")
        }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let productService = ProductService()
        ProductsListView(viewModel: ProductsListViewModel(productService: productService))
    }
}
