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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        Defaults.setDefaults()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

