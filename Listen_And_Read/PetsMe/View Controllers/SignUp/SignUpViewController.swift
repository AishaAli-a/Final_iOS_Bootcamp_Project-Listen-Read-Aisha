//
//  Register.swift
//  ProtoType_cookRec
//
//  Created by Aisha Ali on 11/20/21.
//

import Firebase
import UIKit

import FirebaseFirestore
import FirebaseAuth


class SignUpViewController:UIViewController{
  public var vc = UIViewController()
  let style = Style()
  
  @IBOutlet weak var register_Button: UIButton!
  @IBOutlet weak var name_View: UIView!
  @IBOutlet weak var password_View: UIView!
  @IBOutlet weak var confirmPassword_View: UIView!
  @IBOutlet weak var email_View: UIView!
  
  
  @IBOutlet weak var firstnameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var errorLabel: UILabel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    register_Button.layer.cornerRadius = 30
    style.viewStyle(name_View)
    style.viewStyle(password_View)
    style.viewStyle(confirmPassword_View)
    style.viewStyle(email_View)
    
  }
  
  func validateFields() -> String? {
    
    // Check that all fields are filled in
    if firstnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
      
      return "Please fill in all fields."
    }
    
   if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
        confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  {
  
  return "Your password do not match."
}
    
    // Check if the password is secure
    let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if Utilities.isPasswordValid(cleanedPassword) == false {
      // Password isn't secure enough
      return "Please make sure your password is at least 8 characters, contains a special character and a number."
    }
    
    return nil
  }
  
  
  
  
  @IBAction func button_Pressed(_ sender: UIButton) {
    
    if sender.tag == 0 {

      self.vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
      self.vc.modalPresentationStyle = .fullScreen
      self.present(self.vc,animated: false, completion: nil)

    }
    

    else if sender.tag == 2 {
      
      self.vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndServices") as! TermsAndServices
      //      vc.modalPresentationStyle = .fullScren
      self.present(self.vc,animated: false, completion: nil)
      //
    }
    
    //MARK: - Create new user
    let error = validateFields()
    
    if error != nil {
      
      showError(error!)
    }else {
      
      
      let firstName = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        
        // Check for errors
        if err != nil {
          
          // There was an error creating the user
          self.showError("Error creating user")
        }
        else {
          
          // User was created successfully, now store the first name and last name
          let db = Firestore.firestore()
          let id  = Auth.auth().currentUser?.uid
          db.collection("users").document(id!).setData( ["name":firstName, "uid": result!.user.uid ]) { (error) in
            
            if error != nil {
              // Show error message
              self.showError("Error saving user data")
            }
          }
          
          if sender.tag == 1 {
           //
           self.vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBar
           self.vc.modalPresentationStyle = .fullScreen
           self.present(self.vc,animated: false, completion: nil)

         }


        }
        
      }
    }
    

  }

  
  
  func showError(_ message:String) {
    
    errorLabel.text = message
    errorLabel.alpha = 1
  }
}
