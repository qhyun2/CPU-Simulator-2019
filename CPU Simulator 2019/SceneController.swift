//
//  ALU.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//

import SpriteKit
import GameplayKit
import Cocoa

class SceneController: SKScene {

    var memory: Scene?
    var sceneArray: Array<Scene>?
    var currentScene = 0
    var OVERVIEW = 0
    var MEMORY = 0
    var ALU = 2
    var CONTROLUNIT = 3
    

    //initialize the game scene
    override func didMove(to view: SKView) {
        memory = Memory(id:MEMORY, stage: self, controller: self)
         sceneArray = [memory!]
    }

    override func update(_ currentTime: TimeInterval) {
        for i in sceneArray! {
            i.update(currentTime)
        }
    }
    
    //swap scenes
    func changeScene(id: Int) {
        //hide current scene
        sceneArray![currentScene].hide()
        //show new scene
        sceneArray![id].show()
        //update tracker
        currentScene = id
    }

    //mouse clicked
    override func mouseDown(with event: NSEvent) {
        memory?.hide()
    }

}


