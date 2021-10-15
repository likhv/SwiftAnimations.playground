import SwiftUI
import UIKit
import PlaygroundSupport
import AVFoundation
import Foundation






// M U S I C





class MusicPlayer {
    
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?

    func startBackgroundMusic(backgroundMusicFileName: String) {
        if let bundle = Bundle.main.path(forResource: backgroundMusicFileName, ofType: "wav") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }

}





// F U N C T I O N S


struct Star: Shape {
    // store how many corners the star has, and how smooth/pointed it is
    let corners: Int
    let smoothness: CGFloat

    func path(in rect: CGRect) -> Path {
        // ensure we have at least two corners, otherwise send back an empty path
        guard corners >= 2 else { return Path() }

        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = -CGFloat.pi / 2

        // calculate how much we need to move with each star corner
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)

        // figure out how much we need to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness

        // we're ready to start with our path now
        var path = Path()

        // move to our initial position
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))

        // track the lowest point we draw to, so we can center later
        var bottomEdge: CGFloat = 0

        // loop over all our points/inner points
        for corner in 0..<corners * 2  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: CGFloat

            // if we're a multiple of 2 we are drawing the outer edge of the star
            if corner.isMultiple(of: 2) {
                // store this Y position
                bottom = center.y * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // we're not a multiple of 2, which means we're drawing an inner point

                // store this Y position
                bottom = innerY * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }

            // if this new bottom point is our lowest, stash it away for later
            if bottom > bottomEdge {
                bottomEdge = bottom
            }

            // move on to the next corner
            currentAngle += angleAdjustment
        }

        // figure out how much unused space we have at the bottom of our drawing rectangle
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2

        // create and apply a transform that moves our path down by that amount, centering the shape vertically
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)
    }
}



struct RandomSign: View {

    @State var signScale: CGFloat = 0.1
    
    var mainDelay: Double = 12
    
    var imageNames = ["06cross", "06noetry", "06question", "06over18", "06nophone", "06sos", "06explosion", "06heart"]
    
    var imageWords = ["ForEach()", "struct WhatTheFuck: Viev","Class??",".onAppear()","CGFloat()"]
    
    var body: some View {
        
        var delayTime = Double(Int.random(in: 0...60))
        var size = CGFloat(Int.random(in: 20...160))
        var rotation = CGFloat(Int.random(in: -20...20))
        var stayingTime = Double(Int.random(in: 1...10))

        Image(uiImage: UIImage(named: imageNames[Int.random(in: 0..<imageNames.count)]) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .brightness(-0.2)

        
            .scaleEffect(signScale)
            .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(delayTime+mainDelay))
            .onAppear() {
                signScale = 1
            }
        
            .scaleEffect(signScale)
            .opacity(1-signScale)
            .animation(.easeIn(duration: 0.2).delay(delayTime+stayingTime+mainDelay))
            .onAppear() {
                signScale = 10
            }
            .position(x: CGFloat(Int.random(in: 0...390)), y: CGFloat(Int.random(in: 0...570)))
        
    }
}

struct RandomWords: View {

    @State var signScale: CGFloat = 0.1
    var mainDelay: Double = 12
    
    var imageWords = ["ForEach()", "struct WhatTheFuck","Class??",".onAppear()","CGFloat()","!=",".count","CGFloat()","CGFloat","Integer","MLKit","UIKit"]
    
    var body: some View {
        
        var delayTime = Double(Int.random(in: 0...60))
        var sizeFont = CGFloat(Int.random(in: 10...80))
        var rotation = CGFloat(Int.random(in: -20...20))
        var stayingTime = Double(Int.random(in: 1...4))

        Text(String(imageWords[Int.random(in: 0..<imageWords.count)]))
//        Text("test")
            .font(.system(size: sizeFont))
            .foregroundColor(.white)
            .rotationEffect(.degrees(rotation))
            .brightness(-0.2)
        
            .scaleEffect(signScale)
            .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(delayTime+mainDelay))
            .onAppear() {
                signScale = 1
            }
        
            .scaleEffect(signScale)
            .opacity(1-signScale)
            .animation(.easeIn(duration: 0.2).delay(delayTime+stayingTime+mainDelay))
            .onAppear() {
                signScale = 10
            }
            .position(x: CGFloat(Int.random(in: 0...390)), y: CGFloat(Int.random(in: 0...570)))
        
    }
}


struct AnimatedImage: View {
    
        
    @State var frame = 0
    
    var nameBeginning = "Alice_3_1_"
    var nameEndinning = ".png"
    var lenght = 12
    var duration = 0.02
    
    var body: some View {
        
        let timer = Timer.publish(every: duration, on: .main, in: .common).autoconnect()
        
        Image(uiImage: UIImage(named: "\(nameBeginning)\(frame)")!)
            .resizable()
            .scaledToFit()
            .onReceive(timer){
                
            _ in
            frame += 1
                if frame >= lenght{
                    frame = 0
            }
        }
    }
}

struct AnimatedImageUnlooped: View {
    
        
    @State var frame = 0
    
    var nameBeginning = "Alice_3_1_"
    var nameEndinning = ".png"
    var lenght = 12
    var duration = 0.02
    
    var body: some View {
        
        let timer = Timer.publish(every: duration, on: .main, in: .common).autoconnect()
        
        Image(uiImage: UIImage(named: "\(nameBeginning)\(frame)")!)
            .resizable()
            .scaledToFit()
            .onReceive(timer){
                
            _ in
            frame += 1
                if frame >= lenght{
                    frame = Int(lenght-1)
            }
        }
    }
}

