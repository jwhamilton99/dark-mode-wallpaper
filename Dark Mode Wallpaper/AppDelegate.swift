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
    
    var darkExt = ""
    var lightExt = ""
    var currentExt = ""

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
        
        if(UserDefaults.standard.string(forKey: "darkExtension") != nil) {
            self.darkExt = UserDefaults.standard.string(forKey: "darkExtension")!
        } else {
            self.darkExt = "jpg"
            UserDefaults.standard.set(self.darkExt, forKey: "darkExtension")
        }
        
        if(UserDefaults.standard.string(forKey: "lightExtension") != nil) {
            self.lightExt = UserDefaults.standard.string(forKey: "lightExtension")!
        } else {
            self.lightExt = "jpg"
            UserDefaults.standard.set(self.lightExt, forKey: "lightExtension")
        }
        
        if(UserDefaults.standard.string(forKey: "currentExtension") != nil) {
            self.currentExt = UserDefaults.standard.string(forKey: "currentExtension")!
        } else {
            self.currentExt = "jpg"
            UserDefaults.standard.set(self.currentExt, forKey: "currentExtension")
        }
        
        picURL = supportURL[0].appendingPathComponent("DarkModeWallpaper/wallpaper-images", isDirectory: true) as NSURL
        rawDataURL = supportURL[0].appendingPathComponent("DarkModeWallpaper/rawdata", isDirectory: true) as NSURL
        
        checkSuffResources(showAlert: true)
        
        let menu = NSMenu()
        
        let replaceItem = NSMenuItem(title: "Pick Images...", action: nil, keyEquivalent: "")
        let imagesSubmenu = NSMenu()
        imagesSubmenu.addItem(withTitle: "Light", action: #selector(self.chooseLight), keyEquivalent: "")
        imagesSubmenu.addItem(withTitle: "Dark", action: #selector(self.chooseDark), keyEquivalent: "")
        replaceItem.submenu = imagesSubmenu
        
        menu.addItem(replaceItem)
        menu.addItem(withTitle: "Open At Login", action: #selector(self.openAtLogin), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Open Wallpaper Folder", action: #selector(self.openFolder), keyEquivalent: "")
        menu.addItem(withTitle: "About", action: #selector(self.showAbout), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(self.quit), keyEquivalent: "")
        statusItem.menu = menu
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.interfaceModeChanged), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.setImg), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
        
        interfaceModeChanged()
    }
    
    @objc func chooseLight() {
        let dialog = NSOpenPanel()
        dialog.prompt = "Set Light Wallpaper"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false
        dialog.allowedFileTypes = ["public.image"]
        dialog.directoryURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
        
        if(dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if(result != nil) {
                do {
                    let oldExt = self.lightExt
                    if(FileManager.default.fileExists(atPath: picURL.appendingPathComponent("light.\(oldExt)", isDirectory: false)!.relativePath)) {
                        try FileManager.default.removeItem(at: picURL.appendingPathComponent("light.\(oldExt)", isDirectory: false)!)
                    }
                    self.lightExt = result!.pathExtension
                    try FileManager.default.copyItem(at: result!, to: picURL.appendingPathComponent("light.\(self.lightExt)", isDirectory: false)!)
                    UserDefaults.standard.set(self.lightExt, forKey: "lightExtension")
                    self.interfaceModeChanged()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            return
        }
    }
    
    @objc func chooseDark() {
        let dialog = NSOpenPanel()
        dialog.prompt = "Set Dark Wallpaper"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false
        dialog.allowedFileTypes = ["public.image"]
        dialog.directoryURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
        
        if(dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if(result != nil) {
                do {
                    let oldExt = self.darkExt
                    if(FileManager.default.fileExists(atPath: picURL.appendingPathComponent("dark.\(oldExt)", isDirectory: false)!.relativePath)) {
                        try FileManager.default.removeItem(at: picURL.appendingPathComponent("dark.\(oldExt)", isDirectory: false)!)
                    }
                    self.darkExt = result!.pathExtension
                    try FileManager.default.copyItem(at: result!, to: picURL.appendingPathComponent("dark.\(self.darkExt)", isDirectory: false)!)
                    UserDefaults.standard.set(self.darkExt, forKey: "darkExtension")
                    self.interfaceModeChanged()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            return
        }
    }
    
    func checkSuffResources(showAlert: Bool) {
        suffResources = true
        if(!FileManager.default.fileExists(atPath: picURL.appendingPathComponent("dark.\(self.darkExt)")!.relativePath) && !FileManager.default.fileExists(atPath: picURL.appendingPathComponent("light.\(self.lightExt)")!.relativePath)) {
            suffResources = false
            if(showAlert) {
                let alert = NSAlert()
                alert.icon = NSImage(named: "AppIcon")
                alert.messageText = "Missing light wallpaper.\n\nPlease pick an image."
                alert.addButton(withTitle: "OK")
                alert.runModal()
                self.chooseLight()
                alert.messageText = "Missing dark wallpaper.\n\nPlease pick an image."
                alert.runModal()
                self.chooseDark()
            }
        } else if(!FileManager.default.fileExists(atPath: picURL.appendingPathComponent("dark.\(self.darkExt)")!.relativePath)) {
            suffResources = false
            if(showAlert) {
                let alert = NSAlert()
                alert.icon = NSImage(named: "AppIcon")
                alert.messageText = "Missing dark wallpaper.\n\nPlease pick an image."
                alert.addButton(withTitle: "OK")
                alert.runModal()
                self.chooseDark()
            }
        } else if(!FileManager.default.fileExists(atPath: picURL.appendingPathComponent("light.\(self.lightExt)")!.relativePath)) {
            suffResources = false
            if(showAlert) {
                let alert = NSAlert()
                alert.icon = NSImage(named: "AppIcon")
                alert.messageText = "Missing light wallpaper.\n\nPlease pick an image."
                alert.addButton(withTitle: "OK")
                alert.runModal()
                self.chooseLight()
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
            let oldExt = self.currentExt
            if(FileManager.default.fileExists(atPath: rawDataURL.appendingPathComponent("current\(oldRand).\(oldExt)", isDirectory: false)!.relativePath)) {
                try FileManager.default.removeItem(at: rawDataURL.appendingPathComponent("current\(oldRand).\(oldExt)", isDirectory: false)!)
            }
            
            if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameDarkAqua") {
                let imgurl = NSURL.fileURL(withPath: picURL.appendingPathComponent("dark.\(self.darkExt)")!.relativePath)
                try FileManager.default.copyItem(at: imgurl, to: rawDataURL.appendingPathComponent("current\(rand).\(self.darkExt)", isDirectory: false)!)
                
                self.currentExt = self.darkExt
                
                statusItem.button!.image = darkIcon
            } else if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameAqua") {
                let imgurl = NSURL.fileURL(withPath: picURL.appendingPathComponent("light.\(self.lightExt)")!.relativePath)
                try FileManager.default.copyItem(at: imgurl, to: rawDataURL.appendingPathComponent("current\(rand).\(self.lightExt)", isDirectory: false)!)
                
                self.currentExt = self.lightExt
                
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
            let imgurl = NSURL.fileURL(withPath: rawDataURL.appendingPathComponent("current\(rand).\(self.currentExt)")!.relativePath)
            UserDefaults.standard.set(self.currentExt, forKey: "currentExtension")
            
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

    @IBAction func goToWebsite(_ sender: Any) {
        NSWorkspace.shared.open(URL(string:"https://www.jwhamilton.co")!)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
