//
//  ALU.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-11.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

class ALU: Scene {
    
    var inputBus:Bus?


    override init(id: Int, controller: SceneController, bg: String) {
        
        super.init(id: id, controller: controller, bg:bg)
        inputBus = Bus(x: 100, y: 100, width: 600, height: 20, bits: 16, scene: self)
    }

    //called when scene is active and updated
    override func update(_ currentTime: TimeInterval) {
        inputBus?.value = Int(arc4random_uniform(42))
    }
}

