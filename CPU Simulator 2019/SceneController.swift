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


    //initialize the game scene
    override func didMove(to view: SKView) {
        
 
        overview = Overview(id: OVERVIEWid, controller: self, bg: "bg1")
        memory = Memory(id: MEMORYid, controller: self, bg: "bg2")
        alu = ALU(id: ALUid, controller: self, bg: "bg3")
        controlunit = ControlUnit(id: CONTROLUNITid, controller: self, bg: "bg4")
        eventQ = EventQueue()
        
        overview?.hide()
        memory?.hide()
        alu?.hide()
        controlunit?.hide()

        sceneArray = [overview!, memory!, alu!, controlunit!]
        changeScene(id: 0)
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
        
        controlunit?.event(id: 1, data:[1, 1])
        controlunit?.event(id: 1, data:[2, 2])
//        let a = Event(delay: 6000, id: 1, scene: alu!)
//        let b = Event(delay: 500, id: 2, scene: alu!)
//        let c = Event(delay: 500, id: 1, scene: alu!)
//
//        eventQ?.addEvent(event: a)
//        eventQ?.addEvent(event: b)
//        eventQ?.addEvent(event: c)
//        eventQ?.addEvent(event: b)
//        eventQ?.addEvent(event: c)
//        eventQ?.addEvent(event: b)
//        eventQ?.addEvent(event: a)
    }
}


