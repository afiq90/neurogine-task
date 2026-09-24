//
//  ProductListViewModel.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import Foundation

@MainActor
final class ProductDetailViewModel {
    enum State: Equatable {
        case idle
        case loading
        case success
        case empty
        case error(String)
    }
    
    private let service: ProductAPIService
    private let productID: Int
    
    init(productID: Int, service: ProductAPIService = ProductAPIService()) {
        self.productID = productID
        self.service = service
    }
    
    
}
