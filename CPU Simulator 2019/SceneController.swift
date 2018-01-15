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
    var alu: Scene?
    var overview: Scene?
    var controlunit: Scene?
    var sceneArray: Array<Scene>?
    var eventQ: EventQueue?
    var currentScene = 1
    var OVERVIEWid = 0
    var MEMORYid = 1
    var ALUid = 2
    var CONTROLUNITid = 3
    var initialScene = 0


    //initialize the game scene
    override func didMove(to view: SKView) {
        
 
        overview = Overview(id: OVERVIEWid, controller: self, bg: "bg1")
        memory = Memory(id: MEMORYid, controller: self, bg: "bg2")
        alu = ALU(id: ALUid, controller: self, bg: "bg3")
        controlunit = ControlUnit(id: CONTROLUNITid, controller: self, bg: "bg4")
        eventQ = EventQueue()

        sceneArray = [overview!, memory!, alu!, controlunit!]
        changeScene(id: initialScene)
    }

    override func update(_ currentTime: TimeInterval) {
        
        sceneArray![currentScene].update(currentTime)
        eventQ?.update(delta: currentTime)
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
            sceneArray![currentScene].mouseDown(event: event)
        let a = Event(delay: 1000, id: 1, scene: overview!)
        let b = Event(delay: 5000, id: 2, scene: overview!)
        let c = Event(delay: 1000, id: 3, scene: overview!)
        
        eventQ?.addEvent(event: a)
        eventQ?.addEvent(event: b)
        eventQ?.addEvent(event: c)
    }

}


