//
//  ALU.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-11.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

var zeroFlag = false

class ALU: Scene {

    var inputBus: Bus?
    var write1: Bus?
    var write2: Bus?
    var read: Bus?
    var subtract: Bus?
    var reg1: Bus?
    var reg2: Bus?
    var regOut: Bus?
    var label: SKLabelNode?
    var resultLabel: SKLabelNode?
    var testShape: SKShapeNode?

    var write1V = 0
    {
        didSet {
            //only write on turning on
            write1?.value = write1V
            if write1V == 1 {
                reg1!.value = inputBus!.value
                updateLabel()
            }
        }
    }
    var write2V = 0
    {
        didSet {
            write2?.value = write2V
            if write2V == 1 {
                reg2!.value = inputBus!.value
                updateLabel()
            }
        }
    }
    var readV = 0
    {
        didSet {
            read?.value = readV
            if readV == 1 {
                
                //update input bus
                inputBus!.value = regOut!.value
                
                //set main controller bus to be this value
                controller.overview?.event(id: 1, data: [(regOut?.value)!])
            }
        }
    }
    var subtractV = 0


    override init(id: Int, controller: SceneController, bg: String) {

        super.init(id: id, controller: controller, bg: bg)
        
        //background box
        let bgBox = SKShapeNode.init(rectOf: CGSize.init(width: 800, height: 250))
        bgBox.position = CGPoint(x: 450, y: 680)
        bgBox.fillColor = SKColor.init(white: 0, alpha: 0.65)
        bgBox.lineWidth = 4
        bgBox.strokeColor = SKColor.blue
        addNode(node: bgBox)
        
        //input bus
        inputBus = Bus(x: 160, y: 770, width: 700, height: 100, bits: 16, spacing: 1, scene: self)
        inputBus?.enableLabel(x: 80, y: 750, fontSize: 32, scene: self)
        
        //control lines
        write1 = Bus(x: 900, y: 770, width: 60, height: 200, bits: 1, spacing: 0.4, scene: self)
        write1?.activeColour = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1)
        write2 = Bus(x: 970, y: 770, width: 60, height: 380, bits: 1, spacing: 0.4, scene: self)
        write2?.activeColour = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1)
        read = Bus(x: 1040, y: 770, width: 60, height: 1400, bits: 1, spacing: 0.4, scene: self)
        read?.activeColour = SKColor.green
        subtract = Bus(x: 1110, y: 770, width: 60, height: 100, bits: 1, spacing: 0.4, scene: self)
        
        //registers
        reg1 = Bus(x: 160, y: 680, width: 700, height: 40, bits: 16, spacing: 0.4, scene: self)
        reg1?.enableLabel(x: 80, y: 670, fontSize: 32, scene: self)
        reg2 = Bus(x: 160, y: 600, width: 700, height: 40, bits: 16, spacing: 0.4, scene: self)
        reg2?.enableLabel(x: 80, y: 590, fontSize: 32, scene: self)
        regOut = Bus(x: 160, y: 100, width: 700, height: 40, bits: 16, spacing: 0.4, scene: self)
        regOut?.enableLabel(x: 80, y: 90, fontSize: 32, scene: self)
        let box = SKShapeNode(rect: CGRect(x: 360, y: 160, width: 320, height: 320))
        box.fillColor = SKColor.black

        label = SKLabelNode(text: "")
        label?.position = CGPoint(x: 500, y: 350)
        resultLabel = SKLabelNode(text: "0")
        resultLabel?.position = CGPoint(x: 500, y: 280)
        addNode(node: box)
        addNode(node: label!)
        addNode(node: resultLabel!)
    }
    
    override func event(id: Int, data:Array<Int> = []) {

        switch id {
        //set write bus 1
        case 1:
            write1V = data[0]
            break
        //set write bus 2
        case 2:
            write2V = data[0]
        //set read bus
        case 3:
            readV = data[0]
        case 4:
            //value received for data bus
            inputBus?.value = data[0]
        default:
            print("Error")
        }
    }

    func updateLabel() {
        let sign = subtractV == 0 ? "+" : "-"
        let text = "\(reg1!.value ) \(sign) \(reg2!.value )"
        label!.text = text
        
        let result = subtractV == 0 ? reg1!.value + reg2!.value : reg1!.value - reg2!.value
        resultLabel!.text = String(result)
        regOut?.value = result
    }
}

