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

    let x = [160, 1120, 160, 1120]
    let y = [640, 640, 320, 320]
    let width = 100
    let height = 80
    var buttons: Array<SKShapeNode>?
    var dataBus: Bus?


    override init(id: Int, controller: SceneController, bg: String) {
        super.init(id: id, controller: controller, bg: bg)
        
        //remove back button and label
        nodeArray.remove(at: 1).isHidden = true
        nodeArray.remove(at: 1).isHidden = true
        
        buttons = []

        for i in 0...3 {
            let button = SKShapeNode(rect: CGRect(x: x[i], y: y[i], width: width, height: height))
            button.fillColor = SKColor.green
            buttons?.append(button)
            addNode(node: button)
        }
        dataBus = Bus(x: 360, y: 0, width: 400, height: 1700, bits: 16, spacing: 0.6, scene: self)
    }

    //called when scene is active and updated
    override func update(_ currentTime: TimeInterval) {
    }

    override func event(id: Int, data: Array<Int> = []) {
        switch id {
        case 1:
            print("1")
        default:
            print("Error")
        }
    }

    override func mouseDown(event: NSEvent) {
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        let point = CGPoint(x: x, y: y)

        for (index, i) in buttons!.enumerated() {
            if i.contains(point) {
                controller.changeScene(id: index + 1)
            }
        }
    }
}

