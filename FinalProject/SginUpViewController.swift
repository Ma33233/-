//
//  SginUpViewController.swift
//  FinalProject
//
//  Created by AlenaziHazal on 16/02/1444 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class SginUpViewController: UIViewController {
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var Note: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelErorrDisplay: UILabel!
    @IBOutlet weak var passwordTextEnter: UITextField!
    @IBOutlet weak var UsernameTextEnter: UITextField!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var labelRePassowrd: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var RePasswordTextEnter: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var emailTextEnter: UITextField!
    @IBOutlet weak var labelBackOrDismiss: UILabel!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    let userDefault = UserDefaults.standard
    let dbAuthRef = Auth.auth()
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.layer.cornerRadius = 40
        signUpBtn.layer.cornerRadius = 24

        setupElements()
    }
    @IBAction func sginUpButten(_ sender: Any) {
        signUp()
    }
    @IBAction func dismissButten(_ sender: Any) {
    }
    
    func setupElements(){
        // Hide the error label
        labelErorrDisplay.alpha = 0
        labelErorrDisplay.textColor = .red
        
        // Styling elements
        Utilities.styleTextField(emailTextEnter)
        Utilities.styleTextField(UsernameTextEnter)
        Utilities.styleTextField(passwordTextEnter)
        Utilities.styleTextField(RePasswordTextEnter)
    }
    
    func signUp(){
//        // Validates fields is in the way we want.
       let checking =  validateFields()
        guard checking == nil else {
            showError(checking!)
            return
        }
        
//         Create the user
        dbAuthRef.createUser(withEmail: (emailTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines))!, password: (passwordTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) { result, error in
            // check if there is an error creating the user
            guard error == nil else{
                self.showError(error!.localizedDescription)
                return
            }

            // create cleaned fields
            let userName = self.UsernameTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            // User craeted successfully.
            self.db.collection("Users").document(result!.user.uid).setData(
                ["userName" : userName!]) { error in
                     guard error == nil else {
                         self.showError("Error creating user, check your network please!")
                         return
                     }
                    self.userDefault.set((self.emailTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines))!, forKey: "email")
                    self.userDefault.set(self.passwordTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
                    
                    self.successfulCreating()
                 }
            
            self.db.collection("userNames").document(userName!).setData(["userID" : self.dbAuthRef.currentUser?.uid as Any])

        }
    }
    
    func validateFields() -> String?{
        guard emailTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && UsernameTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && passwordTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && RePasswordTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return "Please fill in all the fields"
        }
        guard Utilities.isEmailValid(emailTextEnter.text!) == true else{
            return "Invalid email"
        }

        guard Utilities.isPasswordValid(passwordTextEnter.text!) == true else{
            return "Please make sure your password is at least 8 characters, contains a number and a special character"
        }
        
        guard Utilities.isPasswordsMatched(passwordTextEnter.text!, RePasswordTextEnter.text!) == true else{
            return "Passwords did not match"
        }
        
//        guard Utilities.isUsernameUsed((UsernameTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) == false else{
//            return "Username is exist, use different username"
//        }
        
        return nil
    }
    
    func showError(_ msg: String){
    labelErorrDisplay.text = msg
    labelErorrDisplay.alpha = 1
}
    
    func successfulCreating(){
        let alert = UIAlertController(title: "Successful", message: "New user has been created successfuly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)

//                        handler: { _ in
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
//            self.present(vc!, animated: true)
//
//        }))
//        self.present(alert, animated: true)
//    }
        }
}
