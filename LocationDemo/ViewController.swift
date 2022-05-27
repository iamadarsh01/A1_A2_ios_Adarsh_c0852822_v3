
//  ViewController.swift
//  Lab test 1 & 2
//
//  Created by Adarsh Bhatia c0852822

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate , UIGestureRecognizerDelegate {
    
    lazy var locationManager: CLLocationManager = {
            var manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            return manager
        }()
    
    @IBOutlet weak var mapView : MKMapView! 
    var arrCoordinates = [CLLocationCoordinate2D]()
    var arrCoordinatesSecond = [CLLocationCoordinate2D]()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(tapGestureDetected(gesture:)))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    
    
    //Placing Three markerss in three different locations
    
    
    //let lat : CLLocationDegrees = 43.64
   //   let lng : CLLocationDegrees = -79.38
      
    //  let lat_two : CLLocationDegrees = 44.38
    //  let lng_two : CLLocationDegrees = -79.69
      
     // let lat_three : CLLocationDegrees = 43.89
    //  let lng_three : CLLocationDegrees = -78.86
      
     /*displayLocation(latitude: lat, longitude: lng, title: "Toronto", subtitle: "CL")
      displayLocation(latitude: lat_two, longitude: lng_two, title: "Barrie", subtitle: "CL2")
      displayLocation(latitude: lat_three, longitude: lng_three, title: "Oshawa", subtitle: "CL3")*/
      
    
    
    
    
    @objc func tapGestureDetected(gesture : UITapGestureRecognizer) {
        let touchPoint = gesture.location(in:mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom:mapView)
        
        if arrCoordinates.count < 3 {
            if arrCoordinates.count == 0 {
                self.arrCoordinatesSecond.append(coordinates)
            }
            self.arrCoordinates.append(coordinates)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = self.getAnnotationTitle(count:arrCoordinates.count)
            mapView.addAnnotation(annotation)
        }
        
        if arrCoordinates.count > 1 {

            let routeLine = MKPolyline(coordinates:arrCoordinates, count:arrCoordinates.count)
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
            self.mapView.addOverlay(routeLine)
            
            if arrCoordinates.count == 3 {
                self.arrCoordinates.append(contentsOf: arrCoordinatesSecond)
                let routeLine = MKPolyline(coordinates:arrCoordinates, count:arrCoordinates.count)
                self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
                self.mapView.addOverlay(routeLine)
            }

        }
    }
    
    
    
    //Giving names to all the annotations
    func getAnnotationTitle(count : Int) -> String {
        switch count {
        case 1:
            return "Place A"
        case 2:
            return "Place B"
        case 3:
            return "Place C"
        
            
            default:
            return  " "
        }
    }
    
    
    

    func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.first {
            let center = location.coordinate
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
            
            
        self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    //Drawing lines between annotations
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            
            
            //For Showing the green color polyline
            polylineRenderer.strokeColor = .green
            polylineRenderer.fillColor = .red
            polylineRenderer.lineWidth = 10
            return polylineRenderer
        }
        
        else if overlay is MKPolygon{
            let polyrendrer = MKPolygonRenderer(overlay: overlay)
                       // polyrendrer.fillColor = UIColor.red.withAlphaComponent(0.6)
                        polyrendrer.strokeColor = UIColor.yellow
            polyrendrer.alpha = 0.5
    
                        polyrendrer.lineWidth = 3
                        return polyrendrer
        }
        
        else if overlay is MKCircle{
            let circlerendrer = MKCircleRenderer(overlay: overlay)
                     //   circlerendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            circlerendrer.strokeColor = UIColor.green
            circlerendrer.lineWidth = 2
            circlerendrer.alpha = 0.5
                        return circlerendrer
        }
        
        
        
        
        
        
        
        return MKOverlayRenderer()
    }
    
   

    
    //Calculating the distance between markers
   // let distance = CLLocationDistance.from
    
    //
    
    
}
