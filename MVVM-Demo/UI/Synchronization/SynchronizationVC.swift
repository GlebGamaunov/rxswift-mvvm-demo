//
//  SynchronizationVC.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 03/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//

import UIKit

class SynchronizationVC: CoordinatorVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.coordinator.pop(animated: true)
        }
    }

}
