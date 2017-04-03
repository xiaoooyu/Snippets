//
//  ViewController.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/21/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var data: [SnippetData] = [SnippetData]()
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // photo snippet editor delegate
        imagePicker.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50.0
        
        // tableview
        tableView.estimatedRowHeight = 100
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        askForLocationPermission()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func createNewSnippet(_ sender: Any) {
        let alert = UIAlertController(title: "Select a snippet type", message: nil, preferredStyle: .actionSheet)
        
        let textAction = UIAlertAction(title: "Text", style: .default) {
            (alert: UIAlertAction!) -> Void in
            self.createNewTextSnippet()
        }
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) {
            (alert: UIAlertAction!) -> Void in
            self.createNewPhotoSnippet();
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(textAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func createNewTextSnippet() {
        guard let textEntryVC =
            storyboard?.instantiateViewController(withIdentifier: "textSnippetEntry")
                as?	TextSnippetEntryViewController else {
                print("")
                return
        }
        
        textEntryVC.modalTransitionStyle = .coverVertical
        textEntryVC.saveText = {
            (text:String) in
            let newTextSnippet = TextData(text: text, creationDate: Date(), creationCoordinate: self.currentCoordinate!)
            self.data.append(newTextSnippet)
        }
        present(textEntryVC, animated: true, completion: nil)       
    }
    
    func createNewPhotoSnippet() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera is not available")
            return
        }
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func askForLocationPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("Image could not be found")
            return
        }
        
        let newPhotoSnippet = PhotoData(photo: image, creationDate: Date(), creationCoordinate: self.currentCoordinate!)
        self.data.append(newPhotoSnippet)
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let sortedData = data.reversed() as [SnippetData]
        let snippetData = sortedData[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        let dateString = formatter.string(from: snippetData.date)
        
        switch snippetData.type {
        case .text:
            cell = tableView.dequeueReusableCell(withIdentifier: "textSnippetCell", for: indexPath)
            (cell as! TextSnippetCell).label.text = (snippetData as! TextData).textData
            (cell as! TextSnippetCell).date.text = dateString
        case .photo:
            cell = tableView.dequeueReusableCell(withIdentifier: "photoSnippetCell", for: indexPath)
            (cell as! PhotoSnippetCell).photo.image = (snippetData as! PhotoData).photoData
        }
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager could not get location. Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            currentCoordinate = currentLocation.coordinate
            print("\(currentCoordinate!.latitude), \(currentCoordinate!.longitude)")
        }
        
    }
}
