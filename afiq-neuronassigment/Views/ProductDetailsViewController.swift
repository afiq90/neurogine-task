//
//  ProductDetailsViewController.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import UIKit

class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var productStackView: UIStackView!
    
    var productID: Int!
    private var viewModel: ProductDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        
        viewModel = ProductDetailViewModel(productID: productID)
        viewModel.onChange = { [weak self] in
            self?.render()
        }
        
        viewModel.load()
    }
    
    private func render() {
        switch viewModel.state {
        case .loading:
            errorView.isHidden = true
            productStackView.isHidden = true
            loadingView.isHidden = false
            loadingView.startAnimating()
        case .success:
            guard let product = viewModel.product else {return}
            
            loadingView.stopAnimating()
            loadingView.isHidden = true
            errorView.isHidden = true
            productStackView.isHidden = false
            titleLabel.text = product.title
            priceLabel.text = String(format: "$%.2f", product.price)
            ratingLabel.text = String(format: "Rating: %.1f / 5", product.rating)
            descriptionLabel.text = product.description
            imagesCollectionView.reloadData()
        case .error(let errMsg):
            loadingView.stopAnimating()
            loadingView.isHidden = true
            productStackView.isHidden = true
            errorLabel.text = errMsg
            errorView.isHidden = false
        case .idle:
            loadingView.stopAnimating()
            loadingView.isHidden = true
            errorView.isHidden = true
            productStackView.isHidden = true
        }
    }
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        print("retry button tapped on productdetailsviewcontroller")
        viewModel.retry()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
        let imageURL = viewModel.product?.images[indexPath.row]
        cell.configure(with: imageURL)
        
        return cell
    }
    
    
    

}
