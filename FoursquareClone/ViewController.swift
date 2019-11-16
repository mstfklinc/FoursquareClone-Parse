//
//  ViewController.swift
//  FoursquareClone
//
//  Created by apple on 16.11.2019.
//  Copyright © 2019 Mustafa KILINÇ. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
    }
    
    
    @IBAction func signInCliked(_ sender: Any) {
        
        if usernameText.text != nil && passwordText.text != nil
        {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (user, error) in
                
                if error != nil
                {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }
                else
                {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
                
            }
        }
        else
        {
            self.makeAlert(titleInput: "Error!", messageInput: "Username/Password")
        }
        
    }
    
    
    @IBAction func signUpCliked(_ sender: Any) {
        
        if usernameText.text != nil && passwordText.text != nil
        {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { (success, error) in
                
                if error != nil
                {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Username/Password")
                }
                else
                {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
                
            }
            
        }
        else
        {
            self.makeAlert(titleInput: "Error!", messageInput: "Username/Password")
        }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Error!", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

