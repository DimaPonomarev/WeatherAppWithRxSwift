//
//  AppCoordinator.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 07.10.2023.
//

import UIKit

protocol CoordinatorProtocol {
    
    func start()
}


class AppCoordinator: CoordinatorProtocol {
    
    var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let childCoordinator = FirstCoordinator()
        window?.rootViewController = childCoordinator.navigationController
        childCoordinator.start()
    }
}
