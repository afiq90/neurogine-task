//
//  ProductAPIServiceTests.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import XCTest
import Foundation
@testable import afiq_neuronassigment

final class ProductAPIServiceTests: XCTestCase {
    func testProductPageDecodes() throws {
        let json = """
        {
          "products": [
            {
              "id": 1,
              "title": "Phone",
              "description": "iPhone Duo 2026",
              "price": 9999.99,
              "rating": 4.9,
              "thumbnail": "https://example.com/image.jpg",
              "images": ["https://example.com/image.jpg"]
            }
          ],
          "total": 1,
          "skip": 0,
          "limit": 20
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder().decode(
            ProductPage.self,
            from: data
        )

        XCTAssertEqual(result.products.count, 1)
        XCTAssertEqual(
            result.products.first?.title,
            "Phone"
        )
    }
}

