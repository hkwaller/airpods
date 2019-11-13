//
//  AppDelegate.swift
//  AirPods
//
//  Created by Hannes Waller on 2019-11-11.
//  Copyright © 2019 Hannes Waller. All rights reserved.
//

import Cocoa
import IOBluetooth

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.action = Selector(("connect:"))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
                        
        guard let devices = IOBluetoothDevice.pairedDevices() else {
            print("No devices")
            return
        }
        
        let storedName = UserDefaults.standard.string(forKey: "airpods") ?? ""
             
        if storedName == "" {
            popover.contentViewController = ViewController.freshController()
            togglePopover()
        }

        for item in devices {
            if let device = item as? IOBluetoothDevice {
                if device.name == storedName && device.isConnected() {
                    statusItem.button?.image = NSImage(named:NSImage.Name("airpodsConnected"))
                } else {
                    statusItem.button?.image = NSImage(named:NSImage.Name("airpods"))
                }
            }
        }
    }

    @IBAction func connect(_ sender: Any?) {
        let event = NSApp.currentEvent!

        if event.type == NSEvent.EventType.rightMouseUp {
           togglePopover()
        } else {
             guard let devices = IOBluetoothDevice.pairedDevices() else {
                 print("No devices")
                 return
             }

             let storedName = UserDefaults.standard.string(forKey: "airpods") ?? ""
             
             if storedName == "" {
                 popover.contentViewController = ViewController.freshController()
             }
        
             for item in devices {
                 if let device = item as? IOBluetoothDevice {
                     if device.name == storedName {
                         if !device.isConnected() {
                            device.openConnection()
                            statusItem.button?.image = NSImage(named:NSImage.Name("airpodsConnected"))
                         } else {
                            device.closeConnection()
                            statusItem.button?.image = NSImage(named:NSImage.Name("airpods"))
                        }
                     }
                 }
             }
        }
    }
    
    @objc func togglePopover() {
      if popover.isShown {
        closePopover()
      } else {
        showPopover()
      }
    }

    func showPopover() {
      if let button = statusItem.button {
        popover.contentViewController = ViewController.freshController()
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    public func closePopover() {
      popover.performClose(self)
    }
}

