//
//  AppDelegate.swift
//  PokemonVGC_macOS
//
//  Created by Nick Cracchiolo on 8/29/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    //let coreDataManager = CoreDataManager(withModelName: "Pokedex")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        Defaults.setDefaults()
        print(NSPersistentContainer.defaultDirectoryURL().relativePath)
        if UserDefaults.standard.integer(forKey: Defaults.firstOpen) == 0 {
            CoreDataManager.preloadDBData()
            UserDefaults.standard.set(1, forKey: Defaults.firstOpen)
        }
//        if let window = NSApplication.shared.mainWindow {
//            window
//        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

