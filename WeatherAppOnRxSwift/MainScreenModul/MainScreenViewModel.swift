//
//  MainScreenViewModel.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 06.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

private extension String {
    static let dateFormat = "yyyy-MM-dd HH:00"
}

protocol IMainScreenViewModel {
    var topViewModel: PublishRelay<ModelsForMainScreen.ModelForTopView> { get }
    var collectionViewModel: PublishRelay<[ModelsForMainScreen.ModelForCollectionView]> { get }
    var tableViewModel: PublishRelay<[ModelsForMainScreen.ModelForTableView]> { get }
    
    func makeWeatherRequestIn(in city: String)
}

class MainScreenViewModel: IMainScreenViewModel {
    
    //    MARK: - Data Variables
    
    private let networkManager: INetworkService
    private let locationManager: ILocationManager
    private let coordinator: IFirstCoordinator
    private let disposeBag = DisposeBag()
    
    let topViewModel = PublishRelay<ModelsForMainScreen.ModelForTopView>()
    let collectionViewModel = PublishRelay<[ModelsForMainScreen.ModelForCollectionView]>()
    let tableViewModel = PublishRelay<[ModelsForMainScreen.ModelForTableView]>()
    
    //    MARK: - init
    
    init(networkManager: INetworkService, locationManager: ILocationManager, coordinator: IFirstCoordinator) {
        self.coordinator = coordinator
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.checkLocationAuthorizationStatusAndMakeFirstRequest()
    }
    
    //MARK: - make weather request
    
    func makeWeatherRequestIn(in city: String) {
        networkManager.makeRequest(cityName: city).subscribe(onNext: {
            let topViewModel = self.convertDataToTopViewModel(dataSource: $0)
            let collectionViewModel = self.convertDataToCollectionViewModel(dataSource: $0)
            let tableViewModel = self.convertDataToTableViewModel(dataSource: $0)
            self.topViewModel.accept(topViewModel)
            self.collectionViewModel.accept(collectionViewModel)
            self.tableViewModel.accept(tableViewModel)
        }).disposed(by: disposeBag)
    }
}

private extension MainScreenViewModel {
    
    //MARK: - check location authorization status and make first weather request
    
    func checkLocationAuthorizationStatusAndMakeFirstRequest() {
        locationManager.locationAuthorizationStatus.subscribe { status in
            switch status.element {
            case .authorizedWhenInUse, .authorizedAlways, .denied: self.makeFirstRequestWithCurrentLocation()
            default: break
            }
        }.disposed(by: disposeBag)
    }
    
    func makeFirstRequestWithCurrentLocation() {
        self.locationManager.cityWhereUserIsLocated().subscribe(onNext: { currentCity in
            self.makeWeatherRequestIn(in: currentCity)
        }, onError: { error in
            self.coordinator.showAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
        
    //    MARK: - conversion functions
    
    func convertDataToTableViewModel(dataSource: APIWeatherManagerModel.WeatherModel) -> [ModelsForMainScreen.ModelForTableView] {
        return dataSource.forecast.forecastday.map { eachDay in
            ModelsForMainScreen.ModelForTableView(maxtempC: eachDay.day.maxtempC,
                                                  mintempC: eachDay.day.mintempC,
                                                  date: eachDay.date,
                                                  icon: eachDay.day.condition.icon,
                                                  timeZone: dataSource.location.tzId
            )
        }
    }
    
    func convertDataToCollectionViewModel(dataSource: APIWeatherManagerModel.WeatherModel) -> [ModelsForMainScreen.ModelForCollectionView] {
        let todaysWeatherInEachHour = dataSource.forecast.forecastday[0].hour
        let tomorrowsWeatherInEachHour = dataSource.forecast.forecastday[1].hour
        let todaysAndTomorrowsWeatherInEachHour = todaysWeatherInEachHour + tomorrowsWeatherInEachHour
        let currentDate = DateFormatter.formatterRoundingToNearestHour(from: dataSource.location.localtime, format: .dateFormat)
        let filteredWeather = todaysAndTomorrowsWeatherInEachHour.filter { weatherInEachHour in
            weatherInEachHour.time >= currentDate
        }
        return filteredWeather.map { weatherInEachHour in
            ModelsForMainScreen.ModelForCollectionView(time: weatherInEachHour.time,
                                                       tempC: weatherInEachHour.tempC,
                                                       icon: weatherInEachHour.condition.icon,
                                                       timeZone: dataSource.location.tzId)
        }
    }
    
    func convertDataToTopViewModel(dataSource: APIWeatherManagerModel.WeatherModel) -> ModelsForMainScreen.ModelForTopView {
        if let todaysWeatherPerEachHour = dataSource.forecast.forecastday[0].hour.first(where: { $0.time ==  DateFormatter.formatterRoundingToNearestHour(from: dataSource.location.localtime, format: .dateFormat) }) {
            return ModelsForMainScreen.ModelForTopView(
                temperature: todaysWeatherPerEachHour.tempC,
                isDay: todaysWeatherPerEachHour.isDay,
                pressure: todaysWeatherPerEachHour.pressureMb,
                humidity: todaysWeatherPerEachHour.humidity,
                apparentTemperature: todaysWeatherPerEachHour.feelslikeC,
                windSpeed: todaysWeatherPerEachHour.windKph,
                description: todaysWeatherPerEachHour.condition.text,
                icon: todaysWeatherPerEachHour.condition.icon,
                isRain: todaysWeatherPerEachHour.chanceOfRain,
                cityLocation: "\(dataSource.location.name), \(dataSource.location.country)")
        } else {
            return ModelsForMainScreen.ModelForTopView(temperature: 0,
                                                       isDay: 0,
                                                       pressure: 0,
                                                       humidity: 0,
                                                       apparentTemperature: 0,
                                                       windSpeed: 0,
                                                       description: "",
                                                       icon: "",
                                                       isRain: 0,
                                                       cityLocation: ""
            )
        }
    }
}
