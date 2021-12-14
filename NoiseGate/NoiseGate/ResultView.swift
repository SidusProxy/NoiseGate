//
//  ResultView.swift
//  NoiseGate
//
//  Created by Gianluca Annina on 11/12/21.
//

import SwiftUI
import SoundAnalysis
import CoreML
import AudioKit
struct ResultView: View {
    // Use a default model configuration.
    static let defaultConfig = MLModelConfiguration()

    // Create an instance of the sound classifier's wrapper class.
   static let soundClassifier = try? NoiseGate.init(configuration: defaultConfig)

    // Create a classify sound request that uses the custom sound classifier.
    let request = try? SNClassifySoundRequest(mlModel: soundClassifier!.model)
    let resultsObserver = ResultsObserver()

    
    
     var audio:AudioRecorder = AudioRecorder()
    @State var image:String = "alarm.fill"
    @State var recognition:String = "fucking clock"
    @State var decibel:String = "123.44"
    @State  var phase = 0.0
    @Binding var media:Float
    @State var timer: Timer? = nil
    @State var audioFileAnalyzer:SNAudioFileAnalyzer? = nil
    @State var pericolo="You are in a very loud place"
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()

        VStack{
            Spacer()
            RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), center: .center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5, endRadius: 110).mask(Image(systemName: image).resizable().frame(width: 150.0, height: 150.0).imageScale(.large)).frame(width: 150.0, height: 150.0)
            Spacer()
            Text("Oh dude, it seems that you are hearing a "+recognition+"!").foregroundColor(.white)
                .frame(width: 300, height: 50).multilineTextAlignment(.center)
            Text(decibel+" dB").foregroundColor(.white).fontWeight(.bold).font(.system(size: 25))
                .frame(width: 200, height: 50)
            Text(pericolo).foregroundColor(.white)
                .frame(width: 150, height: 50).multilineTextAlignment(.center).onAppear(perform: {
                  audioFileAnalyzer = createAnalyzer()
                    try? audioFileAnalyzer?.add(request!, withObserver: resultsObserver)
                    audioFileAnalyzer?.analyze()
                    recognition=resultsObserver.classification2
                    
                    if(recognition=="Clock tick" || recognition=="clock alarm"){
                        image="alarm.fill"
                    }else if(recognition=="Airplane" || recognition=="Helicopter"){
                        image="airplane.circle.fill"
                    }else if(recognition=="Baby cry"){
                        image="message.and.waveform.fill"
                    }else if(recognition=="Breathing"){
                        image="lungs.fill"
                    }else if(recognition=="Can opening"){
                        image="trash.circle.fill"
                    }else if(recognition=="Car horn"){
                        image="car.circle.fill"
                    }else if(recognition=="Cat" || recognition=="Cow" || recognition=="Crow" || recognition=="Dog bark" || recognition=="Rooster" || recognition=="Pig" || recognition=="Frog" || recognition=="Hen" || recognition=="Insect" || recognition=="Sheep" || recognition=="Crickets"){
                        image="pawprint.circle.fill"
                    }else if(recognition=="Chainsaw" || recognition=="Handsaw"){
                        image="leaf.circle.fill"
                    }else if(recognition=="Chirping birds"){
                        image="paperplane.circle.fill"
                    }else if(recognition=="Church bells" || recognition=="Siren"){
                        image="bell.circle.fill"
                    }else if(recognition=="Clapping"){
                        image="hands.clap.fill"
                    }else if(recognition=="Coughing" || recognition=="Person sneeze"){
                        image="facemask.fill"
                    }else if(recognition=="Door" || recognition=="Door knock"){
                        image="house.circle.fill"
                    }else if(recognition=="Drinking" || recognition=="Pouring Water" || recognition=="Water drops"){
                        image="drop.circle.fill"
                    }else if(recognition=="Engine"){
                        image="bolt.car.circle.fill"
                    }else if(recognition=="Fire crackling"){
                        image="flame.circle.fill"
                    }else if(recognition=="Fireworks"){
                        image="sparkles"
                    }else if(recognition=="Footsteps"){
                        image="figure.walk.circle.fill"
                    }else if(recognition=="Glass breaking"){
                        image="eyeglasses"
                    }else if(recognition=="Keyboard typing"){
                        image="keyboard.fill"
                    }else if(recognition=="Mouse click"){
                        image="magicmouse.fill"
                    }else if(recognition=="Rain"){
                        image="cloud.heavyrain.fill"
                    }else if(recognition=="Thunderstorm"){
                        image="cloud.bolt.rain.fill"
                    }else if(recognition=="Toilet flush"){
                        image="trash.circle.fill"
                    }else if(recognition=="Train"){
                        image="tram.fill"
                    }else if(recognition=="Vacuum cleaner"){
                        image="fanblades.fill"
                    }else if(recognition=="Washing machine"){
                        image="fanblades.fill"
                    }else if(recognition=="Wind"){
                        image="wind"
                    }else if(recognition=="acoustic guitar" || recognition=="electric guitar"){
                        image="guitars.fill"
                    }else if(recognition=="brushing teeth"){
                        image="paintbrush.fill"
                    }else if(recognition=="cello" || recognition=="clarinet" || recognition=="flute" || recognition=="organ" || recognition=="piano" || recognition=="saxophone" || recognition=="trumpet" || recognition=="violin"){
                        image="music.note.house.fill"
                    }else if(recognition=="singing voice"){
                        recognition="people talking"
                        image="music.mic.circle.fill"
                    }else if(recognition=="laugh"){
                        image="theatermasks.circle.fill"
                    }else if(recognition=="snoring"){
                        image="moon.zzz.fill"
                    }else{
                        image="sleep.circle"
                    }

                })
            Spacer()
            
            ZStack {
                ForEach(0..<10) { i in
                    Wave(strength: 50, frequency: 10, phase: self.phase)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), startPoint: .leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing), lineWidth: 5)
                        .offset(y: CGFloat(i) * 10)
                }
            }.frame(height: 200)
//                .animation(.easeIn(duration: 1).repeatForever(autoreverses: false))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
//                    self.phase = .pi * 2
//                }
                
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                if(media>80){
                    pericolo="You are in a very loud place"
                }else{
                    pericolo="You are in a silent place"

                }
                decibel="\(media)"
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.phase = .pi * 2
                }
            }
        }.navigationTitle("Result")
        }
    }
    
    func createAnalyzer() -> SNAudioFileAnalyzer? {
        audio.fetchRecordings()
        return try? SNAudioFileAnalyzer(url: audio.recordings[0].fileURL)
    }
}

struct Wave: Shape {
    // allow SwiftUI to animate the wave phase
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }

    // how high our waves should be
    var strength: Double

    // how frequent our waves should be
    var frequency: Double

    // how much to offset our waves horizontally
    var phase: Double

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // find how far we are from the horizontal center
            let distanceFromMidWidth = x - midWidth

            // bring that into the range of -1 to 1
            let normalDistance = oneOverMidWidth * distanceFromMidWidth

            let parabola = -(normalDistance * normalDistance) + 1

            // calculate the sine of that position, adding our phase offset
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = parabola * strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
}


