//
//  CustomTableViewCell.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 10.10.2023.
//

import UIKit
import SnapKit

private extension String {
    static let todayText = "Cегодня"
    static let nightText = "Ночь"
    static let dayText = "День"
    static let dateFormat = "dd MMMM"
}

private extension Int {
    static let fontSize = CGFloat(16)
    static let largeFontSize = CGFloat(20)
    static let stackViewSpacing = CGFloat(15)
    static let stackViewOffset = 15
    static let stackViewInset = 15
    static let trailingInset = -20
    static let topInset = -5
}

final class CustomTableViewCell: UITableViewCell {
    
    
    //MARK: - identifier
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //  MARK: - UI properties
    
    private let maxTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let dateLabel = UILabel()
    private let weekDayLabel = UILabel()
    private let imageViewOfWeatherIcon = WebImageView()
    private let dateStackView = UIStackView()
    private let weatherStackView = UIStackView()
    private let nightTemperature = UILabel()
    private let dayTemperature = UILabel()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMethods()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.notImplemented)
    }
    
    //MARK: - configureView
    
    public func configureView(_ model: ModelsForMainScreen.ModelForTableView) {
        dateLabel.text = DateFormatter.currentDayAndMonth(from: model.date, format: .dateFormat)
        maxTempLabel.text = "\(model.maxWeatherTemperature)"
        minTempLabel.text = "\(model.minWeatherTemperature)"
        imageViewOfWeatherIcon.setWeatherImage(imageUrl: model.iconURL)
        if DateFormatter.currentDateIn(model.timeZone, format: .dateFormat) != DateFormatter.currentDayAndMonth(from: model.date, format: .dateFormat) {
            visibleUIPropertiesOnFirstCell(visible: true)
        } 
    }
}

//  MARK: - Private methods

private extension CustomTableViewCell {
    
    //  MARK: - setupMethods
    
    func setupMethods() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    //  MARK: - addViews
    
    func addViews() {
        contentView.addSubview(dateStackView)
        contentView.addSubview(weatherStackView)
        contentView.addSubview(imageViewOfWeatherIcon)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(weekDayLabel)
        weatherStackView.addArrangedSubview(maxTempLabel)
        weatherStackView.addArrangedSubview(minTempLabel)
        contentView.addSubview(dayTemperature)
        contentView.addSubview(nightTemperature)
    }
    
    //  MARK: - makeConstraints
    
    func makeConstraints() {
        dateStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Int.stackViewOffset)
            $0.top.bottom.equalToSuperview().inset(Int.stackViewInset)
        }
        imageViewOfWeatherIcon.snp.makeConstraints {
            $0.trailing.equalTo(weatherStackView.snp.leading).inset(Int.trailingInset)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(Int.imageViewSizeInCell)
        }
        weatherStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Int.stackViewInset)
            $0.centerY.equalToSuperview()
        }
        dayTemperature.snp.makeConstraints{
            $0.leading.trailing.equalTo(maxTempLabel)
            $0.top.equalToSuperview().inset(Int.topInset)
        }
        nightTemperature.snp.makeConstraints{
            $0.leading.trailing.equalTo(minTempLabel)
            $0.top.equalTo(dayTemperature)
        }
    }
    
    //  MARK: - setupViews
    
    func setupViews() {
        imageViewOfWeatherIcon.contentMode = .scaleToFill
        imageViewOfWeatherIcon.contentScaleFactor = imageViewOfWeatherIcon.alignmentRectInsets.left
        dateLabel.font = .systemFont(ofSize: Int.fontSize)
        dateLabel.textColor = .gray
        
        maxTempLabel.adjustsFontSizeToFitWidth = true
        maxTempLabel.font = .systemFont(ofSize: Int.largeFontSize)
        maxTempLabel.minimumScaleFactor = Int.minimumScaleFactor
        
        minTempLabel.adjustsFontSizeToFitWidth = true
        minTempLabel.textColor = .gray
        minTempLabel.font = .systemFont(ofSize: Int.largeFontSize)
        minTempLabel.minimumScaleFactor = Int.minimumScaleFactor
        
        dateStackView.axis = .vertical
        dateStackView.distribution = .equalCentering
        
        weatherStackView.axis = .horizontal
        weatherStackView.distribution = .fillEqually
        weatherStackView.spacing = Int.stackViewSpacing
        
        weekDayLabel.font = .systemFont(ofSize: Int.fontSize)
        weekDayLabel.textColor = .darkGray
        weekDayLabel.text = .todayText
        
        dayTemperature.adjustsFontSizeToFitWidth = true
        dayTemperature.font = .systemFont(ofSize: Int.largeFontSize)
        dayTemperature.text = .dayText
        dayTemperature.minimumScaleFactor = Int.minimumScaleFactor
        dayTemperature.textAlignment = .center
        
        nightTemperature.textAlignment = .center
        nightTemperature.adjustsFontSizeToFitWidth = true
        nightTemperature.textColor = .gray
        nightTemperature.font = .systemFont(ofSize: Int.largeFontSize)
        nightTemperature.text = .nightText
        nightTemperature.minimumScaleFactor = Int.minimumScaleFactor
    }
    
    //  MARK: - makeFirstCell
    
    private func visibleUIPropertiesOnFirstCell(visible: Bool) {
        weekDayLabel.isHidden = visible
        dayTemperature.isHidden = visible
        nightTemperature.isHidden = visible
        
        weatherStackView.snp.remakeConstraints {
            $0.right.equalToSuperview().inset(Int.stackViewInset)
            $0.bottom.equalToSuperview().inset(Int.stackViewInset)
        }
    }
}

