//
//  ResultView.swift
//  NoiseGate
//
//  Created by Gianluca Annina on 11/12/21.
//

import SwiftUI

struct ResultView: View {
     var audio:AudioRecorder = AudioRecorder()
    @State var image:String = "alarm.fill"
    @State var recognition:String = " fucking clock"
    @State var decibel:String = "123.44"
    @State  var phase = 0.0
    @Binding var media:Float
    @State var timer: Timer? = nil

    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()

        VStack{
            Spacer()
            RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), center: .center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5, endRadius: 130).mask(Image(systemName: image).resizable().frame(width: 150.0, height: 150.0).imageScale(.large)).frame(width: 150.0, height: 150.0)
            Spacer()
            Text("Oh dude, it seems that you are hearing a"+recognition+"!").foregroundColor(.white)
                .frame(width: 300, height: 50).multilineTextAlignment(.center)
            Text(decibel+" dB").foregroundColor(.white).fontWeight(.bold)
                .frame(width: 150, height: 50)
            Text("You are in a very loud place").foregroundColor(.white)
                .frame(width: 150, height: 50).multilineTextAlignment(.center)
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

                decibel="\(media)"
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.phase = .pi * 2
                }
            }
        }.navigationTitle("Result")
        }
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


