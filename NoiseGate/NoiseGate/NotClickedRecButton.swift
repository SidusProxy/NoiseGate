//
//  NotClickedRecButton.swift
//  NoiseGate
//
//  Created by Gianluca Annina on 10/12/21.
//

import SwiftUI
import AudioKitUI
let numberOfSamples: Int = 10

struct NotClickedRecButton: View {
    
    
    @State var clickinternal = false
    @State var clickexternal = false
    @ObservedObject private var mic = AudioVisualizer(numberOfSamples: numberOfSamples)
    private var audio:AudioRecorder = AudioRecorder()
    
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (100 / 25)) // scaled to max at 300 (our height of our bar)
    }
    @State var isPlaying = false
    @State var media:Float=0
    @State var changeView:Bool = false
    let arraycitazioni:[String] = ["I think you will find/When your death takes its toll/All the money you made/Will never buy back your soul…","Take a sad song, and make it better…","The pussy is like this, what are you gonna do, nine months to get out and life to get back in","The game of life is hard to play/I’m going to lose it anyway…","Take me out, tonight…","They paved paradise, and put up a parking lot…","That’s great, it starts with an earthquake, birds and snakes…","I'm a man of wealth and taste \n I've been around for a long, long years \n Stole many a man's soul and faith","I’ve been reading books of old \n The legends and the myths \n The testaments they told \n The moon and its eclipse","And trust me I’ll give it a chance now \n Take my hand, stop, put Van the Man on the jukebox \n And then we start to dance, and now I’m singing like","We are just like the waves that flow back and forth \n Sometimes I feel like I’m drowning \n And you’re there to save me","I was choking in the crowd \n Living my brain up in the cloud \n Falling like ashes to the ground"]
    @State var indicearray=0
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.black.ignoresSafeArea()
                NavigationLink(destination: ResultView(media: $media), isActive: $changeView) { EmptyView() }
                if (self.isPlaying){
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            HStack{
                                ForEach(mic.soundSamples, id: \.self) { level in
                                    BarView(value: self.normalizeSoundLevel(level: level))
                                }
                            }.frame(width: 150,height: 150)
                            
                            RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), center: .center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5, endRadius: 110).mask(Image(systemName: "circle").resizable().frame(width: 150.0, height: 150.0).imageScale(.large)).frame(width: 150.0, height: 150.0)
                           
                            
                        }.frame(width: 50,height: 100)
                            .padding(.bottom, 100)
                        Spacer()
                        
                        Text("Describe the sound you are recording").multilineTextAlignment(.center).font(.system(size: 18)).foregroundColor(.white)
                        HStack{
                            Spacer()
                            ZStack{
                                if(clickinternal){
                                    Rectangle().foregroundColor(.white).cornerRadius(10).frame(width: 150, height: 50)
                                    Text("Internal").foregroundColor(.black).fontWeight(.bold)
                                }else{
                                    Text("Internal").foregroundColor(.white)
                                        .frame(width: 150, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 4)
                                        )
                                    
                                }
                                
                            }.onTapGesture {
                                clickinternal.toggle()
                                clickexternal=false
                            }
                            Spacer()
                            ZStack{
                                if(clickexternal){
                                    Rectangle().foregroundColor(.white).cornerRadius(10).frame(width: 150, height: 50)
                                    Text("External").foregroundColor(.black).fontWeight(.bold)
                                }else{
                                    Text("External").foregroundColor(.white)
                                        .frame(width: 150, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 4)
                                        )
                                    
                                }
                                
                            }.onTapGesture {
                                clickexternal.toggle()
                                clickinternal=false
                            }
                            Spacer()
                            
                        }
                        Spacer()
                        Text(arraycitazioni[indicearray]).fontWeight(.light).multilineTextAlignment(.center).font(.system(size: 18)).foregroundColor(.white)
                        Spacer()
                        
                        ZStack{
                            LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), startPoint: .leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing).mask(Rectangle().cornerRadius(10)).frame(width: 150, height: 50)
                            Text("Analyze").foregroundColor(.white).fontWeight(.bold)
                        }.onTapGesture {
                            audio.stopRecording()
                            changeView.toggle()
                            mic.audioRecorder.stop()
                            isPlaying.toggle()
                            media=mic.media+120.0
                            clickinternal=false
                            clickexternal=false
                        }
                        Spacer()
                        
                        
                    }
                    
                }else {
                    VStack{
                        Spacer()
                        
                        
                        
                        RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), center: .center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5, endRadius: 110).mask(Image(systemName: "record.circle.fill").resizable().frame(width: 150.0, height: 150.0).imageScale(.large)).frame(width: 150.0, height: 150.0).onTapGesture {
                            audio.startRecording()
                            isPlaying.toggle()
                            mic.startMonitoring()
                            indicearray=Int.random(in: 0..<arraycitazioni.count)
                        }
                        
                        Spacer()
//                        LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), startPoint: .leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing).mask(Text("Please, record an audio  of the environment ").font(.system(size: 20)).multilineTextAlignment(.center)).frame(width: 300, height: 50)
                        Text("Please, record an audio  of the environment ").foregroundColor(.white).font(.system(size: 20)).multilineTextAlignment(.center)
                        Spacer()
//                        LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), startPoint: .leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing).mask(Text("If you want a more accurate analyses  \n turn the phone upside down.").multilineTextAlignment(.center).font(.system(size: 18))).frame(width: 300, height: 100)
                        Text("If you want a more accurate analyses  \n turn the phone upside down.").foregroundColor(.white).multilineTextAlignment(.center).font(.system(size: 18))
                        
                        Spacer()
                    }
                }
                
                
                
                
            }.navigationTitle("Analyze")
        }
        
    }
}

struct NotClickedRecButton_Previews: PreviewProvider {
    static var previews: some View {
        NotClickedRecButton()
    }
}
struct BarView: View {
    
    var value: CGFloat
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
            
                .frame(width: (70 - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
            
        }
    }
}
