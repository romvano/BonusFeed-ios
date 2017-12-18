//
//  Maps.swift
//  main client
//
//  Created by Daria Firsova on 16.11.2017.
//  Copyright © 2017 Daria Firsova. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapsView: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    var locationManager : CLLocationManager! = CLLocationManager()
    var startLocation: CLLocation!
    var flag = true
    

    @IBAction func myLocation(_ sender: Any) {
        flag = true
        startLocation = nil
        locationManager.startUpdatingLocation()
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if flag
        {
            let location = locations[0] //самое последнее местоположение
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.007, 0.007) // увеличение карты
            let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region1:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
            
            map.setRegion(region1, animated: true)
            
      
            self.map.showsUserLocation = true
            flag = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //положение по координатам, для мест
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.007, 0.007) // увеличение карты
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(55.795932, 37.804852)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        //для отметки
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "pin"
        annotation.subtitle = "10-20"
        //annotation.image
        
        map.addAnnotation(annotation)
        
        //местоположение пользователя
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //let pin = MKPinAnnotationView()
       // map.addAnnotation(pin)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // here we have all props
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
