//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit
import MapKit

class ContactDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let user = user else {fatalError("no user passed")}
        
        let fullName = "\(user.name.title) \(user.name.first) \(user.name.last)"
        self.title = "\(user.name.title) \(user.name.last)"
        contactNameLabel.text = fullName
        contactEmailLabel.text = user.email
        contactPhoneNumberLabel.text = user.phone
        let urlString = user.picture.large
        guard let url = URL(string: urlString) else { return }
        
        do {
            let imageData = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.contactImageView.image = UIImage(data: imageData)
            }
            
        } catch {
            NSLog("Error fetching image: \(error)")
            return
        }
        
        openMapForPlace(user: user)
    }
    
    private func openMapForPlace(user: RandomUser) {

        // set initial location in Honolulu
        
        let latitude: CLLocationDegrees = Double(user.location.coordinates.latitude) ?? 0
        let longitude: CLLocationDegrees = Double(user.location.coordinates.longitude) ?? 0
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)

        let regionRadius: CLLocationDistance = 500000
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
    }
    
    
    // MARK: - Properties
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!

    @IBOutlet weak var latLongLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    var user: RandomUser?
    
    
    
}
