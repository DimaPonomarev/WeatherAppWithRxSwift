//
//  APIWeatherManager.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 07.10.2023.
//

import Foundation

struct  APIWeatherManagerURL {
    private let baseURL = "https://api.weatherapi.com/"
    private let apiKey = "69e2f72efad44bd59b623004230604"
    private var city: String
    var path: String
    
    init(city: String) {
        self.city = city
        self.path = "\(self.baseURL)v1/forecast.json?key=\(self.apiKey)&q=\(city)&days=9&aqi=no&lang=ru"
    }
}

