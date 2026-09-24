//
//  ProductCell.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import Foundation
import UIKit

final class ProductCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        priceLabel.text = nil
        productImageView.image = UIImage(systemName: "photo")
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = String(format: "%.2f", product.price)
        productImageView.image = UIImage(systemName: "photo")
        
        guard let url = URL(string: product.thumbnail) else {
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                print("image url: \(url), image data: \(data)")
                
                guard let image = UIImage(data: data) else {return}
                
                await MainActor.run {
                    self.productImageView.image = image
                }
            } catch {
                
            }
        }
    }
}
