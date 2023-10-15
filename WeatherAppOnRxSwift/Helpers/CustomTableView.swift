//
//  CustomTableView.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import UIKit
import RxSwift

class CustomTableView: UITableView {
    
    private var arrayOfModels: [ModelsForMainScreen.ModelForTableView] = []

    let disposeBag = DisposeBag()
    var viewModel: IMainScreenViewModel? {
        didSet {
            self.setupAndBindingTableView()
        }
    }
    
    func setupAndBindingTableView() {
        self.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        self.dataSource = self
        
        viewModel?.tableViewModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { items in
                
                self.arrayOfModels = items
                self.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension CustomTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        let eachModel = arrayOfModels[indexPath.row]
        cell.configureView(eachModel)
        return cell
    }
}
