//
//  ProductDetailView.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.name ?? "")
                .padding(.bottom, 5)
                .padding(.horizontal, 16)
            Text("Price: " + (product.priceString ?? ""))
                .padding(.bottom, 5)
                .padding(.horizontal, 16)
            Text(product.description ?? "")
                .padding(.bottom, 5)
                .padding(.horizontal, 16)
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
            Spacer()
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(id: "1", name: "Product 1", price: 12.99, description: "", imageUrlString: "")
        ProductDetailView(product: product)
    }
}
