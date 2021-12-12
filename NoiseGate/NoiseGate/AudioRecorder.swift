//
//  AudioRecorder.swift
//  Test2.0
//
//  Created by Giuseppe Carannante on 17/11/21.
//

import UIKit
import AVFoundation
import SwiftUI
import Combine

class AudioRecorder: NSObject,ObservableObject {
    
    override init() {
        super.init()
        fetchRecordings()
    }
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    
    func startRecording() {
        print("sto recprdando")
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("analizzamitutto.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            audioRecorder.updateMeters()
         

            recording = true
        } catch {
            print("Could not start recording")
        }
        
    }
    
    func deleteRecording(url: URL){
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Could not delete file: \(error)")
        }
        
    }
    func fetchRecordings() {
        recordings.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio)
            recordings.append(recording)
        }
        
        objectWillChange.send(self)
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        fetchRecordings()
        print(recordings.count)
    }
}
struct Recording {
    let fileURL: URL
}
