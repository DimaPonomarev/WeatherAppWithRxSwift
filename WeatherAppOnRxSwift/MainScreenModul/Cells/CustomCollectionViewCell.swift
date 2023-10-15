//
//  CustomCollectionViewCell.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import UIKit
import SnapKit

private extension String {
    static let nowText = "Сейчас"
    static let dateFormat = "yyyy-MM-dd HH:mm"
    static let formatToCompare = "dd HH:00"
    static let formatToUseInLabel = "HH:mm"
}

private extension Int {
    static let fontSize = CGFloat(15)
}

final class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - identifier
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //  MARK: - UI properties
    
    private let imageViewOfWeatherIcon = WebImageView()
    private let labelTime = UILabel()
    private let labelDeegree = UILabel()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMethods()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.notImplemented)
    }
    
    //MARK: - configureView
    
    public func configureView(_ model: ModelsForMainScreen.ModelForCollectionView) {
        labelDeegree.text = "\(model.temperature)"
        labelTime.text = convertDateFrom(model.time).timesInFuture
        imageViewOfWeatherIcon.setWeatherImage(imageUrl: model.iconURL)
        if DateFormatter.currentDateIn(model.timeZone,format: .formatToCompare) == convertDateFrom(model.time).currentTime {
            labelTime.text = .nowText
        }
    }
}

//  MARK: - Private methods

private extension CustomCollectionViewCell {
    
    //MARK: - setup
    
    func setupMethods() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    //MARK: - addViews
    
    func addViews() {
        contentView.addSubview(imageViewOfWeatherIcon)
        contentView.addSubview(labelTime)
        contentView.addSubview(labelDeegree)
    }
    
    //MARK: - setupConstraints
    
    func makeConstraints() {
        labelTime.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        imageViewOfWeatherIcon.snp.makeConstraints {
            $0.top.equalTo(labelTime.snp.bottom)
            $0.height.width.equalTo(Int.imageViewSizeInCell)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        labelDeegree.snp.makeConstraints {
            $0.top.equalTo(imageViewOfWeatherIcon.snp.bottom)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    //MARK: - getCurrentDate
    
    func convertDateFrom(_ dateInString: String) -> (timesInFuture: String, currentTime: String) {
        let date = DateFormatter.dateFormatterFromStringToDate(dateInString, format: .dateFormat)
        let forComparisonWithCurrentDate = DateFormatter.dateFormatterFromDateToString(date, format: .formatToCompare)
        let forLabel = DateFormatter.dateFormatterFromDateToString(date, format: .formatToUseInLabel)
        return (forLabel, forComparisonWithCurrentDate)
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        
        labelTime.font = .systemFont(ofSize: Int.fontSize)
        labelTime.textColor = .white
        labelDeegree.font = .systemFont(ofSize: Int.fontSize)
        labelDeegree.textColor = .white
        imageViewOfWeatherIcon.contentMode = .scaleAspectFill
    }
}
