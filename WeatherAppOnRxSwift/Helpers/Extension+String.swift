//
//  Extension+String.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import Foundation

extension String {
    init(encodedString: String) {
        self = encodedString.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
    }
    
    static var notImplemented = "init(coder:) has not been implemented"
}