struct Laptop: View {
    
        
    @State var howBright = 0.6
    let timer3 = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        
        Image(uiImage: UIImage(named: "07laptop_2.png")!)
                          .resizable()
                          .scaledToFit()
                          .frame(width: 280, height: 280)
                          .padding(.top, 110)
                          .brightness(-0.4)
                          .shadow(color: .blue.opacity(howBright),
                                  radius: 30,
                                  y: CGFloat(-35))
                          .onReceive(timer3){
                              _ in
                              howBright = Double(Int.random(in: 1..<10)) / 50 + 0.4
                              
                              
                          }
 
    
    }
}













// S T A R T I N G   S C R E E N

struct ScreenZero: View {
    
    @State var logoScale = CGFloat(0.8)
    
    var body: some View {
        
    
        
        ZStack {
            
            
            Image(uiImage: UIImage(named: "Logo.png")!)
                              .resizable()
                              .scaledToFit()
                              .scaleEffect(logoScale)
                              .padding(.top, -100)
//                              .blur(radius: CGFloat(3.3-logoScale*3))
                              .animation(
                                .linear(duration: 20)
                                    .repeatForever(autoreverses: true)
                                    .speed(1)
                              )
                              .onAppear() {
                                  logoScale = 1.1
                              }

            
            
            AnimatedImage(frame: 0, nameBeginning: "Alice_0_0_", nameEndinning: ".png", lenght: 94, duration: 0.02)
                .rotationEffect(.degrees(-12))
                .frame(width: 450, height: 450)
                .position(x: 350, y: 550)

            

        
            
        }.frame(width: 390, height: 800).background(Color.green)
    }
}











// F I R S T   S C R E E N

struct ScreenOne: View {
    
    var part = 0
    @State var bulbScale = 0.1
    @State var objectsScale = 0.0001
    @State var objectsScale2 = 0.0001
    @State var starRotation: Double = 0
    
    @State var faceRotation = 0.0
    @State var faceScale = 1.0
    
    @State var storyPart = 0
    
    let timerFirstScreen = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Text("Screen 1").foregroundColor(.white).opacity(0)
            .onReceive(timerFirstScreen){
                _ in
                storyPart += 1
                    if storyPart >= 3{
                        storyPart = 2
                }
            }
        
        switch storyPart {
        
        case 0:
            
            ZStack {
                
                Image(uiImage: UIImage(named: "01buble.png")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(x:4)
            
                
                Text("Hi, I'm Alice")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                
            }    .scaleEffect(objectsScale2)
                .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(1))
                .onAppear() {
                    objectsScale2 = 1
                }
                .offset(y: -180)

            AnimatedImage(frame: 0, nameBeginning: "Alice_4_3_", nameEndinning: ".png", lenght: 143, duration: 0.03)
                            .frame(width: 480, height: 480)
                            .shadow(radius: 20)
                            .offset(x:10, y:-20)
            
//            Image(uiImage: UIImage(named: "12alice")!)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 320.0, height: 320.0)
//                .padding(.top,145)
//                .offset(y: -70)
            

        
            
        case 1:
            
            ZStack {
            
                Image(uiImage: UIImage(named: "6c311561ac5f3c638554794aa1de029c-sticker")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 300.0, height: 300.0)
                    .offset(x: 260, y: -60)
                    .rotationEffect(.degrees(-40))
                

                

                
                Image(uiImage: UIImage(named: "02party")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 100.0, height: 100.0)
                    .offset(x: -40, y: 100)
                    .rotationEffect(.degrees(-10))
                

                
                Image(uiImage: UIImage(named: "02glasses")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                    .frame(width: 85.0, height: 85.0)
                    .offset(x: 110, y: -290)
                    .rotationEffect(.degrees(-25))
                
 
                
                Image(uiImage: UIImage(named: "02bottle")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 85.0, height: 85.0)
                    .offset(x: -80, y: -220)
                    .rotationEffect(.degrees(25))
               
                
                Image(uiImage: UIImage(named: "02party")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 95.0, height: 95.0)
                    .offset(x: -200, y: -250)
                    .rotationEffect(.degrees(10))
                

                
                Image(uiImage: UIImage(named: "3fff7c10807396df0f10c187a01fe12f-sticker")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 250.0, height: 250.0)
                    .offset(x: -150, y: 10)
                    .rotationEffect(.degrees(30))
                    .offset(y:-50)
      
            
                
                Image(uiImage: UIImage(named: "02bottle")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 130.0, height: 130.0)
                    .offset(x: -180, y: 10)
                    .rotationEffect(.degrees(-18))
                    .offset(x: -30, y:-60)
                
                
            }.offset(y: 70).scaleEffect(1.1)
            
            
            
            
            
            AnimatedImage(frame: 0, nameBeginning: "Alice_0_0_", nameEndinning: ".png", lenght: 94, duration: 0.03)
                .frame(width: 480, height: 480)
                .shadow(radius: 20)
                .offset(x:10, y:-20)
            
                .scaleEffect(faceScale)
//                .opacity(faceScale*faceScale*faceScale)
                .animation(.linear(duration: 0.1).delay(6.9))
                .onAppear() {faceScale = 0.9}
            
            
                .rotationEffect(.degrees(faceRotation))
                .animation(.linear(duration: 0.1).delay(6.9))
                .onAppear() {faceRotation = 7}
            
//            Image(uiImage: UIImage(named: "12alice")!)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 320.0, height: 320.0)
//                .padding(.top,145)
//                .offset(y: -70)
            
            
            
            
            
            
            Image(uiImage: UIImage(named: "bd5d35e9f8d000a3cacd415825f93055-sticker.png")!)
                .resizable()
                .scaledToFit()
            
                .scaleEffect(objectsScale)
                .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                .onAppear() {
                    objectsScale = 1
                }
            
                .frame(width: 250.0, height: 250.0)
                .offset(x: 50, y: 155)
                .rotationEffect(.degrees(-20))

 
            
        case 2:
            
            ZStack {
                
                Star(corners: 10, smoothness: 0.45)
                    .fill(Color.green.opacity(0.2))
                    .blur(radius: 20)
                    .frame(width: 1000, height: 1000)
                
                    .rotationEffect(.degrees(-starRotation))
                    .animation(.linear(duration: 30).repeatForever())
                    .onAppear()
                
                Star(corners: 10, smoothness: 0.45)
                    .fill(Color.yellow.opacity(0.2))
                    .blur(radius: 15)
                    .frame(width: 800, height: 800)
                
                    .rotationEffect(.degrees(starRotation))
                    .animation(.linear(duration: 15).repeatForever())
                    .onAppear()
                
                Star(corners: 10, smoothness: 0.45)
                    .fill(Color.white.opacity(0.8))
                    .blur(radius: 10)
                    .frame(width: 600, height: 600)
                
                    .rotationEffect(.degrees(starRotation))
                    .animation(.linear(duration: 30).repeatForever())
                    .onAppear() {
                        starRotation = 360
                    }
                
                
                Image(uiImage: UIImage(named: "03bulb.png")!)
                    .scaleEffect(0.8)
                    .rotationEffect(.degrees(7))
                    .position(x: 515, y: 290)
                    .shadow(radius: 5)
                    .shadow(color: .yellow.opacity(bulbScale), radius: 20,y: CGFloat(-15))
                
                    .scaleEffect(bulbScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(1))
                    .onAppear() {
                        bulbScale = 1
                    }
                
                Image(uiImage: UIImage(named: "03alice.png")!)
                    .position(x: 485, y: 500)
            
            
            }
            
        default:
            Text("Screen 1").foregroundColor(.white)
        }
        
        
    }
}








