//
//  Overview.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-11.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

class Overview: Scene {

    //locations and dimen of 3 buttons
    let x = [654, 66, 66]
    let y = [66, 458, 158]
    let w = [703, 315, 315]
    let h = [651, 268, 203]
    var buttons: Array<SKShapeNode>?
    var dataBus: HorizontalBus?
    var addressBus: HorizontalBus?
    var readLine: HorizontalBus?
    var writeLine: HorizontalBus?
    var reg1Line: Bus?
    var reg2Line: Bus?
    var reg3Line: Bus?
    var subLine: Bus?


    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)

        //remove back button and label
        nodeArray.remove(at: 1).isHidden = true
        nodeArray.remove(at: 1).isHidden = true


        //generate buttons
        buttons = []
        for i in 0...2 {
            let button = SKShapeNode(rect: CGRect(x: x[i], y: y[i], width: w[i], height: h[i]), cornerRadius: 20)
            button.lineWidth = 14
            button.strokeColor = SKColor.cyan
            button.fillColor = SKColor.clear
            button.zPosition = 12
            buttons?.append(button)
            addNode(node: button)
        }

        //busses
        dataBus = HorizontalBus(x: 516, y: 485, width: 264, height: 231, bits: 16, spacing: 1.0, scene: self)
        dataBus?.enableLabel(x: 517, y: 573, fontSize: 50, scene: self)

        addressBus = HorizontalBus(x: 520, y: 176, width: 270, height: 110, bits: 8, spacing: 1, scene: self)
        addressBus?.enableLabel(x: 517, y: 205, fontSize: 50, scene: self)

        readLine = HorizontalBus(x: 519, y: 295, width: 270, height: 10, bits: 1, spacing: 1, scene: self)
        readLine?.activeColour = NSColor.purple
        writeLine = HorizontalBus(x: 519, y: 315, width: 270, height: 10, bits: 1, spacing: 1, scene: self)
        writeLine?.activeColour = NSColor.green
        
        reg1Line = Bus(x: 110, y: 408, width: 20, height: 90, bits: 1, scene: self)
        reg1Line?.activeColour = SKColor.green
        reg2Line = Bus(x: 150, y: 408, width: 20, height: 90, bits: 1, scene: self)
        reg2Line?.activeColour = SKColor.green
        reg3Line = Bus(x: 190, y: 408, width: 20, height: 90, bits: 1, scene: self)
        reg3Line?.activeColour = SKColor.purple
        subLine = Bus(x: 230, y: 408, width: 20, height: 90, bits: 1, scene: self)
        subLine?.activeColour = SKColor.yellow

        //labels
        addNode(node: controller.makeLabel(x: 1007, y: 385, fontSize: 40, colour: SKColor.green, text: "Memory"))
        addNode(node: controller.makeLabel(x: 220, y: 580, fontSize: 40, colour: SKColor.green, text: "ALU"))
        addNode(node: controller.makeLabel(x: 217, y: 250, fontSize: 40, colour: SKColor.green, text: "Control Unit"))
    }

    override func event(id: Int, data: Array<Int> = []) {
        switch id {
        case 1:
            //value sent to data bus
            dataBus?.value = data[0]

            //send value back
            //shouldn't cause loop cause only actually read actions send here
            controller.memory?.event(id: 3, data: [(dataBus?.value)!])
            controller.alu?.event(id: 4, data: [(dataBus?.value)!])
        case 2:
            //value sent to address bus
            addressBus?.value = data[0]
        case 3:
            //read line update
            readLine?.value = data[0]
        case 4:
            //write line update
            writeLine?.value = data[0]
        case 5:
            //write line update
            reg1Line?.value = data[0]
        case 6:
            //write line update
            reg2Line?.value = data[0]
        case 7:
            //write line update
            reg3Line?.value = data[0]
        case 8:
            //write line update
            subLine?.value = data[0]
        default:
            print("Overview Event Error")
        }
    }

    override func mouseDown(point: CGPoint) {

        for (index, i) in buttons!.enumerated() {
            if i.contains(point) {
                controller.changeScene(id: index + 1)
            }
        }
    }
}

