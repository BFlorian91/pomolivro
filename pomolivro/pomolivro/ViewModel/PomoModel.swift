//
//  PomoModel.swift
//  pomolivro
//
//  Created by Florian Beaumont on 04/04/2023.
//

import SwiftUI

class PomoModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: Timer Properties
    @Published var timerIsStarted: Bool = false
    @Published var timerIsFinished: Bool = false
    @Published var addNewTimer: Bool = false
    @Published var timerStringValue: String = "00:00"
    
    @Published var progress: CGFloat = 1
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 25
    @Published var seconds: Int = 0
    
    @Published var totalDurationInSeconds: Int = 0
    @Published var staticTotalDurationInSeconds: Int = 0
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    // MARK: Requesting Notification Access
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
            
        }
        
        // MARK: To Show Badge Notification When User Is In App
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    // MARK: Starting Timer
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) { timerIsStarted = true }
        // MARK: Setting String Time Value
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        // MARK: Calculating Total Seconds For Timer Animation
        totalDurationInSeconds = (hour * 36000) + (minutes * 60) + seconds
        staticTotalDurationInSeconds = totalDurationInSeconds
        addNewTimer = false
        addNotification()
    }
    
    // MARK: Stopping Timer
    func stopTimer() {
        withAnimation {
            timerIsStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalDurationInSeconds = 0
        staticTotalDurationInSeconds = 0
        timerStringValue = "00:00"
    }
    
    // MARK: Update Timer
    func updateTimer() {
        totalDurationInSeconds -= 1
        
        // MARK: Progress animation calculating
        progress = CGFloat(totalDurationInSeconds) / CGFloat(staticTotalDurationInSeconds)
        progress = (progress < 0 ? 0 : progress)
        
        hour = totalDurationInSeconds / 3600
        minutes = (totalDurationInSeconds / 60) % 60
        seconds = (totalDurationInSeconds % 60)
        
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if hour == 0 && minutes == 0 && seconds == 0 {
            timerIsStarted = false
            timerIsFinished = true
            print("Finished")
        }
    }
    
    // MARK: Notification
    func addNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "PomoLivro"
        content.subtitle = "Congratulation You did it 🎊🎉🚀"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalDurationInSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}
