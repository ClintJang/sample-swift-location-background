//
//  ViewController.swift
//  JWSBackgroundLocationSample
//
//  Created by Clint on 2018. 3. 21..
//  Copyright © 2018년 clint. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setLocationButonEnabled(true)
    }

    @IBAction func onStart(_ sender: Any) {
        LocationManager.shared.start()
        
        setLocationButonEnabled(false)
    }
    
    @IBAction func onStop(_ sender: Any) {
        LocationManager.shared.stop()
        
        setLocationButonEnabled(true)
    }
    
    /// Go to settings app
    @IBAction func onSettingApp(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return ()
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
            })
        }
    }
}

extension ViewController {
    func setLocationButonEnabled(_ isFlag:Bool) {
        startButton.isEnabled = isFlag
        stopButton.isEnabled = !isFlag
    }
}

extension ViewController {
    func addLogText(text:String) {
        
    }
}
