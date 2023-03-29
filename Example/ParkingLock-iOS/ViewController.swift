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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        Logger().printLog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

