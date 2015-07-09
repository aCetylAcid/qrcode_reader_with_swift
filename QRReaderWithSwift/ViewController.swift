//
//  ViewController.swift
//  QRReaderWithSwift
//
//  Created by aCetylAcid on 2015/07/07.
//  Copyright (c) 2015年 zrn-ns.com. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // AVCaptureSession
    let session:AVCaptureSession = AVCaptureSession()
    
    /* AVCaptureMetadataOutputObjectsDelegate */
    func captureOutput(
                captureOutput: AVCaptureOutput!,
                didOutputMetadataObjects metadataObjects: [AnyObject]!,
                fromConnection connection: AVCaptureConnection!) {
        for m in metadataObjects {
            if m.type == AVMetadataObjectTypeQRCode {
                let qrcode = m.stringValue
                println("QRcode: " + qrcode)
            } else if m.type == AVMetadataObjectTypeEAN13Code {
                let barcode = m.stringValue
                println("Barcode: " + barcode)
            }
        }
    }

    /* lifecycle */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Camera devices
        let devices:[AVCaptureDevice] = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
                                                           as! [AVCaptureDevice]
        
        // Use back camera
        var targetDev:AVCaptureDevice?
        for d in devices {
            if d.position == AVCaptureDevicePosition.Back {
                targetDev = d
                break
            }
        }
        
        // Add Camera input to session.
        var err:NSError? = nil
        var input:AVCaptureInput? = nil
        if let validDevice = targetDev {
            input = AVCaptureDeviceInput.deviceInputWithDevice(validDevice, error: &err)
                                                                as? AVCaptureInput
        } else {
            // ValidDevices(Cameras) not found
            println("Error. there are no valid device(camera)s.")
            return
        }
        self.session.addInput(input)
        
        // Add camera output to session
        var output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        self.session.addOutput(output)
        
        // Get delegates for all metadata types.
        output.metadataObjectTypes = output.availableMetadataObjectTypes;
        
        
        // Start bar/qrcode detecting
        self.session.startRunning()
        
        // Show preview on the screen
        let previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session)
                            as! AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
    }
}

