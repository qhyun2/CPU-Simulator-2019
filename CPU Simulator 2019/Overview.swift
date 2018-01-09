//
//  Overview.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//

import SpriteKit
import GameplayKit
import Cocoa

class Overview: SKScene {
    
    private var addressBus: Array<SKShapeNode> = Array()
    private var dataBus: Array<SKShapeNode> = Array()
    
    //initialize the game scene
    override func didMove(to view: SKView) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    //mouse clicked
    override func mouseDown(with event: NSEvent) {
        let tempScene = Memory(fileNamed: "Overview")
        self.scene?.view?.presentScene(tempScene!)
    }
    
}



