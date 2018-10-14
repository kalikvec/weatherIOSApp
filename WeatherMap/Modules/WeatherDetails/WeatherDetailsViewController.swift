//
//  WeatherDetailsViewController.swift
//  WeatherMap
//
//  Created by Лейтан Александр on 14/10/2018.
//  Copyright © 2018 Лейтан Александр. All rights reserved.
//

import Foundation
import UIKit


struct WeatherViewData {
    let weatherFeature: String
    let featureValue: String
}

final class WeatherDetailsViewController: UIViewController, UITableViewDataSource {
    var location: Coordinates?
    var weatherViewData = [WeatherViewData]()

    let weatherService: WeatherService = WeatherServiceImpl()
    
    @IBOutlet weak var tableView: UITableView!

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        loadWeatherInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.addSubview(activityIndicator)
        activityIndicator.frame = view.frame
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as? WeatherInfoCell {
            cell.weatherFeature.text = weatherViewData[indexPath.row].weatherFeature
            cell.featureValue.text = weatherViewData[indexPath.row].featureValue
            
            return cell
        }
        return UITableViewCell()
    }
    
    private func convertWeatherInfoToViewData(info: WeatherInfo) -> [WeatherViewData] {
        var viewData = [WeatherViewData]()
        
        viewData.append(WeatherViewData(weatherFeature: "Weather state", featureValue: info.weatherTitle))
        viewData.append(WeatherViewData(weatherFeature: "Detailed description", featureValue: info.weatherDescription))
        viewData.append(WeatherViewData(weatherFeature: "Temperature", featureValue: String(info.temperature) + "F"))

        guard let pressure = info.pressure,
              let humidity = info.humidity,
              let maxTemp = info.maxTemp,
              let minTemp = info.minTemp else { return viewData }

        viewData.append(WeatherViewData(weatherFeature: "Pressure", featureValue: String(pressure)))
        viewData.append(WeatherViewData(weatherFeature: "Humidity", featureValue: String(humidity)))
        viewData.append(WeatherViewData(weatherFeature: "Max Temperature", featureValue: String(maxTemp)))
        viewData.append(WeatherViewData(weatherFeature: "Min Temperature", featureValue: String(minTemp)))

        return viewData
    }

    private func loadWeatherInfo() {
        if let location = location {

            activityIndicator.startAnimating()
            weatherService.loadWeatherInfo(for: location) { [weak self] result in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()

                    switch result {
                    case .success(let info):
                        guard let strongSelf = self else { return }
                        
                        strongSelf.weatherViewData = strongSelf.convertWeatherInfoToViewData(info: info)
                        strongSelf.tableView.reloadData()
                    case .error(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

extension WeatherDetailsViewController {
    static let viewControllerID = "weatherDetailsViewControllerID"

    static func storyboardInstance() -> WeatherDetailsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewControllerID) as? WeatherDetailsViewController
    }
}
