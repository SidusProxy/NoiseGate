//
//  ContentView.swift
//  NoiseGate
//
//  Created by Gianluca Annina on 09/12/21.
//

import SwiftUI

 
struct ContentView: View {
    @ObservedObject private var mic = AudioVisualizer(numberOfSamples: numberOfSamples)
    private var audio:AudioRecorder = AudioRecorder()
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    @State var isPlaying = false
    @State var media:Float=0
    var body: some View {
        
        
        
        HStack{
            
            if (self.isPlaying){
                ForEach(mic.soundSamples, id: \.self) { level in
                    BarView(value: self.normalizeSoundLevel(level: level))
                }
                
            } else {}
        }.frame(height: 100)
            .padding(.bottom, 100)
        
        
        VStack{
            Text("cliccami tutto").onTapGesture {
                audio.startRecording()
                isPlaying.toggle()
                mic.startMonitoring()
            }
            Text("fermami tutto").onTapGesture {
                audio.stopRecording()
                isPlaying.toggle()

               media = mic.media
                print(media)
            }
        }
}


}





