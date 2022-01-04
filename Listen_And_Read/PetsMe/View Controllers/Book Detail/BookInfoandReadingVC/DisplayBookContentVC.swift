//
//  File.swift
//  PetsMe
//
//  Created by Aisha Ali on 12/30/21.
//

import Foundation
import AVFoundation
import UIKit
var gender = "en-IE"

class DisplayBookContentVC: UIViewController {
  
  
  
  
  let synth = AVSpeechSynthesizer()
  let play = UIImage(systemName: "play")
  let pause = UIImage(systemName: "pause")
  var rate:Float!
  var pitch:Float!
  
  var currentRange: NSRange = NSRange(location: 0, length: 0)
  
  
  
  
  
  
  @IBOutlet weak var paly_Button: UIButton!
  
  @IBOutlet weak var bookContent: UITextView!
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    synth.delegate = self
  }
  
  
  func buildUtterance(for rate: Float,for pitch: Float = 1.0, with str: String) -> AVSpeechUtterance {
    let utterance = AVSpeechUtterance(string: str)
    utterance.rate = rate
    utterance.pitchMultiplier = pitch
    utterance.voice = AVSpeechSynthesisVoice(language: gender)
    return utterance
  }
  
  
  @IBAction func button_Pressed(_ sender: UIButton) {
    
    if sender.tag == 0 {
      
      if synth.isSpeaking {
        print("****Is Speaking \n\n")
      }
      
      else if  synth.isPaused {
        print("*****Is continue\n\n ")
        paly_Button.setImage(pause, for: .normal)
        synth.continueSpeaking()
        
      }
      
      
    }
    
    
    else if sender.tag == 1 {
      
      synth.speak(buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: bookContent.text!))
      
      if synth.isSpeaking {
        
        print("****Is Speaking \n\n")
        
        if synth.isPaused {
          
          print("*****Is continue\n\n ")
          paly_Button.setImage(pause, for: .normal)
          synth.continueSpeaking()
          
        }else {
          
          print("***** pause speaking \n\n")
          paly_Button.setImage(play, for: .normal)
          synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
      }
      print("****************\n**************\n\n\(gender)\n\n\n\n\n\n\n+++++++_________\n\n\n")
      
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
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n$$$$$$$$$$$$$ \(sender.value)\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n########################\n\n\n\n\n\n")
      }
      
      
    }
    
    
  }
}



extension DisplayBookContentVC: AVSpeechSynthesizerDelegate {
  
  private func attributedString(from string: String, highlighting characterRange: NSRange) -> NSAttributedString {
    
    guard characterRange.location != NSNotFound else {
      return NSAttributedString(string: string)
    }
    
    let mutableAttributedString = NSMutableAttributedString(string: string)
    mutableAttributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: characterRange)
    
    return mutableAttributedString
  }
  
  
  
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                         willSpeakRangeOfSpeechString characterRange: NSRange,
                         utterance: AVSpeechUtterance) {
    
    self.bookContent.attributedText = attributedString(from: utterance.speechString, highlighting: characterRange)
    bookContent.font = .systemFont(ofSize: 25)
    bookContent.textAlignment = .center
    bookContent.scrollRangeToVisible(makeCustomCharacterRange(from: characterRange))
    currentRange = characterRange
  }
  
  
  private func makeCustomCharacterRange(from characterRange: NSRange) -> NSRange {
    
    return NSRange(location: characterRange.location + 300, length: characterRange.length)
  }
  
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    
    self.bookContent.attributedText = NSAttributedString(string: utterance.speechString)
  }
  
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    
    self.bookContent.attributedText = NSAttributedString(string: utterance.speechString)
  }
}




