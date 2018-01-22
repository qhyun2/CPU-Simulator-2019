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

    //locations of 4 buttons
    let x = [654, 67, 66, 1120]
    let y = [66, 458, 158, 320]
    let w = [703, 313, 293]
    let h = [651, 268, 203]
    var buttons: Array<SKShapeNode>?
    var dataBus: HorizontalBus?
    var addressBus: HorizontalBus?


    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)

        //remove back button and label
        nodeArray.remove(at: 1).isHidden = true
        nodeArray.remove(at: 1).isHidden = true

        buttons = []

        //generate buttons
        for i in 0...2 {
            let button = SKShapeNode(rect: CGRect(x: x[i], y: y[i], width: w[i], height: h[i]), cornerRadius: 20)
            button.lineWidth = 14
            button.strokeColor = SKColor.cyan
            button.fillColor = SKColor.clear
            button.zPosition = 12
            buttons?.append(button)
            addNode(node: button)
        }
        dataBus = HorizontalBus(x: 516, y: 485, width: 264, height: 231, bits: 16, spacing: 1.0, scene: self)
        dataBus?.enableLabel(x: 517, y: 573, fontSize: 50, scene: self)
        
        addressBus = HorizontalBus(x: 510, y: 250, width: 290, height: 110, bits: 8, spacing: 1, scene: self)
        addressBus?.enableLabel(x: 517, y: 278, fontSize: 50, scene: self)

        let memLabel = SKLabelNode()
        memLabel.position = CGPoint(x: 1007, y: 385)
        memLabel.fontName = "AmericanTypewriter-Bold"
        memLabel.fontSize = 40
        memLabel.fontColor = SKColor.green
        memLabel.text = "Memory"
        memLabel.zPosition = 15
        addNode(node: memLabel)

        let aluLabel = SKLabelNode()
        aluLabel.position = CGPoint(x: 220, y: 564)
        aluLabel.fontName = "AmericanTypewriter-Bold"
        aluLabel.fontSize = 40
        aluLabel.fontColor = SKColor.green
        aluLabel.text = "ALU"
        aluLabel.zPosition = 15
        addNode(node: aluLabel)

        let conLabel = SKLabelNode()
        conLabel.position = CGPoint(x: 217, y: 261)
        conLabel.fontName = "AmericanTypewriter-Bold"
        conLabel.fontSize = 40
        conLabel.fontColor = SKColor.green
        conLabel.text = "Control Unit"
        conLabel.zPosition = 15
        addNode(node: conLabel)
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
        default:
            print("Error")
        }
    }

    override func mouseDown(event: NSEvent) {

        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        let point = CGPoint(x: x, y: y)
        print(x, y)

        for (index, i) in buttons!.enumerated() {
            if i.contains(point) {
                controller.changeScene(id: index + 1)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
    }
}

