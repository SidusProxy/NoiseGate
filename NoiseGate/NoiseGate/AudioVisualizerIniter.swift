//
//  AudioVisualizer.swift
//  Test2.0
//
//  Created by Vito Gallo on 23/11/21.
//

import Foundation
import AVFoundation
import SwiftUI
import AudioKit
class AudioVisualizer: ObservableObject {
    
     var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    private var currentSample: Int
    
    private let numberOfSamples: Int
    var media:Float = 0
    var somma:Float = 0
    var npassaggi: Float = 0
    
    @Published public var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }
        
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
//            startMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
     func startMonitoring() {
        self.somma=0
        self.media=0
        self.npassaggi=0
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            
            self.audioRecorder.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
            self.somma = self.somma + 0 +  self.audioRecorder.averagePower(forChannel: 0)
            self.npassaggi = self.npassaggi + 1
            self.media = self.somma/self.npassaggi
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
    }
    
    
    deinit {
        timer?.invalidate()
        audioRecorder.stop()
    }
    
    
}
