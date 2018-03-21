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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setLocationButonEnabled(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onStart(_ sender: Any) {
        LocationManager.shared.start()
        
        setLocationButonEnabled(false)
    }
    
    @IBAction func onStop(_ sender: Any) {
        LocationManager.shared.stop()
        
        setLocationButonEnabled(true)
    }
}

extension ViewController {
    func setLocationButonEnabled(_ isFlag:Bool) {
        startButton.isEnabled = isFlag
        stopButton.isEnabled = !isFlag
    }
}

