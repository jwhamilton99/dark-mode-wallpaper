//
//  AppDelegate.swift
//  Dark Mode Wallpaper
//
//  Created by Justin Hamilton on 11/12/19.
//  Copyright © 2019 Justin Hamilton. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let supportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    var picURL: NSURL!
    var rawDataURL: NSURL!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var oldImage: NSImage!
    var newImage: NSImage!
    
    var darkExt = ""
    var lightExt = ""
    var currentExt = ""

    var suffResources = true
    
    func createMenu()->NSMenu {
        let menu = NSMenu()
        
        let replaceItem = NSMenuItem(title: "Pick Images...", action: nil, keyEquivalent: "")
        let imagesSubmenu = NSMenu()
        imagesSubmenu.addItem(withTitle: "Light", action: #selector(self.chooseLight), keyEquivalent: "")
        imagesSubmenu.addItem(withTitle: "Dark", action: #selector(self.chooseDark), keyEquivalent: "")
        replaceItem.submenu = imagesSubmenu
        
        menu.addItem(replaceItem)
        menu.addItem(NSMenuItem.separator())
        let fadeItem = NSMenuItem(title: "Fade Wallpaper", action: #selector(self.toggleFade), keyEquivalent: "")
        if(UserDefaults.standard.bool(forKey: "fadeWallpaper")) {
            fadeItem.state = .on
        }
        let fadeDelaySubmenuItem = NSMenuItem(title: "Fade Delay...", action: nil, keyEquivalent: "")
        if(!UserDefaults.standard.bool(forKey: "fadeWallpaper")) {
            fadeDelaySubmenuItem.isEnabled = false
        }
        
        let fadeDelaySubmenu = NSMenu()
        let lightMenuItem = NSMenuItem(title: "Light...", action: nil, keyEquivalent: "")
        
        let lightFadeDelayMenu = NSMenu()
        let lightItem1 = NSMenuItem(title: "0.5s", action: #selector(self.setLightFadeDelay(_:)), keyEquivalent: "")
        let lightItem2 = NSMenuItem(title: "0.75s", action: #selector(self.setLightFadeDelay(_:)), keyEquivalent: "")
        let lightItem3 = NSMenuItem(title: "1s", action: #selector(self.setLightFadeDelay(_:)), keyEquivalent: "")
        let lightItem4 = NSMenuItem(title: "1.25s", action: #selector(self.setLightFadeDelay(_:)), keyEquivalent: "")
        let lightItem5 = NSMenuItem(title: "1.5s", action: #selector(self.setLightFadeDelay(_:)), keyEquivalent: "")
        let lightItem6 = NSMenuItem(title: "Custom...", action: #selector(self.setLightFadeDelay(_:)), keyEquivalent: "")
        switch(UserDefaults.standard.double(forKey: "lightFadeDelay")) {
        case 0.5:
            lightItem1.state = .on
            break
        case 0.75:
            lightItem2.state = .on
            break
        case 1.0:
            lightItem3.state = .on
            break
        case 1.25:
            lightItem4.state = .on
            break
        case 1.5:
            lightItem5.state = .on
            break
        default:
            lightItem6.state = .on
            lightItem6.title = "Custom (\(UserDefaults.standard.double(forKey: "lightFadeDelay"))s)..."
            break
        }
        
        lightFadeDelayMenu.addItem(lightItem1)
        lightFadeDelayMenu.addItem(lightItem2)
        lightFadeDelayMenu.addItem(lightItem3)
        lightFadeDelayMenu.addItem(lightItem4)
        lightFadeDelayMenu.addItem(lightItem5)
        lightFadeDelayMenu.addItem(lightItem6)
        lightMenuItem.submenu = lightFadeDelayMenu
        
        let darkMenuItem = NSMenuItem(title: "Dark...", action: nil, keyEquivalent: "")
        let darkFadeDelayMenu = NSMenu()
        let darkItem1 = NSMenuItem(title: "0.5s", action: #selector(self.setDarkFadeDelay(_:)), keyEquivalent: "")
        let darkItem2 = NSMenuItem(title: "0.75s", action: #selector(self.setDarkFadeDelay(_:)), keyEquivalent: "")
        let darkItem3 = NSMenuItem(title: "1s", action: #selector(self.setDarkFadeDelay(_:)), keyEquivalent: "")
        let darkItem4 = NSMenuItem(title: "1.25s", action: #selector(self.setDarkFadeDelay(_:)), keyEquivalent: "")
        let darkItem5 = NSMenuItem(title: "1.5s", action: #selector(self.setDarkFadeDelay(_:)), keyEquivalent: "")
        let darkItem6 = NSMenuItem(title: "Custom...", action: #selector(self.setDarkFadeDelay(_:)), keyEquivalent: "")
        switch(UserDefaults.standard.double(forKey: "darkFadeDelay")) {
        case 0.5:
            darkItem1.state = .on
            break
        case 0.75:
            darkItem2.state = .on
            break
        case 1.0:
            darkItem3.state = .on
            break
        case 1.25:
            darkItem4.state = .on
            break
        case 1.5:
            darkItem5.state = .on
            break
        default:
            darkItem6.state = .on
            darkItem6.title = "Custom (\(UserDefaults.standard.double(forKey: "darkFadeDelay"))s)..."
            break
        }
        darkFadeDelayMenu.addItem(darkItem1)
        darkFadeDelayMenu.addItem(darkItem2)
        darkFadeDelayMenu.addItem(darkItem3)
        darkFadeDelayMenu.addItem(darkItem4)
        darkFadeDelayMenu.addItem(darkItem5)
        darkFadeDelayMenu.addItem(darkItem6)
        
        darkMenuItem.submenu = darkFadeDelayMenu
        
        fadeDelaySubmenu.addItem(withTitle: "Why?", action: #selector(self.fadeDelayExplanation), keyEquivalent: "")
        fadeDelaySubmenu.addItem(NSMenuItem.separator())
        fadeDelaySubmenu.addItem(lightMenuItem)
        fadeDelaySubmenu.addItem(darkMenuItem)
        
        fadeDelaySubmenuItem.submenu = fadeDelaySubmenu
        
        let openAtLoginItem = NSMenuItem(title: "Open At Login", action: #selector(self.openAtLogin), keyEquivalent: "")
        if(UserDefaults.standard.bool(forKey: "openAtLogin")) {
            openAtLoginItem.state = .on
        }
        menu.addItem(fadeItem); menu.addItem(fadeDelaySubmenuItem); menu.addItem(openAtLoginItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Open Wallpaper Folder", action: #selector(self.openFolder), keyEquivalent: "")
        menu.addItem(withTitle: "About", action: #selector(self.showAbout), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(self.quit), keyEquivalent: "")
        return menu
    }
    
    @objc func setLightFadeDelay(_ sender: Any) {
        switch((sender as! NSMenuItem).title) {
        case "0.5s":
            UserDefaults.standard.set(Double(0.5), forKey: "lightFadeDelay")
            break
        case "0.75s":
            UserDefaults.standard.set(Double(0.75), forKey: "lightFadeDelay")
            break
        case "1s":
            UserDefaults.standard.set(Double(1.0), forKey: "lightFadeDelay")
            break
        case "1.25s":
            UserDefaults.standard.set(Double(1.25), forKey: "lightFadeDelay")
            break
        case "1.5s":
            UserDefaults.standard.set(Double(1.5), forKey: "lightFadeDelay")
            break
        default:
            var isDouble = false
            while(!isDouble) {
                let alert = NSAlert()
                alert.messageText = "Enter a Custom Fade Delay (In Seconds)"
                let inputTextView = NSTextField(frame: NSRect(x: 0,y: 0,width: 250,height: 20))
                alert.accessoryView = inputTextView
                alert.addButton(withTitle: "OK")
                alert.addButton(withTitle: "Cancel")
                if(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn) {
                    if(Double(inputTextView.stringValue) != nil) {
                        if(Double(Int(inputTextView.stringValue) ?? 0) < 0) {
                            let nopeAlert = NSAlert()
                            nopeAlert.messageText = "Not Positive"
                            nopeAlert.informativeText = "Please enter a number above 0."
                            nopeAlert.runModal()
                        } else {
                            UserDefaults.standard.set(Double(inputTextView.stringValue), forKey: "lightFadeDelay")
                            isDouble = true
                        }
                    } else {
                        let nopeAlert = NSAlert()
                        nopeAlert.messageText = "Not a Number"
                        nopeAlert.informativeText = "Please enter a number."
                        nopeAlert.runModal()
                    }
                } else {
                    break
                }
            }
            break
        }
        self.statusItem.menu = createMenu()
    }
    
    @objc func setDarkFadeDelay(_ sender: Any) {
        switch((sender as! NSMenuItem).title) {
        case "0.5s":
            UserDefaults.standard.set(Double(0.5), forKey: "darkFadeDelay")
            break
        case "0.75s":
            UserDefaults.standard.set(Double(0.75), forKey: "darkFadeDelay")
            break
        case "1s":
            UserDefaults.standard.set(Double(1.0), forKey: "darkFadeDelay")
            break
        case "1.25s":
            UserDefaults.standard.set(Double(1.25), forKey: "darkFadeDelay")
            break
        case "1.5s":
            UserDefaults.standard.set(Double(1.5), forKey: "darkFadeDelay")
            break
        default:
            var isDouble = false
            while(!isDouble) {
                let alert = NSAlert()
                alert.messageText = "Enter a Custom Fade Delay (In Seconds)"
                let inputTextView = NSTextField(frame: NSRect(x: 0,y: 0,width: 250,height: 20))
                alert.accessoryView = inputTextView
                alert.addButton(withTitle: "OK")
                alert.addButton(withTitle: "Cancel")
                if(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn) {
                    if(Double(inputTextView.stringValue) != nil) {
                        if(Double(Int(inputTextView.stringValue) ?? 0) < 0) {
                            let nopeAlert = NSAlert()
                            nopeAlert.messageText = "Not Positive"
                            nopeAlert.informativeText = "Please enter a number above 0."
                            nopeAlert.runModal()
                        } else {
                            UserDefaults.standard.set(Double(inputTextView.stringValue), forKey: "darkFadeDelay")
                            isDouble = true
                        }
                    } else {
                        let nopeAlert = NSAlert()
                        nopeAlert.messageText = "Not a Number"
                        nopeAlert.informativeText = "Please enter a number."
                        nopeAlert.runModal()
                    }
                } else {
                    break
                }
            }
            break
        }
        self.statusItem.menu = createMenu()
    }
    
    @objc func fadeDelayExplanation() {
        let alert = NSAlert()
        alert.icon = NSImage(named: "AppIcon")
        alert.messageText = "Why mess with the fade delay?"
        alert.informativeText = "When setting the wallpaper, there's a delay between when the image URL is set, and when the image actually appears on the desktop. I have no way of determining this delay due to macOS limitations.\n\nThere are about a million different factors that contribute to the delay, including the size of the image and the apps in the foreground (Xcode and Firefox take especially long to switch appearances).\n\nYou can adjust the delay for each image if there are any visual glitches or if it's a bit too long for your liking. Play around a bit and see which option is best for your images.\n\nThe light delay adjusts the delay when switching from dark to light mode, and the dark delay adjusts the delay when switching from light to dark mode."
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc func toggleFade() {
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "fadeWallpaper"), forKey: "fadeWallpaper")
        self.statusItem.menu = createMenu()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.button!.image = NSImage(named: "lightIcon")
        
        if(UserDefaults.standard.object(forKey: "lightFadeDelay") == nil) {
            UserDefaults.standard.set(Double(1.0), forKey: "lightFadeDelay")
        }
        
        if(UserDefaults.standard.object(forKey: "darkFadeDelay") == nil) {
            UserDefaults.standard.set(Double(1.0), forKey: "darkFadeDelay")
        }
        
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
        
        
        statusItem.menu = createMenu()
        
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
        if(UserDefaults.standard.bool(forKey: "openAtLogin")) {
            if(!SMLoginItemSetEnabled("justinhamilton.Dark-Mode-Wallpaper-AutoLaunch" as CFString, false)) {
                print("Could not set login item")
            } else {
                UserDefaults.standard.set(false, forKey: "openAtLogin")
            }
        } else {
            if(!SMLoginItemSetEnabled("justinhamilton.Dark-Mode-Wallpaper-AutoLaunch" as CFString, true)) {
                print("Could not set login item")
            } else {
                UserDefaults.standard.set(true, forKey: "openAtLogin")
            }
        }
        self.statusItem.menu = createMenu()
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func showAbout() {
        window.level = .floating
        window.makeKeyAndOrderFront(self)
    }
    
    @objc func moveImg() {
        let oldRand = UserDefaults.standard.integer(forKey: "randInt")
        let rand = Int.random(in: 1..<100000000)
        UserDefaults.standard.set(rand, forKey: "randInt")
        
        do {
            let oldExt = self.currentExt
            if(FileManager.default.fileExists(atPath: rawDataURL.appendingPathComponent("current\(oldRand).\(oldExt)", isDirectory: false)!.relativePath)) {
                self.oldImage = NSImage(data:FileManager.default.contents(atPath: rawDataURL.appendingPathComponent("current\(oldRand).\(oldExt)")!.path)!)
                try FileManager.default.removeItem(at: rawDataURL.appendingPathComponent("current\(oldRand).\(oldExt)", isDirectory: false)!)
            }
            
            if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameDarkAqua") {
                let imgurl = NSURL.fileURL(withPath: picURL.appendingPathComponent("dark.\(self.darkExt)")!.relativePath)
                try FileManager.default.copyItem(at: imgurl, to: rawDataURL.appendingPathComponent("current\(rand).\(self.darkExt)", isDirectory: false)!)
                
                self.currentExt = self.darkExt
                
                statusItem.button!.image = NSImage(named: "darkIcon")
            } else if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameAqua") {
                let imgurl = NSURL.fileURL(withPath: picURL.appendingPathComponent("light.\(self.lightExt)")!.relativePath)
                try FileManager.default.copyItem(at: imgurl, to: rawDataURL.appendingPathComponent("current\(rand).\(self.lightExt)", isDirectory: false)!)
                
                self.currentExt = self.lightExt
                
                statusItem.button!.image = NSImage(named: "lightIcon")
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
        
        let imgurl = NSURL.fileURL(withPath: rawDataURL.appendingPathComponent("current\(rand).\(self.currentExt)")!.relativePath)
        UserDefaults.standard.set(self.currentExt, forKey: "currentExtension")
        
        screens.forEach({(s) in
            if(workspace.desktopImageURL(for: s) != imgurl) {
                if(UserDefaults.standard.bool(forKey: "fadeWallpaper")) {
                    //fade overlay code adapted from Ryan Thomson's Nightfall (https://github.com/r-thomson/Nightfall)
                    let fadeDuration = 0.25
                    let overlay = NSWindow(contentRect: s.frame, styleMask: .borderless, backing: .buffered, defer: false)
                    overlay.backgroundColor = .clear
                    overlay.collectionBehavior = [.ignoresCycle, .stationary]
                    overlay.ignoresMouseEvents = true
                    //This draws the window under the desktop icons, so it doesn't cover them when fading
                    overlay.level = NSWindow.Level(rawValue: NSWindow.Level.RawValue(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)))
                    overlay.contentView?.wantsLayer = true
                    //Since we're only fading the Desktop wallpaper, we don't need to take a screenshot! We just take the original picture and crop it to the same aspect ratio as the wallpaper.
                    overlay.contentView?.layer!.contentsGravity = CALayerContentsGravity.resizeAspectFill
                    overlay.contentView?.layer!.contents = self.oldImage
                    overlay.orderBack(overlay)
                    
                    //I'm not sure why delaying the actual setting makes this work better, but it does
                    DispatchQueue.main.asyncAfter(deadline: .now()+Double(0.1)) {[workspace] in
                        do {
                            try workspace.setDesktopImageURL(imgurl as URL, for: s, options: [.allowClipping: true])
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    var delay = 1.0
                    
                    if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameDarkAqua") {
                        delay = UserDefaults.standard.double(forKey: "darkFadeDelay")
                    } else if(NSApp.effectiveAppearance.name.rawValue == "NSAppearanceNameAqua") {
                        delay = UserDefaults.standard.double(forKey: "lightFadeDelay")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+delay) {[] in
                        NSAnimationContext.runAnimationGroup({context in
                            context.duration = Double(fadeDuration)
                            overlay.animator().alphaValue = 0.0
                        }, completionHandler: {
                            overlay.orderOut(overlay)
                            self.oldImage = nil
                            self.newImage = nil
                            
                        })
                    }
                } else {
                    do {
                        try workspace.setDesktopImageURL(imgurl as URL, for: s, options: [.allowClipping: true])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        })
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
