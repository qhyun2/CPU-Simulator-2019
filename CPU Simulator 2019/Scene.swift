//
//  Scene.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-09.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit

open class Scene {

    var id: Int
    var stage: SKScene
    var controller: SceneController
    var nodeArray: Array<SKNode>

    init(id: Int, stage: SKScene, controller: SceneController) {
        self.id = id
        self.stage = stage
        self.controller = controller
        nodeArray = []
    }

    //called when scene is active and updated
    open func update(_ currentTime: TimeInterval) { }
    open func addNode(node:SKNode) {
        nodeArray.append(node)
        stage.addChild(node)
    }

    //scene displayed
    open func show() {
        for i in nodeArray {
            i.isHidden = false
        }
    }
    open func hide() {
        for i in nodeArray {
            i.isHidden = true
        }
    }

    func getID() -> Int {
        return id
    }
}
