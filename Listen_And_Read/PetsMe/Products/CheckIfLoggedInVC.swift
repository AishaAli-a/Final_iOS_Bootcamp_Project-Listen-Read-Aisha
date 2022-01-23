//
//  ViewController.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/18/21.
//

import UIKit
import Firebase



class CheckIfLoggedInVC: UIViewController {
  
  let idUsers = Auth.auth().currentUser?.uid
  
  override func viewDidLoad() {
    super.viewDidLoad()
 
  }
  
  //MARK: - Check if the user already logged in or not
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let storboard = UIStoryboard(name: "Main", bundle: nil)
    
    if idUsers == nil {
      let vc = storboard.instantiateViewController(withIdentifier: "SplashClass") as!  SplashClass
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: true, completion: nil)
      print("User is not logged In")
    }else{
      
      let vc = storboard.instantiateViewController(withIdentifier: "MainTabBar")  as! MainTabBar
      
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: true, completion: nil)
      print("User is  logged In")
    }
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    print("* * * * CheckIfLoggedInVC viewWillAppear * * *  ")
    
  }
  
  
  override func loadView() {
    super.loadView()
  }
}




