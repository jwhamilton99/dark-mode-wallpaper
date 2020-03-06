//
//  ViewController.swift
//  WindowLevelTest
//
//  Created by Justin Hamilton on 3/4/20.
//  Copyright © 2020 Justin Hamilton. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var inc: NSButton!
    @IBOutlet weak var dec: NSButton!
    
    var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSApplication.shared.windows[0].level = .normal
        value = NSApplication.shared.windows[0].level.rawValue
        label.stringValue = "\(value)"
        let levelArr = [NSWindow.Level.floating, NSWindow.Level.mainMenu, NSWindow.Level.modalPanel, NSWindow.Level.normal, NSWindow.Level.popUpMenu, NSWindow.Level.screenSaver, NSWindow.Level.statusBar, NSWindow.Level.submenu, NSWindow.Level.tornOffMenu]
        for l in levelArr {
            print("\(l.self): \(l.rawValue)")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @IBAction func increment(_ sender: Any) {
        value+=1
        label.stringValue = "\(value)"
        NSApplication.shared.windows[0].level = NSWindow.Level(rawValue:value)
    }
    
    @IBAction func decrement(_ sender: Any) {
        value-=1
        label.stringValue = "\(value)"
        NSApplication.shared.windows[0].level = NSWindow.Level(rawValue:value)
    }
}

