//
//  ViewController.swift
//  AirPods
//
//  Created by Hannes Waller on 2019-11-11.
//  Copyright © 2019 Hannes Waller. All rights reserved.
//

import Cocoa
import AppleScriptObjC
import IOBluetooth

class ViewController: NSViewController {
    
    @IBOutlet weak var airpodsLabel: NSTextField!
    @IBOutlet weak var descriptionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return
        }

         for item in devices {
            if let device = item as? IOBluetoothDevice,
                let name = device.name {
                if name.lowercased().contains("airpods") {
                    airpodsLabel.stringValue = device.name
                } 
            }
        }
    }
    
    @IBAction func confirmAirpods(_ sender: Any) {
        UserDefaults.standard.set(airpodsLabel.stringValue, forKey: "airpods")
        let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.closePopover()
    }
    
    @IBAction func nopeAirpods(_ sender: Any) {
        descriptionLabel.stringValue = "Is it one of these then?"
    }
}

extension ViewController {

    static func freshController() -> ViewController {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("vc")

    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
      fatalError("Why cant i find vc? - Check Main.storyboard")
    }
    
    return viewcontroller
  }
}
