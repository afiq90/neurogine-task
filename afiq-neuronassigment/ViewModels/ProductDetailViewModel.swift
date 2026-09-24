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
        case error(String)
    }
    
    private let service: ProductAPIService
    private let productID: Int
    
    private(set) var product: Product?
    private(set) var state: State = .idle
    
    var onChange: (() -> Void)?
    
    init(productID: Int, service: ProductAPIService = ProductAPIService()) {
        self.productID = productID
        self.service = service
    }
    
    func load() {
        state = .loading
        notify()
        
        Task {[weak self] in
            guard let self else {return}
            do {
                self.product = try await service.fetchProduct(id: productID)
                self.state = .success
                self.notify()
            } catch {
                self.state = .error(error.localizedDescription)
                self.notify()
            }
        }
    }
    
    func retry() {
        load()
    }
    
    private func notify() {
        onChange?()
    }
    
}
