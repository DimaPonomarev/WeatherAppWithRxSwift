//
//  APIWeatherManager.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 07.10.2023.
//

import Foundation
import RxSwift

final class NetworkService: INetworkService {
    
    func makeRequest<T>(cityName: String) -> RxSwift.Observable<T> where T : Decodable {
        makeBaseRequest(url: createURLWith(cityName))
    }
}

private extension NetworkService {
    
    func createURLWith(_ cityName: String) -> URL? {
        let encodedCityName = String(encodedString: cityName)
        let url = URL(string: "\(APIWeatherManagerURL(city: encodedCityName).path)")
        return url
    }
}
