//
//  ModelForMainScreen.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 07.10.2023.
//

import UIKit
import RxDataSources

enum ModelsForMainScreen {
    
    struct ModelForTopView {
        let temperature: Double
        let isDay: Int
        let pressure: Int
        let humidity: Int
        let apparentTemperature: Double
        let windSpeed: Double
        let description: String
        let icon: String
        let isRain: Int
        let cityLocation: String
    }
    
    struct ModelForTableView {
        
        let maxtempC: Double
        let mintempC: Double
        let date: String
        let icon: String
        let timeZone: String
    }
    
    struct ModelForCollectionView {
        let time: String
        let tempC: Double
        var icon: String
        let timeZone: String
    }
}

extension ModelsForMainScreen.ModelForTopView {
    var weatherTemprature: String { return "\(Int(temperature))˚C" }
    var weatherWindSpeed: String { return "Скорость ветра: \(Int(windSpeed)) м/c" }
    var weatherAppearentTemperature: String { return "Ощущается как: \(Int(apparentTemperature))˚C" }
    var weatherHumidity: String { return "Влажность воздуха: \(Int(humidity))%" }
    var weatherPressure: String { return "Атм. давление: \(Int(pressure)) mm" }
    var iconURL:String { return "https:\(icon)" }
    var switchNightDay: UIImage? {
        switch isDay {
        case 0: return UIImage(named: "night")
        default: return UIImage(named: "day")
        }
    }
    var switchRain: Bool {
        switch isRain {
        case 60...100: return false
        default: return true
        }
    }
}

extension ModelsForMainScreen.ModelForTableView {
    var maxWeatherTemperature: String { return "\(Int(maxtempC))˚C" }
    var minWeatherTemperature: String { return "\(Int(mintempC))˚C" }
    var iconURL: String { return "https:\(icon)" }
}

extension ModelsForMainScreen.ModelForCollectionView {
    var temperature: String { return "\(Int(tempC))˚C" }
    var iconURL: String { return "https:\(icon)" }
}

struct SectionOfCollectionViewModelItems {
    var items: [ModelsForMainScreen.ModelForCollectionView]
}

extension SectionOfCollectionViewModelItems: SectionModelType {
    typealias Item = ModelsForMainScreen.ModelForCollectionView

    init(original: SectionOfCollectionViewModelItems, items: [Item]) {
        self = original
        self.items = items
    }
}
