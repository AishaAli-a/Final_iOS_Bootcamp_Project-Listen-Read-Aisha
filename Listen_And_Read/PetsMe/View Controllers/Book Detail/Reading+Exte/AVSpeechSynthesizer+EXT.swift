//
//  BookContent+Exten.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/1/22.
//

import UIKit
import AVFoundation

enum ButtonType: Int {
    case slow = 0, fast, highPitch, lowPitch, echo, reverb
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


