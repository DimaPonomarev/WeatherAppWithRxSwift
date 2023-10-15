//
//  NetworkServiceProtocol.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import Foundation
import RxSwift

protocol INetworkService {
    func makeRequest<T: Decodable>(cityName: String) -> Observable<T>
}

extension INetworkService {
    
    func makeBaseRequest<T: Decodable>(url: URL?) -> Observable<T> {
        guard let urlRequest = makeURLReqest(url: url) else { return Observable.error(URLError(.badURL)) }
        return URLSession.shared.rx.data(request: urlRequest).map { data in
            do {
                return try self.decodeJson(type: T.self, from: data)
            } catch {
                throw error
            }
        }
    }
    
    func makeURLReqest(url: URL?) -> URLRequest? {
        guard let url else { return nil }
        return URLRequest(url: url)
    }
    
    func decodeJson<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(type.self, from: data)
        } catch {
            throw error
        }
    }
}
