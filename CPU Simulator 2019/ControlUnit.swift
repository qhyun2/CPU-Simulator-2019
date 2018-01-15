//
//  ControlUnit.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-11.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

class ControlUnit: Scene {

    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)

    }

    //called when scene is active and updated
    override func update(_ currentTime: TimeInterval) {
    }

    /*
    Memory Op Codes
     1 - read line on
     2 - read line off
     3 - write line on
     4 - write line off
    */
    
    override func event(id: Int) {
        switch id {
            //loadFromMemory
        case 1:
            loadFromMemory(address: 1, reg: 1)
            break
        case 2:
            loadFromMemory(address: 1, reg: 2)
            break
        default:
            print("Control Unit Event Error")
        }
    }
    
    func loadFromMemory(address: Int, reg: Int) {

        let memory = controller.memory!
        let alu = controller.alu!
        
        
        let readMem = Event(delay: 1000, id: 1, scene: memory)
        let writeALU1 = Event(delay: 1000, id: 1, scene: alu)
        let writeALU1o = Event(delay: 1000, id: 2, scene: alu)
        let writeALU2 = Event(delay: 1000, id: 3, scene: alu)
        let writeALU2o = Event(delay: 1000, id: 4, scene: alu)
        let readMemo = Event(delay: 1000, id: 2, scene: memory)

        controller.eventQ?.addEvent(event: readMem)
        if  reg == 1 {
            controller.eventQ?.addEvent(event: writeALU1)
            controller.eventQ?.addEvent(event: writeALU1o)
        } else {
            controller.eventQ?.addEvent(event: writeALU2)
            controller.eventQ?.addEvent(event: writeALU2o)
        }
        controller.eventQ?.addEvent(event: readMemo)
    }
}


