//
//  ViewController.swift
//  ParkingLock-iOS
//
//  Created by rilwanulhuda on 03/29/2023.
//  Copyright (c) 2023 rilwanulhuda. All rights reserved.
//

import UIKit
import ParkingLock_iOS

class ViewController: UIViewController {
    private var handleLock = HandleLock.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupComponent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name("BLEDidEnterBackground"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleLock.deinitBluetoothManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Do something
    }
    
    private func setupComponent() {
        handleLock.delegate = self
        handleLock.checkParkingLockType(deviceId: "C0:3B:CB:44:D0:31", lockType: "V2", secretKey: "3B3D4B38")
    }

    @objc private func appDidEnterBackground() {
        handleLock.shouldDelayingScanning(true)
    }
    
    @IBAction func testButtonDidTapped(_ sender: UIButton) {
        //
    }
    
    @IBAction func upDownButtonDidTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            print("down")
            handleLock.handleBluetoothParkingLock(action: .turnLockDown(secretKey: "3B3D4B38"))
            return
        }
        
        print("up")
        handleLock.handleBluetoothParkingLock(action: .turnLockUp(secretKey: "3B3D4B38"))
    }
}

extension ViewController: HandleLockDelegate {
    func didUpdateBluetoothState(isOn: Bool) {
        if isOn {
            if handleLock.isLockConnected {
                didConnectParkingLock()
            }
        } else {
            TRACER("Bluetooth State isOn: \(isOn)")
        }
    }
    
    func bluetoothIsUnauthorized() {
        // bluetooth is unauthorized
    }
    
    func didConnectParkingLock() {
        TRACER("PARKING LOCK IS CONNECTED IN VIEW CONTROLLER")
    }
    
    func lockDidTurnDown() {
        TRACER("QUICKBOOK CHECK IN")
    }
    
    func lockDidTurnUp() {
        TRACER("QUICKBOOK CHECK OUT")
    }
}
