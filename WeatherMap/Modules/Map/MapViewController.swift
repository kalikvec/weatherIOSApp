//
//  ViewController.swift
//  WeatherMap
//
//  Created by Лейтан Александр on 13/10/2018.
//  Copyright © 2018 Лейтан Александр. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var doubleTapRecognizer: UITapGestureRecognizer!
    
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: mapView)
        let location = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        
        
        guard let weatherInfoViewController = WeatherDetailsViewController.storyboardInstance() else { return }
        weatherInfoViewController.location = Coordinates(longitude: location.longitude, latitude: location.latitude)
        
        navigationController?.pushViewController(weatherInfoViewController, animated: true)
    }
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLocationServices()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        clearMap()
        tryUpdateLocation()
    }

    // MARK: - Private
    private func setUpLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }

    private func tryUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    private func clearMap() {
        mapView.removeAnnotations(mapView.annotations)
    }

    private func showLocationOnMap(location: CLLocationCoordinate2D, title: String?) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(region, animated: true)

        // Drop a pin at user's Current Location
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = location
        myAnnotation.title = title ?? ""
        mapView.addAnnotation(myAnnotation)
    }

    // MARK: - Private CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }

        manager.stopUpdatingLocation()

        let center = CLLocationCoordinate2D(
            latitude: locations[0].coordinate.latitude,
            longitude: locations[0].coordinate.longitude
        )
        showLocationOnMap(location: center, title: "Current Location")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

