//
//  ExtensionDelegate.swift
//  UHL WatchKit Extension
//
//  Created by IJke Botman on 18/01/2018.
//  Copyright © 2018 IJke Botman. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                print("\n handling snapshot task \n")
                let nextMatchDate = season.upcomingMatches.first?.date
                let lastMatchExpiresTimeInterval = season.playedMatches.last?.date.timeIntervalSince(Date().yesterday)
                let wkExtension = WKExtension.shared()
                wkExtension.rootInterfaceController?.popToRootController()
                
                if let lastMatchExpiresTimeInterval = lastMatchExpiresTimeInterval, lastMatchExpiresTimeInterval > 0 {
                    let expiration = Date().addingTimeInterval(lastMatchExpiresTimeInterval)
                    wkExtension.rootInterfaceController?.pushController(withName: "RecordInterfaceControllerType", context: nil)
                    snapshotTask.setTaskCompleted(restoredDefaultState: false, estimatedSnapshotExpiration: expiration, userInfo: nil)
                    break
                }
                
                if let nextMatchDate = nextMatchDate, nextMatchDate.timeIntervalSinceNow < Date().tomorrow.timeIntervalSinceNow {
                    wkExtension.rootInterfaceController?.pushController(withName: "ScheduleInterfaceControllerType", context: nil)
                    wkExtension.rootInterfaceController?.pushController(withName: "ScheduleDetailInterfaceControllerType", context: 0)
                    snapshotTask.setTaskCompleted(restoredDefaultState: false, estimatedSnapshotExpiration: nextMatchDate, userInfo: nil)
                    break
                }
                
                if let nextMatchDate = nextMatchDate {
                    wkExtension.rootInterfaceController?.pushController(withName: "ScheduleInterfaceControllerType", context: nil)
                    let expiration = nextMatchDate.yesterday
                    snapshotTask.setTaskCompleted(restoredDefaultState: false, estimatedSnapshotExpiration: expiration, userInfo: nil)
                    break
                }
                
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
