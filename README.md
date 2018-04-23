# sample swift location background


[![License](http://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/ClintJang/sample-swift-location-background/blob/master/LICENSE) [![Swift 4](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](https://swift.org) 

- I'm still studying. incomplete sample~

I created a sample that can get gps information in the background with swift.

> How do you make GPS available in the background for a long time? Suggest a way.

...

>>later ...
Oh, my God.. ! Then I did not take the coordinates.
Later .... I have to ...
I've done it for over 10 minutes in the background ...
This is a sample.
Download and run it.

- How to test?
1. Run the project.
2. Click the Start button.
3. Create the app in the background.
4. Disable your mobile phone by pressing the power button.
5. Wait at least 10 minutes.
6. Continue logging well.
7. So it is success.


# Go to settings app
- ViewController.swift
```swift 
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
```
