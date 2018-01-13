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
    }

    //called when scene is active to update scene
    func update(_ currentTime: TimeInterval) { }
    
    //mouse input
    func mouseDown(event: NSEvent) {
        controller.changeScene(id: 0)
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
