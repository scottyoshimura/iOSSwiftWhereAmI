//
//  ViewController.swift
//  whereAmI
//
//  Created by Scott Yoshimura on 4/30/15.
//  Copyright (c) 2015 west coast dev. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    //lets create a location manager with a type CLLocationManager()
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //lets get the users location when the app starts
        locationManager = CLLocationManager()
        //lets add some seettings for the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //we want to request use of locationManager when the app is running
        locationManager.requestWhenInUseAuthorization()
        //as long as the user gives us permission we can startUpdatingLocation
        locationManager.startUpdatingLocation()
        
    }
    
    //this method will be called everytime a new location is registered by the phone
    //locations is an array that is returned from the device
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //let's print the variable locations that we get from the method.
        println(locations)
        
        //create a new variable of type CLLocation, equals locations [0] as CLLocation, force downcast will work because type of ojbect taht is returned from locations. we use locations[0], because there are many locations being returned, and we just the first location returned by location manager.
        //by default, locations of an array of AnyObject, but we down cast it as a CLLocation so we can work with it.
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        //now that we have it as a CLLocation, we can extract the lati and longi
        //set the latitude label to equal the userlocation
        self.lblLatitude.text = "\(userLocation.coordinate.latitude)"
        
        self.lblLongitude.text = "\(userLocation.coordinate.longitude)"
        
        self.lblCourse.text = "\(userLocation.course)"
        
        self.lblSpeed.text = "\(userLocation.speed)"
        
        self.lblAltitude.text = "\(userLocation.altitude)"
        
        //geocoding is the process of going from an address or place name to a coordinates. reverse geocoding is the reverse, going from a lat to long and converting it to an address.
        
        //let's signify the location as userLocation
        //the array of AnyObject are our addresses, and they are known as placemarks in iOS, and return error if there is an error
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            //lets create a check an error message
            if (error != nil) {
                println(error)
            } else {
                //lets do a check and try to create a placemark from what has been returned from the method
                if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark){
                    //CLPlacemark is the method to create a placemark. again, like locations, we are getting alot of different potential addresses, and we can just use the first one
                    //placemarks is an array of AnyObjects, so we cast it as a CLPPlacemark
                    //placemarks is optional, so we use a question mark
                    
                    println(p)
                    
                    var subThoroughfare:String = ""
                    
                    //lets just do a check to see if subThouroughfare is present
                    if (p.subThoroughfare != nil) {
                        subThoroughfare = p.subThoroughfare
                    }
                    
                    self.lblAddress.text = "\(p.subThoroughfare) \n \(p.thoroughfare) \n \(p.subLocality) \n \(p.subAdministrativeArea) \n \(p.postalCode) \n \(p.country)"
                }

            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

