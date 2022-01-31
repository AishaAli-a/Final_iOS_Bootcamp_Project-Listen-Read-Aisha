//
//  File.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/30/21.
//

import Foundation
import AVFoundation
import UIKit
import Speech



class DisplayBookContentVC: UIViewController {
  
  let textField = UITextField()
  
  var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: gender))
  var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  var recognitionTask: SFSpeechRecognitionTask?
  let audioEngine = AVAudioEngine()
  var timer1:Timer!
  //
  
  var messagesString = [String]()
  var fullMessageString = ""
  var singleMessageString = ""
  
  //
  let synth = AVSpeechSynthesizer()
  let play = UIImage(systemName: "play")
  let pause = UIImage(systemName: "pause")
  var rate:Float!
  var pitch:Float!
  
  var currentRange: NSRange = NSRange(location: 0, length: 0)
  
  
  
  
  // USER Start To Record and Give Command
  @IBOutlet weak var speechbutton: UIButton!
  
  // USER Start To Record and Give Command
  
  @IBOutlet weak var paly_Button: UIButton!
  
  //Displaying book Content
  @IBOutlet weak var bookContent: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    bookContent.text = nil
    bookContent.isEditable = false
    speechRecognizer?.delegate = self
    synth.delegate = self
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    self.synth.stopSpeaking(at: .immediate)

  }
  
  // Speech  Synth
  func buildUtterance(for rate: Float,for pitch: Float = 1.0, with str: String) -> AVSpeechUtterance {
    
    let utterance = AVSpeechUtterance(string: str)
    utterance.rate = rate
    utterance.pitchMultiplier = pitch
    utterance.voice = AVSpeechSynthesisVoice(language: gender)
    return utterance
  }
  
  
  @IBAction func button_Pressed(_ sender: UIButton) {
    
    if sender.tag == 0 {
      
      //      self.synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
      
      print("Button pressed")
      if audioEngine.isRunning {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        speechbutton.isEnabled = false
        speechbutton.setTitle("Stopping", for: .disabled)
      } else {
        do {
          try startRecording()
          speechbutton.setTitle("Stop Recording", for: [])
        } catch {
          speechbutton.setTitle("Recording Not Available", for: [])
        }
      }
      
      
      
      
      
      
      
      
      
    }else if  synth.isPaused {
      print("*****Is continue\n\n ")
      paly_Button.setImage(pause, for: .normal)
      synth.continueSpeaking()
      
    }else if sender.tag == 1 {
      
      synth.speak(buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: bookContent.text!))
      
      if synth.isSpeaking {
        
        print("****Is Speaking \n\n")
        
        if synth.isPaused {
          
          print("***** Is continue\n\n ")
          paly_Button.setImage(pause, for: .normal)
          synth.continueSpeaking()
          
        }else {
          
          print("***** pause speaking \n\n")
          paly_Button.setImage(play, for: .normal)
          synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
      }
      
      
    } else if sender.tag == 2 {
      
      
    }
  }
  
  
  @IBAction func sliderChanged(_ sender: UISlider) {
    
    if sender.tag == 0 {
      synth.stopSpeaking(at: .immediate)
      if currentRange.length > 0 {
        
        synth.speak(buildUtterance(for: sender.value,  with: bookContent.text))
        
      }
    } else if sender.tag == 1 {
      synth.stopSpeaking(at: .immediate)
      if currentRange.length > 0 {
        
        synth.speak(buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, for: sender.value , with: bookContent.text))
      }
    }
  }
}

extension UITextField {
  @discardableResult
  func textIsContained(in target: String) -> Bool {
    guard let text = self.text else { return false }
    
    let isContained = target.contains(text)
    if isContained {
      print(" contains \(text)")
      
    } else {
      print("- - - - - \n- - - - Not Contained")
    }
    
    return isContained
    
  }
}
