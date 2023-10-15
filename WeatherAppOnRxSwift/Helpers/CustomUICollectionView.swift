//
//  CustomCollectionView.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import UIKit
import RxDataSources
import RxSwift
class CustomCollectionView: UICollectionView {
    
    let disposeBag = DisposeBag()
    
    var viewModel: IMainScreenViewModel? {
        didSet {
            setupAndBindingCollectionView()
        }
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: CustomCollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(.notImplemented)
    }
    
    private func setupAndBindingCollectionView() {
        self.backgroundColor = .clear
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCollectionViewModelItems>(
            configureCell: { dataSource, collectionView, indexPath, item in
                collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
                cell.configureView(item)
                return cell
            })
        
        viewModel?.collectionViewModel
            .map { [SectionOfCollectionViewModelItems(items: $0)] }
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
