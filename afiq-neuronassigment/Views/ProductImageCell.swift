//
//  ProductImageCell.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import UIKit

final class ProductImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = UIImage(systemName: "photo")
    }
    
    func configure(with imageURL: String?) {
        imageView.image = UIImage(systemName: "photo")
        guard
            let imageURL,
            let url = URL(string: imageURL)
        else {
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {return}
                await MainActor.run{
                    self.imageView.image = image
                }
            } catch{
                
            }
        }
    }
}
