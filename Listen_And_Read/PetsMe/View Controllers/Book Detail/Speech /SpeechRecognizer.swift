//
//  File.swift
//  PetsMe
//
//  Created by Aisha Ali on 1/25/22.
//

import Foundation
import AVFoundation
import Speech

extension DisplayBookContentVC: SFSpeechRecognizerDelegate{
  
  //EXCEPTION IN CASE SOMTHING HAPPEND
  
   func startRecording() throws {
    
    recognitionTask?.cancel()
    recognitionTask = nil
    
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
        
        // هنا ايش سويت !!!!!!!!!!!!!!!!!!!!
        let lastWord = self.fullMessageString.replacingOccurrences(of: self.singleMessageString, with: "")
        print("\n\n\n\n\n\n- - - - - - LAST WORD :\(lastWord)")
//        print("\n\n\n\n\n\n- - - - - -word :\(word)")
//        print("\n\n\n\n\n\n- - - - - -result :\(result)")


        
        
        
        //MARK: - Speech Command
        
        if (lastWord.contains("Start") || lastWord.contains("start")){
          self.synth.speak(self.buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: self.bookContent.text!))
          
        }
        
        if (lastWord.contains("stop") || lastWord.contains("Stop")){
          self.synth.stopSpeaking(at: .immediate)
          self.stopRecording()
          
        }
        
        if (lastWord.contains("pause") || lastWord.contains("Pause")){
          self.synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
          //          self.stopRecording()
        }
        
        if (lastWord.contains("continue") || lastWord.contains("Continue")){
          self.synth.continueSpeaking()
          //          self.stopRecording()
        }
        
        if (lastWord.contains("Male") || lastWord.contains("Mail")){
          self.synth.stopSpeaking(at: .immediate)
          gender = "en-gb"
          self.synth.speak(self.buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: self.bookContent.text!))
          //          Voice().read(text: "your default have been changed")
        }
        else if (lastWord.contains("Female") || lastWord.contains("female")){
          gender = "en-IE"
          self.synth.stopSpeaking(at: .immediate)
          self.synth.speak(self.buildUtterance(for: AVSpeechUtteranceDefaultSpeechRate, with: self.bookContent.text!))
          
          
          // Search should be here
          
          //TODO: -
        } else if (lastWord.contains("Search") || lastWord.contains("search")){

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
    timer1 = Timer.scheduledTimer(withTimeInterval:0.1, repeats: false, block: {
      (timer) in
      self.audioEngine.stop()
      self.audioEngine.inputNode.removeTap(onBus: 0)
      
      self.recognitionRequest = nil
      self.recognitionTask = nil
      
      self.speechbutton.isEnabled = true
    })
  }
}






