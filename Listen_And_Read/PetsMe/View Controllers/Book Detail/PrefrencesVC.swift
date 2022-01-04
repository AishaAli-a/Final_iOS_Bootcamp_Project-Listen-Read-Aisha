//
//  PrefrencesVC.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/3/22.
//

import UIKit
import AVFoundation

class PrefrencesVC: UIViewController {
  
  
  
  @IBOutlet weak var audio_Pitch: UISlider!
  @IBOutlet weak var audio_Rate: UISlider!
  @IBOutlet weak var segment_Control: UISegmentedControl!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  
  
  
  
  @IBAction func saveNewValues(_ sender: UIButton) {
    
    switch segment_Control.selectedSegmentIndex{
      
    case 0 :
      gender = "en-AU"     //Female
      break;
    case 1 :
      gender = "en-gb" //Male
      break;
    default:
      gender = "en-IE"

    }

  }
  
  
  
  
  
  
  
  @IBAction func changeRateOfSpeed(_ sender: UISlider) {
    

    
    
  }
  
  
  
  
  

  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
