//
//  ProductListViewModel.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import Foundation

@MainActor
final class ProductListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case success
        case empty
        case error(String)
    }
    
    private let service: ProductAPIService
    private let pageSize = 20
    
    private(set) var products: [Product] = []
    private(set) var state: State = .idle
    private(set) var isLoadingMore = false
    private(set) var canLoadMore = true
    private(set) var loadMoreError: String?
    
    var onChange: (() -> Void)?
    
    private var query = ""
    private var skip = 0
    private var requestID = 0
    
    private var firstPageTask: Task<Void, Never>?
    private var nextPageTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?
    
    init(service: ProductAPIService = ProductAPIService()) {
        self.service = service
    }
    
    func loadInitial() {
        loadFirstPage()
    }

    func retry() {
        loadFirstPage()
    }

    func refresh() {
        loadFirstPage()
    }

    func search(text: String) {
        debounceTask?.cancel()

        let newQuery = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        debounceTask = Task { [weak self] in
            do {
                try await Task.sleep(
                    nanoseconds: 350_000_000
                )
            } catch {
                return
            }

            guard let self else {
                return
            }

            self.query = newQuery
            self.loadFirstPage()
        }
    }

    func loadNextPageIfNeeded() {
        guard case .success = state else {
            return
        }

        guard canLoadMore, !isLoadingMore else {
            return
        }

        isLoadingMore = true
        loadMoreError = nil
        notify()

        let currentRequestID = requestID
        let currentQuery = query
        let currentSkip = skip

        nextPageTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let page = try await service.fetchProducts(
                    query: currentQuery,
                    skip: currentSkip,
                    limit: pageSize
                )

                guard
                    self.requestID == currentRequestID,
                    self.query == currentQuery
                else {
                    return
                }

                self.products.append(
                    contentsOf: page.products
                )

                self.skip = page.skip + page.products.count

                self.canLoadMore =
                    self.skip < page.total &&
                    !page.products.isEmpty

                self.isLoadingMore = false
                self.notify()
            } catch is CancellationError {
                return
            } catch {
                self.isLoadingMore = false
                self.loadMoreError =
                    error.localizedDescription
                self.notify()
            }
        }
    }

    private func loadFirstPage() {
        firstPageTask?.cancel()
        nextPageTask?.cancel()

        requestID += 1

        let currentRequestID = requestID
        let currentQuery = query

        products = []
        skip = 0
        canLoadMore = true
        isLoadingMore = false
        loadMoreError = nil
        state = .loading
        notify()

        firstPageTask = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let page = try await service.fetchProducts(
                    query: currentQuery,
                    skip: 0,
                    limit: pageSize
                )

                guard
                    self.requestID == currentRequestID,
                    self.query == currentQuery
                else {
                    return
                }

                self.products = page.products
                self.skip = page.skip + page.products.count

                self.canLoadMore =
                    self.skip < page.total &&
                    !page.products.isEmpty

                self.state = page.products.isEmpty
                    ? .empty
                    : .success

                self.notify()
            } catch is CancellationError {
                return
            } catch {
                guard self.requestID == currentRequestID else {
                    return
                }

                self.state = .error(
                    error.localizedDescription
                )

                self.notify()
            }
        }
    }

    private func notify() {
        onChange?()
    }
    
}
