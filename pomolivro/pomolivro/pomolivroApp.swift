//
//  pomolivroApp.swift
//  pomolivro
//
//  Created by Florian Beaumont on 04/04/2023.
//

import SwiftUI

@main
struct pomolivroApp: App {
    
    @StateObject var pomoModel: PomoModel = .init()
    
    // MARK: Scene Phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Storing Last Time Stamp
    @State var lastActiveTimeStamp: Date = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomoModel)
                .onChange(of: phase) { newValue in
                    if pomoModel.timerIsStarted {
                        if newValue == .background {
                            lastActiveTimeStamp = Date()
                        }
                        if newValue == .active {
                            // MARK: Finding The Time Difference
                            let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                            if pomoModel.totalDurationInSeconds - Int(currentTimeStampDiff) <= 0 {
                                pomoModel.timerIsStarted = false
                                pomoModel.totalDurationInSeconds = 0
                                pomoModel.timerIsFinished = true
                            } else {
                                pomoModel.totalDurationInSeconds -= Int(currentTimeStampDiff)
                            }
                        }
                    }
                }
        }
    }
}
