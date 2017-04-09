//
//  ViewController.swift
//  Snippets
//
//  Created by Yin Xiaoyu on 3/21/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import UIKit
import Social
import CoreData

class ViewController: UIViewController {

    var data: [NSManagedObject] = [NSManagedObject]()
    let imagePicker = UIImagePickerController()
    var shareButton: (() -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // photo snippet editor delegate
        imagePicker.delegate = self
        
        // tableview
        tableView.estimatedRowHeight = 100
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadSnippetData()
        tableView.reloadData()
    }
    
    func reloadSnippetData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Snippet")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResult = try managedContext.fetch(request)
            self.data = fetchResult as! [NSManagedObject]
        } catch {
            let e = error as NSError
            print("Unresolved error \(e), \(e.userInfo)")
        }
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
            self.saveTextSnippet(text: text)
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
    
    func saveTextSnippet(text: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        let desc = NSEntityDescription.entity(forEntityName: "TextSnippet", in: managedContext)
        let textSnippet = NSManagedObject(entity: desc!, insertInto: managedContext)
        
        textSnippet.setValue(SnippetType.text.rawValue, forKey: "type")
        textSnippet.setValue(text, forKey: "text")
        textSnippet.setValue(NSDate(), forKey: "date")
        
        delegate.saveContext()
    }
    
    func savePhotoSnippet(photo: UIImage) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        let desc = NSEntityDescription.entity(forEntityName: "PhotoSnippet", in: managedContext)
        let photoSnippet = NSManagedObject(entity: desc!, insertInto: managedContext)
        let photoData = UIImagePNGRepresentation(photo)
        
        photoSnippet.setValue(SnippetType.photo.rawValue, forKey: "type")
        photoSnippet.setValue(NSDate(), forKey: "date")
        photoSnippet.setValue(photoData, forKey:"photo")
        
        delegate.saveContext()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("Image could not be found")
            return
        }
        
        savePhotoSnippet(photo: image)
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
        
        let snippetData = data[indexPath.row]
        let snippetDate = snippetData.value(forKey: "date") as! Date
        let snippetType = SnippetType(rawValue: snippetData.value(forKey: "type") as! String)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        let dateString = formatter.string(from: snippetDate)
        
        switch snippetType {
        case .text:
            let snippetText = snippetData.value(forKey: "text") as! String
            
            cell = tableView.dequeueReusableCell(withIdentifier: "textSnippetCell", for: indexPath)
            
            
            (cell as! TextSnippetCell).label.text = snippetText
            (cell as! TextSnippetCell).date.text = dateString
            (cell as! TextSnippetCell).shareButton = {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    let text = snippetText
                    guard let twVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
                        print("Couldn't create twitter compse controller")
                        return
                    }
                    
                    if text.characters.count <= 140 {
                        twVC.setInitialText("\(text)")
                    } else {
                        let tweetLengthIndex = text.index(text.startIndex, offsetBy: 140)
                        let tweetChars = text.substring(to: tweetLengthIndex)
                        twVC.setInitialText("\(tweetChars)")
                    }
                    
                    self.present(twVC, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "You are not logged into twitter",
                                message: "Please login Twitter from the iOS settings app.",
                                preferredStyle: .alert)
                    let dissmissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(dissmissAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        case .photo:
            let snippetPhoto = UIImage(data: snippetData.value(forKey: "photo") as! Data)
            
            cell = tableView.dequeueReusableCell(withIdentifier: "photoSnippetCell", for: indexPath)
            
            (cell as! PhotoSnippetCell).photo.image = snippetPhoto
            (cell as! PhotoSnippetCell).date.text = dateString
            (cell as! PhotoSnippetCell).shareButton = {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    let photo = snippetPhoto
                    guard let twVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
                        print("Couldn't create Twitter compose controller")
                        return
                    }
                    
                    twVC.setInitialText("Send from Snippet™")
                    twVC.add(photo)
                    self.present(twVC, animated: true, completion: nil)
                    
                } else {
                    let alert = UIAlertController(title: "You are not logged into twitter",
                                                  message: "Please login Twitter from the iOS settings app.",
                                                  preferredStyle: .alert)
                    let dissmissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(dissmissAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return cell
    }
}

