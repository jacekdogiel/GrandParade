//
//  Product.swift
//  GrandParade
//
//  Created by Jacek Dogiel on 07/03/2023.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String?
    let name: String?
    let price: Decimal?
    let description: String?
    let imageUrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case imageUrlString = "image_url"
    }
}

extension Product {
    var priceString: String? {
        guard let price = price else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: price as NSDecimalNumber)
    }
}
