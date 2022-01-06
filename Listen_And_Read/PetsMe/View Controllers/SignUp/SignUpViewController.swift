//
//  Register.swift
//  ProtoType_cookRec
//
//  Created by Aisha Ali on 11/20/21.
//

import Foundation
import UIKit



class SignUpViewController:UIViewController{
  public var vc = UIViewController()
  let style = Style()
  
  @IBOutlet weak var register_Button: UIButton!
  @IBOutlet weak var name_View: UIView!
  @IBOutlet weak var password_View: UIView!
  @IBOutlet weak var confirmPassword_View: UIView!
  @IBOutlet weak var email_View: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    register_Button.layer.cornerRadius = 30
    style.viewStyle(name_View)
    style.viewStyle(password_View)
    style.viewStyle(confirmPassword_View)
    style.viewStyle(email_View)
    
    
  }
  
  @IBAction func button_Pressed(_ sender: UIButton) {
    print(#function)
    
        if sender.tag == 0 {
    
          vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
          vc.modalPresentationStyle = .fullScreen
          present(vc,animated: false, completion: nil)
          
        }else if sender.tag == 1 {
      //
      vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBar
      vc.modalPresentationStyle = .fullScreen
      present(vc,animated: false, completion: nil)
      
    } else if sender.tag == 2 {
      
      vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndServices") as! TermsAndServices
      //      vc.modalPresentationStyle = .fullScren
      present(vc,animated: false, completion: nil)
      //
    }
  }
  
  
  
  
}
//override func viewDidLoad() {
//  super.viewDidLoad()
//
//  setUpElements()
//
//  // Do any additional setup after loading the view.
//}
//
//
//func setUpElements(){
//  errorLabel.alpha = 0
//
//  Utilities.styleTextField(firstNameTextField)
//  Utilities.styleTextField(lastNameTextField)
//  Utilities.styleTextField(emailTextField)
//  Utilities.styleTextField(passwordTextField)
//  Utilities.styleButton(signUpButton)
//
//
//}
//func validateFields() -> String? {
//
//  // Check that all fields are filled in
//  if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//      lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//      emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//      passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//
//    return "Please fill in all fields."
//  }
//
//  // Check if the password is secure
//  let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//  if Utilities.isPasswordValid(cleanedPassword) == false {
//    // Password isn't secure enough
//    return "Please make sure your password is at least 8 characters, contains a special character and a number."
//  }
//
//  return nil
//}
//
//
//
//
//
//
//
////  @IBAction func signUpTapped(_ sender: UIButton) {
////    let error = validateFields()
////
////    if error != nil {
////
////      // There's something wrong with the fields, show error message
////      showError(error!)
////    }
////    else {
////
////      // Create cleaned versions of the data
////
////
////      let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
////      let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
////      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
////      let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
////
////      // Create the user
////      Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
////
////        // Check for errors
////        if err != nil {
////
////          // There was an error creating the user
////          self.showError("Error creating user")
////        }
////        else {
////
////          // User was created successfully, now store the first name and last name
////          let db = Firestore.firestore()
////
////          db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid ]) { (error) in
////
////            if error != nil {
////              // Show error message
////              self.showError("Error saving user data")
////            }
////          }
////
////          // Transition to the home screen
////          self.transitionToHome()
////        }
////
////      }
////
////
////
////    }
////  }
////
////  func showError(_ message:String) {
////
////    errorLabel.text = message
////    errorLabel.alpha = 1
////  }
////
////  func transitionToHome() {
////
////    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
////
////    view.window?.rootViewController = homeViewController
////    view.window?.makeKeyAndVisible()
////
////  }
////
////}
//}
