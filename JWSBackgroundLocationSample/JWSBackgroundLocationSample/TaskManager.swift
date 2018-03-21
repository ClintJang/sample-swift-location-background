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

    var masterId:UIBackgroundTaskIdentifier?
    var list:[UIBackgroundTaskIdentifier] = []
    
    func beginNewTask() {
        print(#function)
        
        var bgTaskId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        bgTaskId = UIApplication.shared.beginBackgroundTask {
            if let index = self.list.index(of:bgTaskId) {
                self.list.remove(at: index)
            }
            UIApplication.shared.endBackgroundTask(bgTaskId)
            bgTaskId = UIBackgroundTaskInvalid
        }
        print(bgTaskId)
        if masterId == UIBackgroundTaskInvalid {
            self.masterId = bgTaskId;
        } else {
            self.list.append(bgTaskId)
            self.endTask()
        }
    }
    
    // For Testing
    func endTask() {
        print(#function)
        
        for (index, task) in self.list.enumerated() {
            print(task)
            if task != masterId {
                self.list.remove(at: index)
            }
        }
    }
    
}
