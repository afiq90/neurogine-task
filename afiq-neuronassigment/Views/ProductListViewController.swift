//
//  ViewController.swift
//  afiq-neuronassigment
//
//  Created by Afiq Hamdan on 24/09/2026.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let viewModel = ProductListViewModel()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        //add tap gesture to dismiss keyboard anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        //ProductListViewModel
        viewModel.onChange = {[weak self] in
            self?.render()
        }
        viewModel.loadInitial()
        
        print("viewDidLoad got called")
        print("products: \(viewModel.products)")
        
    }
    
    private func render() {
        loadingViewIndicator.isHidden = true
        emptView.isHidden = true
        errorView.isHidden = true
        
        refreshControl.endRefreshing()
        
        switch viewModel.state {
        case .loading:
            loadingViewIndicator.isHidden = false
        case .success:
            tableView.reloadData()
        case . empty:
            emptView.isHidden = false
        case .error(let errorMsg):
            errorLabel.text = errorMsg
            errorView.isHidden = false
        case .idle:
            break
        }
        
        tableView.reloadData()
    }
    
    // this retry button appeared on Error View
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        viewModel.retry()
    }
    
    // this method is for selector
    @objc private func refreshProducts() {
        viewModel.refresh()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else {
            return true
        }
        
        return touchedView !== searchBar && !touchedView.isDescendant(of: searchBar)
    }
    
    //tableview delegate & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! ProductCell
        let product = viewModel.products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        performSegue(withIdentifier: "ShowProductDetail", sender: product.id)
    }
    
    //searchbar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 300
        let position = scrollView.contentOffset.y + scrollView.bounds.height
        
        if position > scrollView.contentSize.height - threshold {
            viewModel.loadNextPageIfNeeded()
        }
    }
    
    // prepare segue to ProductDetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let detailsViewController = segue.destination as? ProductDetailsViewController,
            let productID = sender as? Int
        else {
            return
        }
        
        print("Product ID: \(productID)")
        detailsViewController.productID = productID
    }

}

