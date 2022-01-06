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


var gender = "en-IE"

class DisplayBookContentVC: UIViewController {
  
  
  
  private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: gender))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  var timer1:Timer!
  //
  
  var messagesString = [String]()
  var fullMessageString = ""
  var singleMessageString = ""
  var finalCommands = ""
  var name = "NULL"
  var isSetName = false
  
  //
  let synth = AVSpeechSynthesizer()
  let play = UIImage(systemName: "play")
  let pause = UIImage(systemName: "pause")
  var rate:Float!
  var pitch:Float!
  
  var currentRange: NSRange = NSRange(location: 0, length: 0)
  
  
  
  
  
  @IBOutlet weak var speechbutton: UIButton!
  
  @IBOutlet weak var paly_Button: UIButton!
  
  @IBOutlet weak var bookContent: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bookContent.text = nil
    speechRecognizer?.delegate = self
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
      
      self.synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
      
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





extension DisplayBookContentVC: SFSpeechRecognizerDelegate{
  
  private func startRecording() throws {
    
    recognitionTask?.cancel()
    self.recognitionTask = nil
    
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    let inputNode = audioEngine.inputNode
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
    recognitionRequest.shouldReportPartialResults = true
    
    if #available(iOS 13, *) {
      recognitionRequest.requiresOnDeviceRecognition = false
    }
    
    recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest) { result, error in
      
      var isFinal = false
      isFinal = false
      if let result = result {
        self.singleMessageString = self.fullMessageString
        isFinal = result.isFinal
        let word = result.bestTranscription.formattedString
        self.fullMessageString = word
        let lastWord = self.fullMessageString.replacingOccurrences(of: self.singleMessageString, with: "")
        
        
        
        //MARK: - calling Type of Functions depending on speech
        if (lastWord.contains("start") || lastWord.contains("Start")){
          self.synth.speak(self.buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: self.bookContent.text!))
          //          self.stopRecording()
          
        }
        
        if (lastWord.contains("stop") || lastWord.contains("Stop")){
          self.synth.stopSpeaking(at: .immediate)
                    self.stopRecording()
          
        }
        
        if (lastWord.contains("pause") || lastWord.contains("pause")){
          self.synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
          //          self.stopRecording()
        }
        
        if (lastWord.contains("continue") || lastWord.contains("Continue")){
          self.synth.continueSpeaking()
          //          self.stopRecording()
        }
        
        if (lastWord.contains("change") || lastWord.contains("change")){
          gender = "en-gb"
          self.synth.stopSpeaking(at: .immediate)
          self.synth.speak(self.buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: self.bookContent.text!))
          Voice().read(text: "your default have been changed")
        }
        else if (lastWord.contains("female") || lastWord.contains("Female")){
          gender = "en-IE"
          self.synth.stopSpeaking(at: .immediate)
          Voice().read(text: "your default have been changed")
        }
    }
    
    //MARK: - StopRecording
    if isFinal {
      self.audioEngine.stop()
      inputNode.removeTap(onBus: 0)
      
      self.recognitionRequest = nil
      self.recognitionTask = nil
      
      self.speechbutton.isEnabled = true
    }else if error == nil || isFinal {
      self.stopRecording()
    }
  }
  
  // Configure the microphone input.
  let recordingFormat = inputNode.outputFormat(forBus: 0)
  inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
    self.recognitionRequest?.append(buffer)
  }
  audioEngine.prepare()
  try audioEngine.start()
}

func stopRecording() {
  
  timer1?.invalidate()
  timer1 = Timer.scheduledTimer(withTimeInterval:1, repeats: false, block: {
    (timer) in
    self.audioEngine.stop()
    self.audioEngine.inputNode.removeTap(onBus: 0)
    
    self.recognitionRequest = nil
    self.recognitionTask = nil
    
    self.speechbutton.isEnabled = true
  })
}






}






