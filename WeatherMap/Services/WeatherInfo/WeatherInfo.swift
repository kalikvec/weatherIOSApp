//
//  WeatherInfo.swift
//  WeatherMap
//
//  Created by Лейтан Александр on 14/10/2018.
//  Copyright © 2018 Лейтан Александр. All rights reserved.
//

import Foundation


struct WeatherInfo: Mappable {
    let weatherTitle: String
    let weatherDescription: String
    let iconUrl: URL?
    let temperature: Double
    let pressure: Int?
    let humidity: Int?
    let minTemp: Double?
    let maxTemp: Double?

    
    static func map(response: JsonObject) -> WeatherInfo? {
        guard let commonAttributes = response[MappingKeys.weather] as? JsonArray,
              commonAttributes.count > 0,
              let mainWeatherDetails = response[MappingKeys.mainDetails] as? JsonObject else { return nil }

        let weatherMainInfo = commonAttributes[0]

        guard let weatherTitle = weatherMainInfo[MappingKeys.title] as? String,
              let weatherDescription = weatherMainInfo[MappingKeys.description] as? String else { return nil }


        let iconUrl = WeatherInfo.buildIconUrl(for: weatherMainInfo[MappingKeys.icon] as? String)


        guard let temperature = mainWeatherDetails[MappingKeys.temperature] as? Double else { return nil }

        let pressure = mainWeatherDetails[MappingKeys.pressure] as? Int
        let humidity = mainWeatherDetails[MappingKeys.humidity] as? Int
        let minTemp = mainWeatherDetails[MappingKeys.minTemp] as? Double
        let maxTemp = mainWeatherDetails[MappingKeys.maxTemp] as? Double

        
        return WeatherInfo(
            weatherTitle: weatherTitle,
            weatherDescription: weatherDescription,
            iconUrl: iconUrl,
            temperature: temperature,
            pressure: pressure,
            humidity: humidity,
            minTemp: minTemp,
            maxTemp: maxTemp
        )
    }
    
    private struct MappingKeys {
        // weather array key
        static let weather = "weather"
        
        // weather array sub keys
        static let title = "main"
        static let description = "description"
        static let icon = "icon"
        
        static let mainDetails = "main"
        
        static let temperature = "temp"
        static let pressure = "pressure"
        static let humidity = "humidity"
        static let minTemp = "temp_min"
        static let maxTemp = "temp_max"
    }

    private static func buildIconUrl(for iconName: String?) -> URL? {
        guard let icon = iconName else { return nil }

        return URL(string: "http://openweathermap.org/img/w/\(icon).png")
    }
}
