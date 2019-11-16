//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by apple on 16.11.2019.
//  Copyright © 2019 Mustafa KILINÇ. All rights reserved.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    var placesNameArray = [String]()
    var placesIdArray = [String]()
    var selectedPlaceId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(LogOutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    
    func getDataFromParse()
    {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", MessageInput: error?.localizedDescription ?? "Error")
            }
            else
            {
                if objects != nil
                {
                    self.placesNameArray.removeAll()
                    self.placesIdArray.removeAll()
                    
                    for object in objects!
                    {
                        if let placeName = object.object(forKey: "name") as? String
                        {
                            if let placeId = object.objectId
                            {
                                self.placesNameArray.append(placeName)
                                self.placesIdArray.append(placeId)
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    @objc func addButtonClicked()
    {
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    @objc func LogOutButtonClicked()
    {
        PFUser.logOutInBackground { (error) in
            
            
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", MessageInput: error?.localizedDescription ?? "Error")
            }
            else
            {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"
        {
            let destinaionVC = segue.destination as! DetailsVC
            destinaionVC.choosenPlacesId = selectedPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placesIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placesNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNameArray.count
    }
    
    func makeAlert(titleInput: String, MessageInput: String)
    {
        let alert = UIAlertController(title: titleInput, message: MessageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
  
    

    

}
