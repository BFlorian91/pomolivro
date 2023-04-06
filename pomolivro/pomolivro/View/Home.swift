//
//  PomolivroApp.swift
//  pomolivro
//
//  Created by Florian Beaumont on 04/04/2023.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var Pomodel: PomoModel
    
    var body: some View {
        VStack {
            Text("PomoLivro Timer")
                .font(.title2)
                .foregroundColor(.white)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        // MARK: Shadow
                        Circle()
                            .stroke(Color("secondary"), lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        Circle()
                            .trim(from: 0, to: Pomodel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 80)
                        
                        // MARK: Center
                        Circle()
                            .fill(Color("BG"))
                        
                        // MARK: Progress
                        Circle()
                            .trim(from: 0, to: Pomodel.progress)
                            .stroke(Color("secondary").opacity(0.7), lineWidth: 10)
                        
                        // MARK: Point of Timer
                        GeometryReader { proxy in
                            let size = proxy.size
                        Circle()
                            .fill(Color("secondary"))
                            .frame(width: 30, height: 30)
                            .overlay(content: {
                                Circle()
                                    .fill(.white)
                                    .padding(5)
                            })
                            .frame(width: size.width, height: size.height, alignment: .center)
                            .offset(x: size.height / 2)
                            .rotationEffect(.init(degrees: Pomodel.progress * 360))
                        }
                        Text(Pomodel.timerStringValue)
                            .font(.system(size: 45))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: Pomodel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: Pomodel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        if (Pomodel.timerIsStarted) {
                            Pomodel.stopTimer()
                            
                            // MARK: Cancelling all notification
                            UNUserNotificationCenter.current()
                                .removeAllPendingNotificationRequests()
                        } else {
                            Pomodel.addNewTimer = true
                        }
                    } label: {
                        Image(systemName: !Pomodel.timerIsStarted ? "timer" : "stop.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background{
                                Circle()
                                    .fill(Color("secondary"))
                            }
                            .shadow(color: Color("secondary"), radius: 8, x: 0, y: 0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background {
//            LinearGradient(gradient: Gradient(colors: [Color.clear, Color("BG")]), startPoint: .top, endPoint: .bottom)
//                .opacity(0.9)
            Color("BG")
            .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack {
                Color.black
                    .opacity(Pomodel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        Pomodel.hour = 0
                        Pomodel.minutes = 25
                        Pomodel.seconds = 0
                        Pomodel.addNewTimer = false
                    }
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: Pomodel.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: Pomodel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
            _ in
            if Pomodel.timerIsStarted {
                Pomodel.updateTimer()
            }
        }
        .alert("Congratulation You did it !! 🎉🎉🎉", isPresented: $Pomodel.timerIsFinished) {
            Button("Start New", role: .cancel) {
                Pomodel.stopTimer()
                Pomodel.addNewTimer = true
            }
            Button("Close", role: .destructive) {
                Pomodel.stopTimer()
            }
        }
    }
    
    // MARK: New Timer Bottom Sheet
    @ViewBuilder
    func NewTimerView () -> some View {
        VStack(spacing: 15) {
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Text("\(Pomodel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 12, hint: "hr") { value in
                            Pomodel.hour = value
                        }
                    }
                Text("\(Pomodel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "min") { value in
                            Pomodel.minutes = value
                        }
                    }
                
                Text("\(Pomodel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in
                            Pomodel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            Button {
                Pomodel.startTimer()
            } label: {
                Text("Start")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color("secondary"))
                    }
            }
            .disabled(Pomodel.seconds == 0 && Pomodel.minutes == 0 && Pomodel.hour == 0)
            .opacity(Pomodel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("BG"))
                .ignoresSafeArea()
        }
    }
    
    // MARK: Reusable COntext Menu Options for set the Timer
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomoModel())
    }
}
