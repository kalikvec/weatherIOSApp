import Foundation

struct Coordinates {
    let longitude: Double
    let latitude: Double
}

protocol WeatherService {
    func loadWeatherInfo(for coordinates: Coordinates, completion: @escaping (Result<WeatherInfo>) -> ())
}
