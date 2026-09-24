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
        
    }
    
    //tableview delegate & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //searchbar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 300
        let position = scrollView.contentOffset.y + scrollView.bounds.height
        
        if position > scrollView.contentSize.height - threshold {
            
        }
    }
    
    // prepare segue to ProductDetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let detailsViewController = segue.destination as? ProductDetailsViewController,
        else {
            return
        }
    }

}