// S E C O N D   P L A Y G R O U N D


struct ScreenTwo: View {
    
    @State var swiftRotation: CGFloat = 0
    @State var swiftScale: CGFloat = 1
    @State var swiftOffset = 0
    @State var swiftClickScale: CGFloat = 1
    
    @State var holeScale: CGFloat = 1
    @State var holeOpacity: CGFloat = 0
    
    @State var handOffset: CGFloat = -400
    @State var handClick: CGFloat = 1
    @State var handClick2: CGFloat = 1
    
    @State var aliceRotation: CGFloat = 0
    @State var aliceRotation2: CGFloat = 0
    @State var aliceScale: CGFloat = 4
    @State var aliceOffset = 650
    
    @State var opOp: Double = 0
    
    var timeBeforeClick: Double = 3
        
    var body: some View {
        ZStack {
            
            
            


            
                        
            Image(uiImage: UIImage(named: "hole.png") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 800, height: 800)
            
                .rotationEffect(.degrees(swiftRotation/2))
                .animation(.easeIn(duration: 12).delay(timeBeforeClick))
                
                .opacity(holeOpacity)
                .animation(.linear(duration: 3).delay(timeBeforeClick))
                .onAppear() {
                    holeOpacity = 1
                }
            
                .scaleEffect(holeScale)
                .animation(.easeIn(duration: 10).delay(timeBeforeClick))
                .onAppear() {
                    holeScale = 5.32
                }
            
                
            
            ForEach((1...80), id: \.self) {
                _ in
                RandomSign().opacity(opOp)
                    .offset(x:200)
                    .animation(.linear(duration: 1).delay(12))
                    .onAppear(){ opOp = 1}

             }
            
            ForEach((1...60), id: \.self) {
                _ in
                RandomWords().opacity(opOp)
                    .offset(x:200)
                    .animation(.linear(duration: 1).delay(12))
                    .onAppear(){ opOp = 1}
            }
            
            
            
            
            
            Rectangle().fill(
                LinearGradient(gradient: Gradient(colors: [.black, .black.opacity(0)]), startPoint: .bottom, endPoint: .top)
            ).frame(width: 390, height: 400).offset(y:300)
            
            
            
            
            
//                .animation(.easeInOut(duration: 30).delay(timeBeforeClick))
            
            Image(uiImage: UIImage(named: "swift.png") ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
                .rotationEffect(.degrees(-swiftRotation))
                .animation(.easeInOut(duration: 8).delay(timeBeforeClick))
                .onAppear() {
                    swiftRotation = 722
                }
            
                .scaleEffect(swiftScale)
                .opacity(swiftScale)
                .animation(.easeInOut(duration: 8).delay(timeBeforeClick))
                .onAppear() {
                    swiftScale = 0.0001
                }
            
                .scaleEffect(swiftClickScale)
                .animation(.easeIn(duration: 0.2)
//                            .repeatForever(autoreverses: true)
//                            .speed(0.2)
                            .delay(timeBeforeClick-1.2))
                .onAppear() {
                    swiftClickScale = 1.2
                }
            
 
            
            Image(uiImage: UIImage(named: "index.png") ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
                .rotationEffect(.degrees(swiftRotation/1.5))
                .animation(.easeInOut(duration: 8).delay(timeBeforeClick))
                .scaleEffect(swiftScale)
                .opacity(swiftScale)
                .animation(.easeInOut(duration: 8).delay(timeBeforeClick))

                .position(x: 400, y: 550)
                .rotationEffect(.degrees(45))
                .shadow(radius: 10)
                        
            
                .offset(x: handOffset, y: -handOffset)
                .animation(.easeInOut(duration: 1).delay(timeBeforeClick-2))
                .onAppear() {
                    handOffset = 0
                }
            
                .scaleEffect(handClick)
                .animation(.linear(duration: 0.2).delay(timeBeforeClick-0.2))
                .onAppear() {
                    handClick = 0.9
                }
            
                .scaleEffect(handClick2)
                .animation(.linear(duration: 0.2).delay(timeBeforeClick))
                .onAppear() {
                    handClick2 = 1.1
                }
            

            
            Image(uiImage: UIImage(named: "alice.png") ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 340, height: 340)
                .shadow(radius: 20)
                .offset(y:-30)
                
                .blur(radius: aliceScale*4-4)
                .animation(.easeInOut(duration: 12).delay(timeBeforeClick+1))
        
                .scaleEffect(aliceScale)
                .animation(.easeInOut(duration: 12).delay(timeBeforeClick+1))
                .onAppear() {
                    aliceScale = 1
                }
            
                .rotationEffect(.degrees(aliceRotation2))
                .animation(.linear(duration: 62).delay(timeBeforeClick+1))
                .onAppear() {
                    aliceRotation2 = 1440*2
                }
        
                .rotationEffect(.degrees(aliceRotation))
                .animation(.easeInOut(duration: 12).delay(timeBeforeClick+1))
                .onAppear() {
                    aliceRotation = 720
                }
        
                .offset(x: CGFloat(-aliceOffset), y: CGFloat(-aliceOffset))
                .animation(.easeInOut(duration: 9).delay(timeBeforeClick+1))
                .onAppear() {
                    aliceOffset = 0
                }
            
        }
        .frame(width: 390, height: 800)
        .background(Color.black)
        
    }
}


















// T H I R D  P L A Y G R O U N D


struct ScreenThree: View {
    let names = ["Alice_3_1_", "Alice_3_2_", "Alice_3_3_"]
    let lenghts = [101, 97, 89]
    let firstOpacity = [1.0, 0.0, 0.0]
    let secondOpacity = [0.0, 1.0, 0.0]
    let thirdOpacity = [0.0, 0.0, 1.0]
    let paddings: [CGFloat] = [-130, -140, -100]
    
    @State var period = 0
    @State var howBright = 0.6
    @State var rotation = 360.0
    @State var scale = 0.01
    @State var xoff = 200
    @State var offCat = 0
    @State var offCat2 = 0
    @State var offSmoke = 0
    @State var offSmoke2 = 0
    @State var offSmoke3 = 0
    @State var offSig = 0
        
    var body: some View {
        
        let timer2 = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
        
        ZStack {
            
            if period == 2 {
            
                    Image(uiImage: UIImage(named: "09spider.png")!)
                                      .resizable()
                                      .scaledToFit()
                                      .frame(width: 100, height: 100)
                    
                                      
                                      .rotationEffect(.degrees(rotation))
                                      .animation(
                                        .easeInOut(duration: 3)
                                            .repeatForever(autoreverses: true)
                                            .speed(0.03)
                                      )
                                      .onAppear() {
                                          rotation = 40
                                      }
                    
                                      .position(x: 75, y: 300)
                                      .brightness(-0.4)
                
            }
            
            if period == 1 {
                Image(uiImage: UIImage(named: "08smoke.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 800, height: 800)
                                  .position(x: 400, y: 60)
                                  .brightness(0.2)
                                  .offset(x: CGFloat(offSmoke), y: 0)
                                  .animation(
                                    .easeInOut(duration: 21)
                                        .repeatForever(autoreverses: true)
                                        .speed(1)
                                  )
                                  .onAppear() {
                                      offSmoke -= 300
                                  }
                
                Image(uiImage: UIImage(named: "08cigarete.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 50, height: 50)
                                  .rotationEffect(.degrees(-15))
                                  .position(x: 110, y: 370)
                                  .brightness(-0.2)
                                  .offset(x: 0, y: CGFloat(offSig))
                                  .animation(
                                    .easeInOut(duration: 3)
                                        .repeatForever(autoreverses: true)
                                        .speed(1)
                                  )
                                  .onAppear() {
                                      offSig -= 10
                                  }
                

            }
            
            
            
//          Main plan
            
            AnimatedImage(frame: 0, nameBeginning: names[period], nameEndinning: ".png", lenght: lenghts[period], duration: 0.02)
                .frame(width: 490, height: 490)
                .padding(.leading, 20)
                .padding(.top, paddings[period])
                .onReceive(timer2) {
                    _ in
                    if period < 2{
                        
                        period += 1
                
                }
        }
            
            
            Laptop()
                
            
//          First plan

            
            if period == 2 {
                
                Image(uiImage: UIImage(named: "09bat.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 100, height: 100)
                                  .position(x: 450, y: 180)
                                  .brightness(-0.2)
                                  .rotationEffect(.degrees(-45))
                                  .offset(x: CGFloat(xoff), y: 0)
                                  .animation(
                                    .linear(duration: 12)
                                        .repeatForever(autoreverses: false)
                                        .speed(1)
                                  )
                                  .onAppear() {
                                      xoff = -350
                                  }

             

            
                Image(uiImage: UIImage(named: "09spider.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 350, height: 320)
    
                                  
                                  .rotationEffect(.degrees(rotation))
                                  .animation(
                                    .easeInOut(duration: 3)
                                        .repeatForever(autoreverses: true)
                                        .speed(0.03)
                                  )
                                  .onAppear() {
                                      rotation -= 40
                                  }
                
                
                                  .position(x: 370, y: 110)
                                  .blur(radius: 5)
                                  .brightness(-0.2)
                                  .opacity(thirdOpacity[period])
            }
            
            Image(uiImage: UIImage(named: "07tea.png")!)
                              .resizable()
                              .scaledToFit()
                              .frame(width: 120, height: 120)
                              .brightness(-0.2)
                              .position(x: 160, y: 490)
                              .opacity(firstOpacity[period])
            
            Image(uiImage: UIImage(named: "08cocktail.png")!)
                              .resizable()
                              .scaledToFit()
                              .frame(width: 100, height: 100)
                              .brightness(-0.3)
                              .position(x: 320, y: 470)
                              .opacity(secondOpacity[period])
            
            HStack {
                Image(uiImage: UIImage(named: "08wine.png")!)
                              .resizable()
                              .scaledToFit()
                              .frame(width: 150, height: 150)
                              .brightness(-0.4)
                              .blur(radius: 5)
                              .position(x: 140, y: 500)
                              .opacity(secondOpacity[period])
                
                Image(uiImage: UIImage(named: "08pill.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 30, height: 30)
                                  .brightness(-0.4)
    //                              .blur(radius: 5)
                                  .position(x: 0, y: 530)
                                  .opacity(secondOpacity[period])
                
            }
            

            
            if period == 1 {
                Image(uiImage: UIImage(named: "08smoke.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 1400, height: 1400)
                                  .position(x: 0, y: 260)
                                  .opacity(0.9)
                                  .brightness(0.2)
                                  .offset(x: CGFloat(offSmoke2), y: 0)
                                  .animation(
                                    .linear(duration: 9)
                                        .repeatForever(autoreverses: true)
                                        .speed(1)
                                  )
                                  .onAppear() {
                                      offSmoke2 += 300
                                  }
                
                Image(uiImage: UIImage(named: "08smoke.png")!)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 1400, height: 1400)
                                  .position(x: 600, y: 660)
                                  .opacity(0.9)
                                  .blur(radius: 20)
                                  .brightness(0.2)
                                  .offset(x: CGFloat(offSmoke3), y: 0)
                                  .animation(
                                    .linear(duration: 9)
                                        .repeatForever(autoreverses: true)
                                        .speed(1)
                                  )
                                  .onAppear() {
                                      offSmoke3 -= 300
                                  }
            }
            
                              
            

            if period == 0 {

                Image(uiImage: UIImage(named: "07cat3.png")!)

                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 850, height: 850)

                                  .brightness(-0.15)
                                  .blur(radius: 15)
                                  .position(x: 730, y: 790)
                                  .offset(x: CGFloat(offCat), y:0)
                                  .animation(
                                    .linear(duration: 6)
                                        .repeatForever(autoreverses: true)
                                        .speed(1)
                                  )
                                  .onAppear() {
                                      offCat -= 150

                                  }
            }

            
            
            
        }
        .frame(width: 390, height: 700)
        .background(Color.black)
//        .onTapGesture {
////                timer.connect().cancel()
////                timer2.connect().cancel()
//                period = 0
//
//        }
        
    }
}



//PlaygroundPage.current.setLiveView(ScreenThree())





// F O U R T H   S C R E E N

struct ScreenFour: View {
    
    
    @State var storyPart4 = 0
    @State var objectsScale = 0.001
    @State var objectsScale21 = 0.001
    @State var fourOpacity2: Double = 0
    @State var fourOpacity2_2: Double = 0
    @State var alarmRotation: Double = -20
    @State var alarmOpacity0: Double = 0
    @State var alarmOpacity1: Double = 1
    @State var audioPlayer: AVAudioPlayer?


    
    let timerFourthScreen = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Text("Screen 1").foregroundColor(.white).opacity(0)
            .onReceive(timerFourthScreen){
                _ in
                storyPart4 += 1
                    if storyPart4 >= 3{
                        storyPart4 = 2
                }
            }
        
        switch storyPart4 {
        
        case 0:
            AnimatedImage(frame: 0, nameBeginning: "Alice_4_1_", nameEndinning: ".png", lenght: 263, duration: 0.02)
                            .frame(width: 480, height: 480)
                            .shadow(radius: 20)
                            .offset(x:10, y:-100)
            
                            .opacity(fourOpacity2)
                            .animation(.linear(duration: 0.5).delay(1.5))
                            .onAppear(){fourOpacity2 = 1}
            
            Image(uiImage: UIImage(named: "10alarm.png")!)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
//                .offset(x:4)
            
                .rotationEffect(.degrees(alarmRotation))
                .animation(.linear(duration: 0.1).repeatForever())
                .onAppear(){alarmRotation = 20}
            
                .position(x: 400, y: 170)
            
                .opacity(alarmOpacity0)
                .animation(.linear(duration: 2))
                .onAppear(){alarmOpacity0 = 1}
            
                .opacity(alarmOpacity1)
                .animation(.linear(duration: 0.2).delay(4))
                .onAppear(){alarmOpacity1 = 0}
            
                .onAppear(){
                    self.playAudio()
                    
                }
        
        case 1:

            
            ZStack {
                
                Image(uiImage: UIImage(named: "01buble.png")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .offset(x:4)
            
                
                Text("Android? Seriosly? WTF?")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                
            }    .scaleEffect(objectsScale21)
                .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(1))
                .onAppear() {
                    objectsScale21 = 1
                }
                .offset(y: -260)
            
            AnimatedImage(frame: 0, nameBeginning: "Alice_4_3_", nameEndinning: ".png", lenght: 143, duration: 0.025)
                            .frame(width: 480, height: 480)
                            .shadow(radius: 20)
                            .offset(x:10, y:-100)

            
        case 2:
            ZStack {
            
                Image(uiImage: UIImage(named: "9851beda7c8f0eaa51e98a4b103d9664-sticker")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 300.0, height: 300.0)
                    .offset(x: 260, y: -60)
                    .rotationEffect(.degrees(-40))
                

                

                
                Image(uiImage: UIImage(named: "12apple")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 100.0, height: 100.0)
                    .offset(x: -40, y: 90)
                    .rotationEffect(.degrees(10))
                

                
                Image(uiImage: UIImage(named: "12money")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                    .frame(width: 85.0, height: 85.0)
                    .offset(x: 110, y: -290)
                    .rotationEffect(.degrees(-25))
                
 
                
                Image(uiImage: UIImage(named: "12money")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 85.0, height: 85.0)
                    .offset(x: -80, y: -220)
                    .rotationEffect(.degrees(25))
               
                
                Image(uiImage: UIImage(named: "12apple2")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 95.0, height: 95.0)
                    .offset(x: -200, y: -250)
                    .rotationEffect(.degrees(10))
                

                
                Image(uiImage: UIImage(named: "12flag")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 200.0, height: 200.0)
                    .offset(x: -100, y: -60)
                    .rotationEffect(.degrees(-20))
                    .offset(y:-50)
      
            
                
                Image(uiImage: UIImage(named: "12smartphone")!)
                    .resizable()
                    .scaledToFit()
                
                    .scaleEffect(objectsScale)
                    .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                    .onAppear() {
                        objectsScale = 1
                    }
                
                    .frame(width: 130.0, height: 130.0)
                    .offset(x: -180, y: 10)
                    .rotationEffect(.degrees(-18))
                    .offset(x: -30, y:-60)
                
                
            }.offset(y: 30).scaleEffect(1.1)
            
            
            AnimatedImage(frame: 0, nameBeginning: "Alice_0_0_", nameEndinning: ".png", lenght: 94, duration: 0.02)
                .frame(width: 480, height: 480)
                .shadow(radius: 20)
                .offset(x:10, y:-100)
            
            
//            Image(uiImage: UIImage(named: "12alice")!)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 320.0, height: 320.0)
//                .padding(.top,145)
//                .offset(y: -130)
            
            Image(uiImage: UIImage(named: "bd5d35e9f8d000a3cacd415825f93055-sticker.png")!)
                .resizable()
                .scaledToFit()
            
                .scaleEffect(objectsScale)
                .animation(.interpolatingSpring(stiffness: 250, damping: 7, initialVelocity: 10).delay(Double(Int.random(in: 0...4))))
                .onAppear() {
                    objectsScale = 1
                }
            
                .frame(width: 250.0, height: 250.0)
                .offset(x: 50, y: 125)
                .rotationEffect(.degrees(-20))

            
        default: Text("Default")
            
        }
    }
    
    func playAudio() {
                
                /// the URL of the audio file.
                /// forResource = name of the file.
                /// withExtension = extension, usually "mp3"
            if let audioURL = Bundle.main.url(forResource: "alarm", withExtension: "wav") {
                    do {
                            try self.audioPlayer = AVAudioPlayer(contentsOf: audioURL) /// make the audio player
                            self.audioPlayer?.numberOfLoops = 0 /// Number of times to loop the audio
                            self.audioPlayer?.play() /// start playing
                            
                    } catch {
                            print("Couldn't play audio. Error: \(error)")
                    }
                    
            } else {
                    print("No audio file found")
            }
    }
}

//struct ScreenFour: View {
//
//    @State var fourOpacity: Double = 0
//    @State var fourOpacity2: Double = 1
//
//    @State var fourOpacity_2: Double = 0
//    @State var fourOpacity2_2: Double = 1
//
//    @State var periodFour = 0
//
//    var body: some View {
//
//        ZStack {
//
//
//            AnimatedImageUnlooped(frame: 0, nameBeginning: "Alice_4_1_", nameEndinning: ".png", lenght: 263, duration: 0.02)
//                .frame(width: 480, height: 480)
//                .shadow(radius: 20)
//                .offset(x:10, y:-100)
//
//                .opacity(fourOpacity)
//                .animation(.linear(duration: 0.5).delay(2))
//                .onAppear(){fourOpacity = 1}
//
//                .opacity(fourOpacity2)
//                .animation(.easeOut(duration: 0.01).delay(7))
//                .onAppear(){ fourOpacity2 = 0 }
//
//            AnimatedImage(frame: 0, nameBeginning: "Alice_4_3_", nameEndinning: ".png", lenght: 140, duration: 0.02)
//                .frame(width: 480, height: 480)
//                .shadow(radius: 20)
//                .offset(x:10, y:-100)
//
//                .opacity(fourOpacity_2)
//                .animation(.linear(duration: 0.01).delay(7))
//                .onAppear(){fourOpacity_2 = 1}
//
//                .opacity(fourOpacity2_2)
//                .animation(.easeOut(duration: 0.1).delay(12))
//                .onAppear(){ fourOpacity2_2 = 0 }
//
//


//            AnimatedImage(frame: 0, nameBeginning: "Alice_4_3_", nameEndinning: ".png", lenght: 143, duration: 0.02)
//                .frame(width: 480, height: 480)
//                .shadow(radius: 20)
//                .offset(x:10, y:-100)
//
//                .opacity(textOpacity)
//                .animation(.easeIn(duration: 2).delay(8))
//                .onAppear(){ textOpacity = 1 }
//
//                .opacity(textOpacity2)
//                .animation(.easeOut(duration: 2).delay(13))
//                .onAppear(){ textOpacity2 = 0 }
                
    //                .opacity(fourOpacity)
    //                .animation(.linear(duration: 0.5).delay(2))
    //                .onAppear(){
    //                    fourOpacity = 1
    //                }
                    
    //                .onReceive(timer4) {
    //                    _ in
    //
    //                    if periodFour < 2{
    //
    //                        periodFour += 1
    //                    }
    //            }

//        }
//    }
//}
//












// A L L   S C R E E N S





struct ContentView: View {
    
    @State var screen = 0
    @State var buttomOpacity: CGFloat = 0
    @State var textOpacity: Double = 0
    @State var textOpacity2: Double = 1
    
    @State var audioPlayerFunny: AVAudioPlayer?
    @State var audioPlayerSad: AVAudioPlayer?

    @State var audioPlayerAlarm: AVAudioPlayer?
    @State var audioPlayerKeyboard: AVAudioPlayer?
    
    var howLongTillButton: [CGFloat] = [0,0,18,18,0,0]
    
    
    var body: some View {
        
        
        
        
        ZStack {
            
            switch screen {
                
            case 0: ScreenZero()
                
                
                Text("").opacity(0)
                    .onAppear(){
                        self.playAudioFunny()
                        self.pauseAudioSad()
                    }
                
                Button {
                    screen += 1
                    if screen > 4 {screen = 4}
                    textOpacity = 0
                    textOpacity2 = 1
                    buttomOpacity = 0

                } label: {
                    Text("Start!").frame(width: 70, height: 24)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(40)
//                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white, lineWidth: 1))
                    .opacity(buttomOpacity)
                    .animation(
                        .linear(duration: 1)
                        .delay(howLongTillButton[screen]))
                    .onAppear() {buttomOpacity = 1}
                }.position(x: 195, y: 740)
                

                
                
                
                
                
                
            case 1: ScreenOne().offset(x: 0, y: -50).frame(width: 390, height: 700)
                
                Text("Alice was just a regular girl from a regular town in a regular country")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(6))
                    .onAppear(){ textOpacity2 = 0 }
                
                
                Text("She was spending time with friends, having fun, and knowing nothing about code")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(7))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(12))
                    .onAppear(){ textOpacity2 = 0 }
            
                
                Text("Everything was great, but one day she got an idea… ")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(13))
                    .onAppear(){ textOpacity = 1 }
        
                Button {
                    screen += 1
                    if screen > 4 {screen = 4}
                    textOpacity = 0
                    textOpacity2 = 1
                    buttomOpacity = 0

                } label: {
                    Text("Next").frame(width: 70, height: 24)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white, lineWidth: 1))
                    .opacity(buttomOpacity)
                    .animation(
                        .linear(duration: 1)
                            .delay(15))
                    .onAppear() {buttomOpacity = 1}
                }.position(x: 195, y: 740)

                
                
                
                

            case 2: ScreenTwo().offset(x: 0, y: -70)
                
                
                
                Text("")
                .onAppear(){
                    self.pauseAudioFunny()
                    self.playAudioSad()
                }

                
                Text("She decided to become an Android Developer")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(6))
                    .onAppear(){ textOpacity2 = 0
                    }
                
                
                Text("She jumped into a deep, deep hole, full of structures, syntax, and algorithms")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(7))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(12))
                    .onAppear(){ textOpacity2 = 0 }
            
                
                Text("Everything was so weird there: Types and Operators, Conditionals and Loops, Functions and Structures")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(13))
                    .onAppear(){ textOpacity = 1 }
        
                Button {
                    screen += 1
                    if screen > 4 {screen = 4}
                    textOpacity = 0
                    textOpacity2 = 1
                    buttomOpacity = 0

                } label: {
                    Text("Next").frame(width: 70, height: 24)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white, lineWidth: 1))
                    .opacity(buttomOpacity)
                    .animation(
                        .linear(duration: 1)
                        .delay(14))
                    .onAppear() {buttomOpacity = 1}
                }.position(x: 195, y: 740)
                
                
                
                
                
                
                
            case 3: ScreenThree().offset(x: 0, y: -50)
                
                Text("").opacity(0)
                    .onAppear(){
                        self.playAudioKeyboard()
                    }
                    
                Text("She was spending all her time struggling with Android Studio")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(5))
                    .onAppear(){ textOpacity2 = 0 }
                
                
                Text("Time was flying so fast, she was getting older, losing her friends, taking pills, smoking")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(6))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(11))
                    .onAppear(){ textOpacity2 = 0 }
            
                
                Text("And one day she died right in her computer chair without ever figuring it out...")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(12))
                    .onAppear(){ textOpacity = 1 }
                                
                Button {
                    screen += 1
                    if screen > 4 {screen = 4}
                    textOpacity = 0
                    textOpacity2 = 1
                    buttomOpacity = 0

                } label: {

                    Text("Next").frame(width: 70, height: 24)
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(40)
                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white, lineWidth: 1))
                        .opacity(buttomOpacity)
                        .animation(
                            .linear(duration: 1)
                            .delay(13))
                        .onAppear() {buttomOpacity = 1}
                }.position(x: 195, y: 740)
                
                
                
                
                
                
            case 4: ScreenFour()
                    
                Text("")
                .onAppear(){
                    self.pauseAudioSad()
                    self.pauseAudioKeyboard()
                    self.playAudioFunny()
                    self.playAudioAlarm()
                }

                
                
                Text("We are joking. It was just a nightmare.")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(2))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(11))
                    .onAppear(){ textOpacity2 = 0 }
                
                
                Text("She woke up and yelled")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240+42)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(7))
                    .onAppear(){ textOpacity = 1 }
                
                    .opacity(textOpacity2)
                    .animation(.easeOut(duration: 2).delay(11))
                    .onAppear(){ textOpacity2 = 0 }
            
                
                Text("She is still a regular girl from a regular town enjoing being iOS Developer")
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .offset(y: 240)
                    .shadow(radius: 10)
            
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 2).delay(12))
                    .onAppear(){ textOpacity = 1 }
                
                Button {
                    screen += 1
                    if screen > 4 {screen = 0}
                    textOpacity = 0
                    textOpacity2 = 1
                    buttomOpacity = 0

                } label: {
                    Text("Repeat").frame(width: 75, height: 24)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color.green)
                    .cornerRadius(40)
