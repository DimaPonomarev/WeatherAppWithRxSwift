//
//  ViewController.swift
//  WeatherAppOnRxSwift
//
//  Created by Дмитрий Пономарев on 06.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import SpriteKit


private extension String {
    static let forecastLabel = "Прогноз на 3 дня"
    static let particleScene = "Rain"
}

private extension Int {
    static let largeFontSize = CGFloat(40)
    static let stackViewLeading = 15
    static let collectionViewTop = 5
    static let collectionViewLeft = 20
    static let collectionViewHeight = 85
    static let forecastLabelTop = 10
    static let forecastLabelLeading = 20
    static let tableViewTop = 10
    static let tableViewLeading = 5
    static let averageFontSize = CGFloat(20)
    static let smallFontSize = CGFloat(15)
    static let averageScaleFactor = CGFloat(5)
    static let degreeSpacing = CGFloat(20)
    static let boldFontSize = CGFloat(25)
}

protocol IMainScreenViewController: UIViewController {
    
    var viewModel: IMainScreenViewModel? { get set }
}

final class MainScreenViewController: UIViewController, IMainScreenViewController {
    
    var viewModel: IMainScreenViewModel?
    private let disposeBag = DisposeBag()
    
    //MARK: - UI properties
    
    private let upperView = UIView()
    private let cityLabel = UILabel()
    private let imageViewOfCurrentWeatherInUpperView = WebImageView()
    private let atmospherePressureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let degreeOfCurrentWeatherInUpperView = UILabel()
    private let feelLikeDegreeLabel = UILabel()
    private let descriptionOfWeather = UILabel()
    private let windSpeedLabel = UILabel()
    private let degreeAndImageStackViewInUpperStackView = UIStackView()
    private let degreeStackView = UIStackView()
    private let descriptionStackView = UIStackView()
    private let forecastLabel = UILabel()
    private let nightDayImageViewInUpperView = UIImageView()
    private let rainView = UIView()
    private let locationManager = LocationManager()
    private let searchController = CustomSearchController()
    private let collectionView = CustomCollectionView()
    private let tableView = CustomTableView()
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
    }
}

//MARK: - Private Methods

private extension MainScreenViewController {
    
    //MARK: - setup UI
    
