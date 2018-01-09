//
//  ALU.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//

import SpriteKit
import GameplayKit
import Cocoa

class ALU: SKScene {

    var memory: Scene?

    //initialize the game scene
    override func didMove(to view: SKView) {
        memory = Scene(id:1)
    }

    override func update(_ currentTime: TimeInterval) {
        print(memory?.getID())
    }

    //mouse clicked
    override func mouseDown(with event: NSEvent) {
    }

}


