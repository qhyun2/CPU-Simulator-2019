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

    override func event(id: Int, data: Array<Int> = []) {
        switch id {
        case 1:
            loadFromMemory(address: data[0], reg: data[1])
            break
        default:
            print("Control Unit Event Error")
        }
    }

    func loadFromMemory(address: Int, reg: Int) {

        let memory = controller.memory!
        let alu = controller.alu!
        
        let setAdd = Event(delay: 500, id: 4, scene: memory, data: [address])
        let readMem = Event(delay: 500, id: 2, scene: memory, data: [1])
        let writeALU = Event(delay: 500, id: reg, scene: alu, data:[1])
        let writeALUo = Event(delay: 500, id: reg, scene: alu, data:[0])
        let readMemo = Event(delay: 500, id: 2, scene: memory, data: [0])
        
        controller.eventQ?.addEvent(event: setAdd)
        controller.eventQ?.addEvent(event: readMem)
        controller.eventQ?.addEvent(event: writeALU)
        controller.eventQ?.addEvent(event: writeALUo)
        controller.eventQ?.addEvent(event: readMemo)
    }
}