    func setupConfigure() {
        view.backgroundColor = .white
        addViews()
        makeConstraints()
        setupViews()
        setupAction()
        bindingTopViewModel()
    }
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(upperView)
        upperView.addSubview(nightDayImageViewInUpperView)
        upperView.addSubview(nightDayImageViewInUpperView)
        upperView.addSubview(degreeStackView)
        degreeStackView.addArrangedSubview(cityLabel)
        degreeStackView.addArrangedSubview(degreeAndImageStackViewInUpperStackView)
        degreeStackView.addArrangedSubview(descriptionOfWeather)
        degreeStackView.addArrangedSubview(feelLikeDegreeLabel)
        degreeAndImageStackViewInUpperStackView.addArrangedSubview(degreeOfCurrentWeatherInUpperView)
        degreeAndImageStackViewInUpperStackView.addArrangedSubview(imageViewOfCurrentWeatherInUpperView)
        upperView.addSubview(rainView)
        rainView.addSubview(SKView(withEmitter: .particleScene))
        upperView.addSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(windSpeedLabel)
        descriptionStackView.addArrangedSubview(humidityLabel)
        descriptionStackView.addArrangedSubview(atmospherePressureLabel)
        upperView.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(forecastLabel)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        upperView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(collectionView)
        }
        nightDayImageViewInUpperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        degreeStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(upperView)
        }
        descriptionStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Int.stackViewLeading)
            $0.top.equalTo(degreeStackView.snp.bottom)
            $0.centerY.equalTo(collectionView.snp.centerY)
        }
        rainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(degreeStackView.snp.bottom).offset(Int.collectionViewTop)
            $0.left.equalTo(descriptionStackView.snp.right).offset(Int.collectionViewLeft)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(upperView)
            $0.height.equalTo(Int.collectionViewHeight)
        }
        forecastLabel.snp.makeConstraints {
            $0.top.equalTo(upperView.snp.bottom).offset(Int.forecastLabelTop)
            $0.leading.equalToSuperview().offset(Int.forecastLabelLeading)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(forecastLabel.snp.bottom).offset(Int.tableViewTop)
            $0.leading.trailing.equalToSuperview().inset(Int.tableViewLeading)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        setupNavBar()
        
        self.view.backgroundColor = .white
        
        upperView.backgroundColor = .systemBlue
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight])
        upperView.clipsToBounds = true
        
        rainView.isHidden = true
        
        cityLabel.font = .systemFont(ofSize: Int.largeFontSize)
        cityLabel.minimumScaleFactor = Int.minimumScaleFactor
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 0
        cityLabel.textColor = .white
        
        degreeOfCurrentWeatherInUpperView.font = .systemFont(ofSize: Int.largeFontSize)
        degreeOfCurrentWeatherInUpperView.minimumScaleFactor = Int.minimumScaleFactor
        degreeOfCurrentWeatherInUpperView.adjustsFontSizeToFitWidth = true
        degreeOfCurrentWeatherInUpperView.textAlignment = .right
        degreeOfCurrentWeatherInUpperView.numberOfLines = 0
        degreeOfCurrentWeatherInUpperView.textColor = .white
        
        imageViewOfCurrentWeatherInUpperView.contentMode = .left
        
        descriptionOfWeather.font = .preferredFont(forTextStyle: .body)
        descriptionOfWeather.font = .systemFont(ofSize: Int.averageFontSize)
        descriptionOfWeather.minimumScaleFactor = Int.minimumScaleFactor
        descriptionOfWeather.adjustsFontSizeToFitWidth = true
        descriptionOfWeather.textAlignment = .center
        descriptionOfWeather.numberOfLines = 0
        descriptionOfWeather.textColor = .white
        
        feelLikeDegreeLabel.font = .systemFont(ofSize: Int.averageFontSize)
        feelLikeDegreeLabel.minimumScaleFactor = Int.minimumScaleFactor
        feelLikeDegreeLabel.adjustsFontSizeToFitWidth = true
        feelLikeDegreeLabel.textAlignment = .center
        feelLikeDegreeLabel.numberOfLines = 0
        feelLikeDegreeLabel.textColor = .systemGray5
        
        windSpeedLabel.textColor = .white
        windSpeedLabel.font = .systemFont(ofSize: Int.smallFontSize)
        windSpeedLabel.minimumScaleFactor = Int.averageScaleFactor
        windSpeedLabel.adjustsFontSizeToFitWidth = true
        
        humidityLabel.textColor = .white
        humidityLabel.font = .systemFont(ofSize: Int.smallFontSize)
        humidityLabel.minimumScaleFactor = Int.averageScaleFactor
        humidityLabel.adjustsFontSizeToFitWidth = true
        
        atmospherePressureLabel.textColor = .white
        atmospherePressureLabel.font = .systemFont(ofSize: Int.smallFontSize)
        atmospherePressureLabel.minimumScaleFactor = Int.averageScaleFactor
        atmospherePressureLabel.adjustsFontSizeToFitWidth = true
        
        degreeAndImageStackViewInUpperStackView.distribution = .fillEqually
        
        degreeStackView.axis = .vertical
        degreeStackView.spacing = Int.degreeSpacing
        degreeStackView.distribution = .fillProportionally
        
        descriptionStackView.axis = .vertical
        descriptionStackView.distribution = .fillEqually
        
        forecastLabel.text = .forecastLabel
        forecastLabel.font = .boldSystemFont(ofSize: Int.boldFontSize)
        
        collectionView.viewModel = viewModel
        tableView.viewModel = viewModel
    }
    
    //MARK: - setupNavBar
    
    func setupNavBar() {
        navigationItem.searchController = searchController
    }
    
    //MARK: - setupAction
    
    func setupAction() {
        searchController.getTextClouser = { [weak self] text in
            guard let self else { return }
            self.viewModel?.makeWeatherRequestIn(in: text)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - bindingTopViewModel
    
    func bindingTopViewModel() {
        viewModel?.topViewModel.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] model in
            guard let self else { return }
            self.humidityLabel.text = "\(model.weatherHumidity)"
            self.atmospherePressureLabel.text = "\(model.weatherPressure)"
            self.degreeOfCurrentWeatherInUpperView.text = "\(model.weatherTemprature)"
            self.feelLikeDegreeLabel.text = "\(model.weatherAppearentTemperature)"
            self.descriptionOfWeather.text = "\(model.description)"
            self.windSpeedLabel.text = "\(model.weatherWindSpeed)"
            self.cityLabel.text = "\(model.cityLocation)"
            self.imageViewOfCurrentWeatherInUpperView.setWeatherImage(imageUrl: model.iconURL)
            self.nightDayImageViewInUpperView.image = model.switchNightDay
            self.rainView.isHidden = model.switchRain
        }).disposed(by: disposeBag)
    }
    
    //MARK: - @objc funcs

    @objc func dismissKeyboard() {
        searchController.isActive = false
    }
}


