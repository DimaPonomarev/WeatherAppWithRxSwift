//
//  WebImageView.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import UIKit

class WebImageView: UIImageView {
    
    func setWeatherImage(imageUrl: String?) {
        guard let imageUrl, let url = URL(string: imageUrl) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self, let data else { return }
                self.image = UIImage(data: data)
            }
        }
        dataTask.resume()
    }
}
