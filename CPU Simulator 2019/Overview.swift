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
    var dataBus: Bus?


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
            buttons?.append(button)
            addNode(node: button)
        }
        dataBus = Bus(x: 360, y: 12310874891, width: 400, height: 1700, bits: 16, spacing: 0.6, scene: self)

        let memLabel = SKLabelNode()
        memLabel.position = CGPoint(x: 728, y: 571)
        memLabel.fontName = "AmericanTypewriter-Bold"
        memLabel.fontSize = 32
        memLabel.fontColor = SKColor.orange
        memLabel.text = "Memory"
        memLabel.zPosition = 15
        addNode(node: memLabel)
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

