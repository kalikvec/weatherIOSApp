import Foundation

class WeatherServiceImpl: WeatherService {
    //private static let baseWeatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139"
    private let baseWeatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    private let openWeatherMapAPIKey = "9c8c505678684ef56b21693a57b23fa2"

    
    func loadWeatherInfo(for coordinates: Coordinates, completion: @escaping (Result<WeatherInfo>) -> ()) {
        let latitudeString = String(coordinates.latitude)
        let longitudeString = String(coordinates.longitude)
        
        let parameterString = ["lat" : latitudeString, "lon": longitudeString].stringFromHttpParameters()
        let requestURL = URL(string:"\(baseWeatherURL)\(parameterString)&APPID=\(openWeatherMapAPIKey)")!
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let networkError = error {
                completion(.error(networkError))
                return
            }
            
            guard let jsonData = data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()),
                let jsonDict = json as? JsonObject else {
                    completion(.error(RequestError.invalidData))
                    return
            }
            
            guard let res = WeatherInfo.map(response: jsonDict) else {
                completion(.error(RequestError.parseError))
                return
            }
            completion(.success(res))
        }
        task.resume()
    }
}

enum RequestError: Error {
    case parseError
    case invalidData
}

