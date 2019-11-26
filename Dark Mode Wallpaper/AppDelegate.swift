//
//  AppDelegate.swift
//  Dark Mode Wallpaper
//
//  Created by Justin Hamilton on 11/12/19.
//  Copyright © 2019 Justin Hamilton. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let supportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    var picURL: NSURL!
    var rawDataURL: NSURL!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let lightIcon = NSImage(named: "lightIcon")
    let darkIcon = NSImage(named: "darkIcon")

    var suffResources = true
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.button!.image = lightIcon
        
        do {
            if(!FileManager.default.fileExists(atPath: supportURL[0].appendingPathComponent("DarkModeWallpaper/wallpaper-images", isDirectory: true).relativePath)) {
                try FileManager.default.createDirectory(at: supportURL[0].appendingPathComponent("DarkModeWallpaper/wallpaper-images", isDirectory: true), withIntermediateDirectories: true, attributes: nil)
            }
            if(!FileManager.default.fileExists(atPath: supportURL[0].appendingPathComponent("DarkModeWallpaper/rawdata", isDirectory: true).relativePath)) {
                try FileManager.default.createDirectory(at: supportURL[0].appendingPathComponent("DarkModeWallpaper/rawdata", isDirectory: true), withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        picURL = supportURL[0].appendingPathComponent("DarkModeWallpaper/wallpaper-images", isDirectory: true) as NSURL
        rawDataURL = supportURL[0].appendingPathComponent("DarkModeWallpaper/rawdata", isDirectory: true) as NSURL
        
        checkSuffResources(showAlert: true)
        
        let menu = NSMenu()
        menu.addItem(withTitle: "Open Wallpaper Folder", action: #selector(self.openFolder), keyEquivalent: "")
        menu.addItem(withTitle: "Open At Login", action: #selector(self.openAtLogin), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "About", action: #selector(self.showAbout), keyEquivalent: "")
        menu.addItem(withTitle: "How To Use", action: #selector(self.howToUse), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(self.quit), keyEquivalent: "")
        statusItem.menu = menu
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.interfaceModeChanged), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.setImg), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
        
        interfaceModeChanged()
    }
    
    func checkSuffResources(showAlert: Bool) {
        suffResources = true
        if(!FileManager.default.fileExists(atPath: picURL.appendingPathComponent("dark.jpg")!.relativePath) && !FileManager.default.fileExists(atPath: picURL.appendingPathComponent("light.jpg")!.relativePath)) {
            suffResources = false
            if(showAlert) {
                let alert = NSAlert()
                alert.icon = NSImage(named: "AppIcon")
                alert.messageText = "Missing light and dark wallpapers. Please move images into the folder.\n\n(Images titled \"light.jpg\" and \"dark.jpg\" are required. It has to be a JPEG, sorry.)"
                alert.addButton(withTitle: "OK")
                alert.runModal()
                self.openFolder()
            }
        } else if(!FileManager.default.fileExists(atPath: picURL.appendingPathComponent("dark.jpg")!.relativePath)) {
            suffResources = false
            if(showAlert) {
                let alert = NSAlert()
                alert.icon = NSImage(named: "AppIcon")
                alert.messageText = "Missing dark wallpaper. Please move an image into the folder.\n\n(A file titled \"dark.jpg\" is required. It has to be a JPEG, sorry.)"
                alert.addButton(withTitle: "OK")
                alert.runModal()
                self.openFolder()
            }
        } else if(!FileManager.default.fileExists(atPath: picURL.appendingPathComponent("light.jpg")!.relativePath)) {
            suffResources = false
            if(showAlert) {
                let alert = NSAlert()
                alert.icon = NSImage(named: "AppIcon")
                alert.messageText = "Missing light wallpaper. Please move an image into the folder.\n\n(A file titled \"light.jpg\" is required. It has to be a JPEG, sorry.)"
                alert.addButton(withTitle: "OK")
                alert.runModal()
                self.openFolder()
            }
        }
        
        do {
            if(FileManager.default.fileExists(atPath:picURL.relativePath!)) {
                if(!FileManager.default.fileExists(atPath: supportURL[0].appendingPathComponent("DarkModeWallpaper/wallpaper-images", isDirectory: true).relativePath)) {
                    try FileManager.default.createDirectory(at: supportURL[0].appendingPathComponent("DarkModeWallpaper/wallpaper-images", isDirectory: true), withIntermediateDirectories: true, attributes: nil)
                }
            }
        
            if(!FileManager.default.fileExists(atPath: rawDataURL.relativePath!)) {
                if(!FileManager.default.fileExists(atPath: supportURL[0].appendingPathComponent("DarkModeWallpaper/rawdata", isDirectory: true).relativePath)) {
                    try FileManager.default.createDirectory(at: supportURL[0].appendingPathComponent("DarkModeWallpaper/rawdata", isDirectory: true), withIntermediateDirectories: true, attributes: nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func openFolder() {
        NSWorkspace.shared.openFile(picURL.relativePath!)
    }
    
    @objc func openAtLogin() {
        let alert = NSAlert()
        alert.icon = NSImage(named: "AppIcon")
        alert.messageText = "To open at login, go to:\n\nSystem Preferences > Users & Groups > Your Name > Login Items\n\nPress + and add Dark Mode Wallpaper."
        alert.runModal()
    }
    
    @objc func howToUse() {
        let alert = NSAlert()
        alert.icon = NSImage(named: "AppIcon")
        alert.messageText = "Open the folder in the app's menu and put in 2 JPEG images:\n\ndark.jpg and light.jpg\n\nThe app will use these images as the dark and light wallpapers."
        alert.runModal()
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func showAbout() {
        window.makeKeyAndOrderFront(self)
    }
    
    @objc func moveImg() {
        let oldRand = UserDefaults.standard.integer(forKey: "randInt")
        let rand = Int.random(in: 1..<100000000)
        UserDefaults.standard.set(rand, forKey: "randInt")
        
        do {
            if(FileManager.default.fileExists(atPath: rawDataURL.appendingPathComponent("current\(oldRand).jpg", isDirectory: false)!.relativePath)) {
                try FileManager.default.removeItem(at: rawDataURL.appendingPathComponent("current\(oldRand).jpg", isDirectory: false)!)
            }
            
            if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameDarkAqua") {
                let imgurl = NSURL.fileURL(withPath: picURL.appendingPathComponent("dark.jpg")!.relativePath)
                try FileManager.default.copyItem(at: imgurl, to: rawDataURL.appendingPathComponent("current\(rand).jpg", isDirectory: false)!)
                
                statusItem.button!.image = darkIcon
            } else if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameAqua") {
                let imgurl = NSURL.fileURL(withPath: picURL.appendingPathComponent("light.jpg")!.relativePath)
                
                try FileManager.default.copyItem(at: imgurl, to: rawDataURL.appendingPathComponent("current\(rand).jpg", isDirectory: false)!)
                
                statusItem.button!.image = lightIcon
            }
            self.setImg()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func setImg() {
        let workspace = NSWorkspace.shared
        let screens = NSScreen.screens
        
        let rand = UserDefaults.standard.integer(forKey: "randInt")
        
        do {
            let imgurl = NSURL.fileURL(withPath: rawDataURL.appendingPathComponent("current\(rand).jpg")!.relativePath)
            
            try screens.forEach({(s) in
                if(workspace.desktopImageURL(for: s) != imgurl) {
                    try workspace.setDesktopImageURL(imgurl as URL, for: s, options: [.allowClipping: true])
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func interfaceModeChanged() {
        if(suffResources) {
            checkSuffResources(showAlert: true)
            if(suffResources) {
                let _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.moveImg), userInfo: nil, repeats: false)
            }
        } else {
            checkSuffResources(showAlert: false)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
