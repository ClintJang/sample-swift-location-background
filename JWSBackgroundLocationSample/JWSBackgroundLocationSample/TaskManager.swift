//
//  TaskManager.swift
//  JWSBackgroundLocationSample
//
//  Created by Clint on 2018. 3. 21..
//  Copyright © 2018년 clint. All rights reserved.
//

import UIKit

final class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    var masterId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var subTaskList:[UIBackgroundTaskIdentifier] = []
    
    func new() {
        print("\(Date())>>>>> \(#function)")

        var bgTaskId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        bgTaskId = UIApplication.shared.beginBackgroundTask {
            if let index = self.subTaskList.index(of:bgTaskId) {
                self.subTaskList.remove(at: index)
            }
            UIApplication.shared.endBackgroundTask(bgTaskId)
            bgTaskId = UIBackgroundTaskInvalid
        }
        print("\(Date())>>>>> bgTaskId:\(bgTaskId)")
        
        if masterId == UIBackgroundTaskInvalid {
            self.masterId = bgTaskId;
        } else {
            self.subTaskList.append(bgTaskId)
            self.end()
        }
    }
    
    public func drain() {
        for (index, task) in self.subTaskList.enumerated() {
            UIApplication.shared.endBackgroundTask(task)
            self.subTaskList.remove(at: index)
        }
        
        if masterId != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(masterId)
            masterId = UIBackgroundTaskInvalid
        }
    }
    
    func end() {
        print("\(Date())>>>>> \(#function)")

        for (index, task) in self.subTaskList.enumerated() {
            if task != masterId, index != 0 {
                print("\(Date())>>>>> remove task:\(task)")
                UIApplication.shared.endBackgroundTask(task)
                self.subTaskList.remove(at: index)
            } else {
                print("\(Date())>>>>> subTaskList index 0:\(task)")
            }
        }
    }
    
}
