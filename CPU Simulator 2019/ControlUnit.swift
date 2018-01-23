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

var text:NSTextField = NSTextField()

class ControlUnit: Scene {

    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)
    }

    override func event(id: Int, data: Array<Int> = []) {
        switch id {
        case 1:
            loadFromMemory(address: data[0], reg: data[1])
            break
        case 2:
            saveToMemory(address: data[0])
            break
        case 3:
            //long supply chain for text input (part 4)
            print(controller.codeIn)
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
    
    func saveToMemory(address: Int) {
        
        let memory = controller.memory!
        let alu = controller.alu!
        
        let setAdd = Event(delay: 500, id: 4, scene: memory, data: [address])
        let readALU = Event(delay: 500, id: 3, scene: alu, data: [1])
        let writeMem = Event(delay: 500, id: 1, scene: memory, data:[1])
        let writeMemo = Event(delay: 500, id: 1, scene: memory, data:[0])
        let readALUo = Event(delay: 500, id: 3, scene: alu, data: [0])
        
        controller.eventQ?.addEvent(event: setAdd)
        controller.eventQ?.addEvent(event: readALU)
        controller.eventQ?.addEvent(event: writeMem)
        controller.eventQ?.addEvent(event: writeMemo)
        controller.eventQ?.addEvent(event: readALUo)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    override func show() {
        buttonEnabled = true
        super.show()
    }
    
    override func hide() {
        buttonEnabled = false
        super.hide()
    }
}