//                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white, lineWidth: 1))
                    .opacity(buttomOpacity)
                    .animation(
                        .linear(duration: 1)
                        .delay(13))
                    .onAppear() {buttomOpacity = 1}
                }.position(x: 235, y: 740)
            
            default: ScreenZero()
                
                
            }
            

            
        }.frame(width: 390, height: 800).background(Color.black)
    }
    
    func playAudioFunny() {
        
                /// the URL of the audio file.
                /// forResource = name of the file.
                /// withExtension = extension, usually "mp3"
            if let audioURL = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
                    do {
                            try self.audioPlayerFunny = AVAudioPlayer(contentsOf: audioURL) /// make the audio player
                            self.audioPlayerFunny?.numberOfLoops = 0 /// Number of times to loop the audio
                            self.audioPlayerFunny?.play() /// start playing
                            
                    } catch {
                            print("Couldn't play audio. Error: \(error)")
                    }
                    
            } else {
                    print("No audio file found")
            }
    }
    
 
    
    
    func playAudioKeyboard() {
        
                /// the URL of the audio file.
                /// forResource = name of the file.
                /// withExtension = extension, usually "mp3"
            if let audioURL = Bundle.main.url(forResource: "Keyboard", withExtension: "mp3") {
                    do {
                            try self.audioPlayerKeyboard = AVAudioPlayer(contentsOf: audioURL) /// make the audio player
                            self.audioPlayerKeyboard?.numberOfLoops = 3 /// Number of times to loop the audio
                            self.audioPlayerKeyboard?.play() /// start playing
                            
                    } catch {
                            print("Couldn't play audio. Error: \(error)")
                    }
                    
            } else {
                    print("No audio file found")
            }
    }
    
    func playAudioSad() {
        
                /// the URL of the audio file.
                /// forResource = name of the file.
                /// withExtension = extension, usually "mp3"
            if let audioURL = Bundle.main.url(forResource: "Sad", withExtension: "mp3") {
                    do {
                            try self.audioPlayerSad = AVAudioPlayer(contentsOf: audioURL) /// make the audio player
                            self.audioPlayerSad?.numberOfLoops = 0 /// Number of times to loop the audio
                            self.audioPlayerSad?.play() /// start playing
                            
                    } catch {
                            print("Couldn't play audio. Error: \(error)")
                    }
                    
            } else {
                    print("No audio file found")
            }
    }
    
    func playAudioAlarm() {
        
                /// the URL of the audio file.
                /// forResource = name of the file.
                /// withExtension = extension, usually "mp3"
            if let audioURL = Bundle.main.url(forResource: "alarm", withExtension: "wav") {
                    do {
                            try self.audioPlayerAlarm = AVAudioPlayer(contentsOf: audioURL) /// make the audio player
                            self.audioPlayerAlarm?.numberOfLoops = 0 /// Number of times to loop the audio
                            self.audioPlayerAlarm?.play() /// start playing
                            
                    } catch {
                            print("Couldn't play audio. Error: \(error)")
                    }
                    
            } else {
                    print("No audio file found")
            }
    }

    func pauseAudioFunny() {
        
        self.audioPlayerFunny?.pause()
    }

    func pauseAudioSad() {
        
        self.audioPlayerSad?.pause()
    }
    
    func pauseAudioAlarm() {
        
        self.audioPlayerAlarm?.pause()
    }
    
    func pauseAudioKeyboard() {
        
        self.audioPlayerKeyboard?.pause()
    }

}








PlaygroundPage.current.setLiveView(ContentView())
