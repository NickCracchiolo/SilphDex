//
//  VisionViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/5/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class VisionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var coreDataManager:CoreDataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { [weak self] (accepted) in
            guard let s = self else {
                return
            }
            if accepted {
                // User accepted permissions
            } else {
                // User declined permissions
            }
        }
        
    }
    
    func detectScene(image: CIImage) {
        
    }
}
