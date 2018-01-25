//
//  Button.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-24.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit

class Button {

    var hitbox: SKShapeNode
    var onClick: Event
    var scene: Scene
    var label: SKLabelNode

    init(rect: CGRect, text: String, scene: Scene, event: Event) {

        //rect on screen
        hitbox = SKShapeNode(rect: rect)
        hitbox.fillColor = SKColor.cyan
        hitbox.strokeColor = SKColor.black
        hitbox.lineWidth = 3
        scene.addNode(node: hitbox)

        //label
        label = scene.controller.makeLabel(x: Int(rect.midX), y: Int(rect.midY - rect.height * 0.2), fontSize: 16, colour: SKColor.black, text: text)
        scene.addNode(node: label)

        onClick = event
        self.scene = scene
    }

    func update(point: CGPoint) {
        if hitbox.contains(point) {
            onClick.scene.event(id: onClick.id, data: onClick.data)
        }
    }
}
