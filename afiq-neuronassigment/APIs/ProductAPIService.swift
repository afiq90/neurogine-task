//
//  ProductAPIService.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalidUrl
    case invalidResponse
    case serverError(Int)
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid request url"
        case .invalidResponse:
            return "Invalud server response"
        case .serverError(let code):
            return "Server error \(code)"
        case .decodingError:
            return "Could not read the server response"
        case .networkError:
            return "Network error, Please check internet connection"
        }
    }
}

final class ProductAPIService {
    private let baseURL = URL(string: "https://dummyjson.com")!
    
    func fetchProducts(query: String, skip: Int, limit: Int) async throws -> ProductPage {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let path = trimmedQuery.isEmpty ? "products" : "products/search"
        var url = baseURL
        path.split(separator: "/").forEach {
            url = url.appendingPathComponent(String($0))
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidUrl
        }
        
        var queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip))
        ]
        
        if !trimmedQuery.isEmpty {
            queryItems.append(URLQueryItem(name: "q", value: trimmedQuery))
        }
        
        components.queryItems = queryItems
        
        guard let requestURL = components.url else {
            throw APIError.invalidUrl
        }
        
        return try await request(url: requestURL, type: ProductPage.self)
    }
    
    func fetchProduct(id: Int) async throws -> Product {
        let url = baseURL.appendingPathComponent("products/\(id)")
        
        return try await request(url: url, type: Product.self)
    }
    
    private func request<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (Data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
}
