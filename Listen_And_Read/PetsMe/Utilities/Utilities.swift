//
//  Utilities.swift
//  
//
//  Created by Aisha Ali on 12/16/21.
//

import Foundation
import UIKit


class Utilities {
  
  static func styleTextField(_ textField:UITextField){
    
    
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: textField.frame.height, width: textField.frame.width, height: 2)
    
    
    bottomLine.backgroundColor = UIColor.cmOrange3.cgColor
    textField.borderStyle = .none
    
    textField.layer.addSublayer(bottomLine)
  }
  
  static func styleUILabel(_ label:UILabel){
    
    
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: label.frame.height, width: label.frame.width, height: 2)
    
    bottomLine.backgroundColor = UIColor.cmOrange3.cgColor
    label.layer.addSublayer(bottomLine)
  }
  
  
  static func styleButton (_ button:UIButton){
    button.layer.cornerRadius = 30
    
  }
  
  
  static func isPasswordValid(_ password : String) -> Bool {
      
      let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
      return passwordTest.evaluate(with: password)
  }
  
}
