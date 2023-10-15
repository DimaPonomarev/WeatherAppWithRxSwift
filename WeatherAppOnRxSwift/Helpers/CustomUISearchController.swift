//
//  CustomUISearchController.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 03.10.2023.
//

import UIKit

final class CustomSearchController: UISearchController {
    
    //MARK: - init

    init() {
        super.init(searchResultsController: nil)
        setupSearchController()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.notImplemented)
    }
    
    //MARK: - closure
    
    var getTextClouser: ((String) ->())?
}

//MARK: - Private Methods

private extension CustomSearchController {
    
    func setupSearchController() {
        self.searchResultsUpdater = self
        self.searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.7)
    }
}

//MARK: - UISearchBarDelegate

extension CustomSearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let city = searchController.searchBar.text else { return }
        if city.count > 3 {
            getTextClouser?(city)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
}
