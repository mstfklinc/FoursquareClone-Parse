//
//  MapVC.swift
//  FoursquareClone
//
//  Created by apple on 16.11.2019.
//  Copyright © 2019 Mustafa KILINÇ. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var choosenLatitude = ""
    var choosenLongitude = ""
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))

        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButtonClicked()
    {
        let placesModel = PlaceModel.sharedInstace
        let object = PFObject(className: "Places")
        object["name"] = placesModel.placeName
        object["type"] = placesModel.placeType
        object["atmosphere"] = placesModel.placeAtmosphere
        object["latitude"] = placesModel.placesLatitude
        object["longitude"] = placesModel.placeLongitude
        
        if let imageData = placesModel.placeImage.jpegData(compressionQuality: 0.5)
        {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
            
        }
        
        object.saveInBackground { (success, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    
    @objc func backButtonClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizer.State.began
        {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstace.placeName
            annotation.subtitle = PlaceModel.sharedInstace.placeType
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstace.placesLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstace.placeLongitude = String(coordinates.longitude)
            
        }
    }
    

    

}
