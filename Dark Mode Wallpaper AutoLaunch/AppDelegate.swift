//
//  AppDelegate.swift
//  Dark Mode Wallpaper AutoLaunch
//
//  Created by Justin Hamilton on 3/4/20.
//  Copyright © 2020 Justin Hamilton. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let isRunning = !(NSWorkspace.shared.runningApplications).filter { $0.bundleIdentifier == "justinhamilton.Dark-Mode-Wallpaper"}.isEmpty
        if(!isRunning) {
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast(); components.removeLast(); components.removeLast();
            components.append("MacOS")
            components.append("Dark Mode Wallpaper")
            
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
            
            NSApplication.shared.terminate(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

