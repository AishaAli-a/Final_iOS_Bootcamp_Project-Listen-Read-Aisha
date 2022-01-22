//
//  ViewController.swift
//  ProtoType_cookRec
//
//  Created by Aisha Ali on 11/20/21.
//

import UIKit
import SwiftUI

class MainVC: UIViewController {
  
  var timer:Timer!
  public var vc = UIViewController()

  @IBOutlet weak var register_btn: UIButton!
  @IBOutlet weak var descrribe_label: UILabel!
  @IBOutlet weak var imageview: UIImageView!
  @IBOutlet weak var description_Label: UILabel!
  
  var customLabele:CustomLabel = CustomLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageview.image = UIImage(named: "Knowledge-bro")
    description_Label.text = "Read and Listen"
    descrribe_label.text = "Everything for comfortable reading\nlistening of your favorite free books."

    register_btn.layer.cornerRadius = 30
    descrribe_label.adjustsFontSizeToFitWidth = true
    descrribe_label.minimumScaleFactor = 0.5
    description_Label.adjustsFontSizeToFitWidth = true
    description_Label.minimumScaleFactor = 0.5
    register_btn.titleLabel?.adjustsFontSizeToFitWidth = true
    register_btn.titleLabel?.minimumScaleFactor = 0.5


  }
  
  
  @IBAction func button_pressed(_ sender: UIButton) {
//    print(#function)
    if sender.tag == 0 {
      
      vc = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! SignUpViewController
      vc.modalPresentationStyle = .fullScreen
      present(vc,animated: false, completion: nil)
      
    } else {
      
      vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
      vc.modalPresentationStyle = .fullScreen
      present(vc,animated: false, completion: nil)
      
    }
    
    
  }
  
  
  
  
  
  
  
  
  
  
  
}
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//struct SwiftLeeViewRepresentable: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!.view
//    }
//
//    func updateUIView(_ view: UIView, context: Context) {
//
//    }
//}
//
//@available(iOS 13.0, *)
//struct SwiftLeeViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        SwiftLeeViewRepresentable()
//    }
//}
//#endif
  


