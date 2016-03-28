//
//  ViewController.swift
//  mySwiftMap
//
//  Created by Peter Yo on 3月/21/16.
//  Copyright © 2016年 Peter Hsu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//import MyImageAnnotationView.swift

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var isfirstLocationReceived : Bool = false
    
    @IBOutlet weak var mainMapView: MKMapView!

    @IBAction func mapTypeChange(sender: AnyObject) {
        let targetIndex = sender.selectedSegmentIndex
        //使用swithch去切換地圖的種類 maptype
        switch (targetIndex) {
        case 0:
            mainMapView.mapType = MKMapType.Standard
        case 1:
            mainMapView.mapType = MKMapType.Satellite
        case 2:
            mainMapView.mapType = MKMapType.Hybrid
            
        default:
            break;
        }

    }
    
    @IBAction func userTrackingChange(sender: AnyObject) {
        let targetIndex = sender.selectedSegmentIndex
        
        switch (targetIndex) {
        case 0:
           mainMapView.userTrackingMode = MKUserTrackingMode.None
        case 1:
           mainMapView.userTrackingMode = MKUserTrackingMode.Follow
        case 2:
           mainMapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        default:
            break;
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //locationManager.activityType() = CLActivityTypeAutomotiveNavigation
        
        locationManager.delegate = self;
        locationManager.startUpdatingLocation()
        mainMapView.delegate = self;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLocation = CLLocation()
        currentLocation = locations.last!
        NSLog("Current Location: %.6f,%.6f", currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
        //let firstLocationReceived : Bool = Bool() //初始化
        //var isfirstLocationReceived = Bool()
        
        if(isfirstLocationReceived == false) {
//            MKCoordinateRegion region = _theMapView.region;
            var region : MKCoordinateRegion = mainMapView.region
            region.center = currentLocation.coordinate;
            region.span.latitudeDelta = 0.04;
            region.span.longitudeDelta = 0.03;
//            [_theMapView setRegion:region animated:YES];
            mainMapView.setRegion(region, animated: true)
            isfirstLocationReceived = true
            
            // Add Annotation
            var annoationCoordinate : CLLocationCoordinate2D = currentLocation.coordinate
            annoationCoordinate.latitude += 0.0005;
            annoationCoordinate.longitude += 0.0005;
            
            //MKPointAnnotation *annotation = [MKPointAnnotation new];
            let annotation = MKPointAnnotation()
            annotation.coordinate=annoationCoordinate;
            annotation.title="肯德基";
            annotation.subtitle="真好吃🍗";
            
            mainMapView.addAnnotation(annotation)

        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation.isEqual(mapView.userLocation)) {
            return nil
        }
    
    let identifier = "KFC"
    
    var result = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
    if (result == nil) {
      //result = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];OC寫法
        result = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    } else {
        result?.annotation = annotation
    }
        
    //打開預設行為 改為true
    result?.canShowCallout = true
    //準備大頭針圖標的左邊小圖
    let image = UIImage(named: "pointRed.png")
    result?.leftCalloutAccessoryView = UIImageView(image:image)
        
    //準備大的右邊頭針
    let button = UIButton(type: UIButtonType.DetailDisclosure)
    button.addTarget(self, action: #selector(ViewController.buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    result?.rightCalloutAccessoryView = button
        //顯示自定義大頭針圖標
    result?.image = image
        
    return result
    }
    
    func buttonPressed(sender:UIButton) {
        let alert = UIAlertController(title: nil, message: "ButtonPressed", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}























