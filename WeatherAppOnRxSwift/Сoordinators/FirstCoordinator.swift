//
//  MainScreenCoordinator.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 07.10.2023.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

private extension String {
    static let cancelButton = "Cancel"
}

protocol IFirstCoordinator {
    func start()
    func showAlert(message: String)
}

class FirstCoordinator: IFirstCoordinator {
    
    var navigationController = UINavigationController()
    
    func start() {
        let mainScreenVC = MainScreenViewController()
        let networkService = NetworkService()
        let locationManager = LocationManager()
        let mainScreenViewModel = MainScreenViewModel(networkManager: networkService,
                                     locationManager: locationManager,
                                     coordinator: self)
        mainScreenVC.viewModel = mainScreenViewModel
        navigationController.pushViewController(mainScreenVC, animated: true)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: .cancelButton, style: .cancel)
        alertController.addAction(cancel)
        navigationController.present(alertController, animated: true)
    }
}
