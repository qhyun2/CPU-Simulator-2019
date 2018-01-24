//
//  Scene.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-09.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit

class Scene {

    var id: Int
    var stage: SKScene
    var controller: SceneController
    var nodeArray: Array<SKNode>
    var background: SKSpriteNode
    var backButton = SKShapeNode(rect: CGRect(x: 1294, y: 690, width: 121, height: 75), cornerRadius: 20)

    init(id: Int, controller: SceneController, bg: String) {

        self.id = id
        self.controller = controller
        stage = controller
        
        //array for storing all objects in a given scene
        //needed in order to be able to hide/show on command
        nodeArray = []
        
        //setup background
        background = SKSpriteNode(imageNamed: bg)
        background.size = CGSize(width: stage.size.width, height: stage.size.height)
        background.zPosition = -99
        background.position = CGPoint(x: stage.size.width / 2, y: stage.size.height / 2)
        addNode(node: background)
        
        //setup back button
        backButton.fillColor = SKColor.cyan
        backButton.lineWidth = 4
        backButton.strokeColor = SKColor.black
        addNode(node: backButton)
        addNode(node: controller.makeLabel(x: 1354, y: 717, fontSize: 32, colour: SKColor.black, text: "Back"))
    }

    //called when scene is active to update scene
    func update(_ currentTime: TimeInterval) { }

    //called when it is time for scene to display or do something
    func event(id: Int, data:Array<Int> = []) { }

    //mouse input
    func mouseDown(event: NSEvent) {
        if backButton.contains(CGPoint(x: event.locationInWindow.x, y: event.locationInWindow.y)) {
            controller.changeScene(id: 0)
        }
    }

    //add spritekit node to scene, also added to reference array for future use
    func addNode(node: SKNode) {
        nodeArray.append(node)
        stage.addChild(node)
    }

    //display scene
    func show() {
        for i in nodeArray {
            i.isHidden = false
        }
    }

    //hide scene
    func hide() {
        for i in nodeArray {
            i.isHidden = true
        }
    }

}
