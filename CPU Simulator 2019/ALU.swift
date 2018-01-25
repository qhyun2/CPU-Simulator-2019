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

var zeroFlag = true

class ALU: Scene {

    var write1V = 0
    {
        didSet {
            write1?.value = write1V
            write1Hor?.value = write1V
            controller.overview?.event(id: 5, data: [write1V])
            if controller.currentScene == controller.ALUid {
                write1Ind?.isHidden = write1V == 0
            }
            //only write on turning on
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
            write2Hor?.value = write2V
            controller.overview?.event(id: 6, data: [write2V])
            if controller.currentScene == controller.ALUid {
                write2Ind?.isHidden = write2V == 0
            }
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
            readHor?.value = readV
            controller.overview?.event(id: 7, data: [readV])
            if controller.currentScene == controller.ALUid {
                readInd?.isHidden = readV == 0 && controller.currentScene == controller.ALUid
            }
            if readV == 1 {

                //update input bus
                inputBus!.value = regOut!.value

                //set main controller bus to be this value
                controller.overview?.event(id: 1, data: [(regOut?.value)!])
            }
        }
    }
    var subtractV = 0 {
        didSet {
            controller.overview?.event(id: 8, data: [subtractV])
            subtract?.value = subtractV
            updateLabel()
        }
    }

    var inputBus: Bus?
    var write1: Bus?
    var write2: Bus?
    var read: Bus?
    var reg1: Bus?
    var reg2: Bus?
    var regOut: Bus?
    var subtract: Bus?
    var label: SKLabelNode?
    var resultLabel: SKLabelNode?
    var write1Ind: SKShapeNode?
    var write2Ind: SKShapeNode?
    var readInd: SKShapeNode?
    var write1Hor: HorizontalBus?
    var write2Hor: HorizontalBus?
    var readHor: HorizontalBus?

    override init(id: Int, controller: SceneController, bg: String) {

        super.init(id: id, controller: controller, bg: bg)

        //background box
        let bgBox = SKShapeNode.init(rectOf: CGSize.init(width: 800, height: 800))
        bgBox.position = CGPoint(x: 450, y: 530)
        bgBox.fillColor = SKColor.init(white: 0, alpha: 0.65)
        bgBox.lineWidth = 4
        bgBox.strokeColor = SKColor.blue
        addNode(node: bgBox)

        //input bus
        inputBus = Bus(x: 160, y: 770, width: 700, height: 100, bits: 16, scene: self)
        inputBus?.enableLabel(x: 80, y: 750, fontSize: 32, scene: self)

        //control lines
        write1 = Bus(x: 900, y: 770, width: 30, height: 218, bits: 1, scene: self)
        write1?.activeColour = SKColor.green
        write1Hor = HorizontalBus(x: 848, y: 680, width: 132, height: 40, bits: 1, spacing: 1.0, scene: self)
        write1Hor?.activeColour = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1)

        write2 = Bus(x: 970, y: 770, width: 30, height: 340, bits: 1, scene: self)
        write2?.activeColour = SKColor.green
        write2Hor = HorizontalBus(x: 875, y: 620, width: 218, height: 40, bits: 1, spacing: 1.0, scene: self)
        write2Hor?.activeColour = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1)

        read = Bus(x: 1040, y: 770, width: 30, height: 1140, bits: 1, scene: self)
        read?.activeColour = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1)
        readHor = HorizontalBus(x: 925, y: 217, width: 260, height: 40, bits: 1, spacing: 1.0, scene: self)
        readHor?.activeColour = SKColor.green

        subtract = Bus(x: 1110, y: 770, width: 30, height: 100, bits: 1, scene: self)
        subtract?.activeColour = SKColor.yellow

        //registers
        reg1 = Bus(x: 160, y: 680, width: 700, height: 40, bits: 16, scene: self)
        reg1?.enableLabel(x: 80, y: 670, fontSize: 32, scene: self)
        reg2 = Bus(x: 160, y: 620, width: 700, height: 40, bits: 16, scene: self)
        reg2?.enableLabel(x: 80, y: 610, fontSize: 32, scene: self)
        regOut = Bus(x: 160, y: 217, width: 700, height: 40, bits: 16, scene: self)
        regOut?.enableLabel(x: 80, y: 207, fontSize: 32, scene: self)

        //indicators
        write1Ind = SKShapeNode(rect: CGRect(x: 132, y: 652, width: 700, height: 56))
        write1Ind!.fillColor = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 0.4)
        write1Ind!.zPosition = 100
        write1Ind!.isHidden = true
        addNode(node: write1Ind!)
        write2Ind = SKShapeNode(rect: CGRect(x: 132, y: 590, width: 700, height: 56))
        write2Ind!.fillColor = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 0.4)
        write2Ind!.zPosition = 100
        write2Ind!.isHidden = true
        addNode(node: write2Ind!)
        readInd = SKShapeNode(rect: CGRect(x: 132, y: 190, width: 700, height: 56))
        readInd!.fillColor = SKColor.init(red: 0.0196, green: 0.6862, blue: 0.2274, alpha: 0.4)
        readInd!.zPosition = 100
        readInd!.isHidden = true
        addNode(node: readInd!)

        let box = SKShapeNode(rect: CGRect(x: 319, y: 305, width: 320, height: 200), cornerRadius: 35)
        box.fillColor = SKColor.black
        box.strokeColor = SKColor.cyan
        box.lineWidth = 10

        addNode(node: controller.makeLabel(x: 1110, y: 698, fontSize: 20, colour: SKColor.orange, text: "Subtract"))

        label = controller.makeLabel(x: 475, y: 430, fontSize: 40, colour: SKColor.orange, text: "0 + 0")
        resultLabel = controller.makeLabel(x: 475, y: 350, fontSize: 40, colour: SKColor.orange, text: "0")
        resultLabel?.position = CGPoint(x: 475, y: 341)
        addNode(node: box)
        addNode(node: label!)
        addNode(node: resultLabel!)
    }

    override func event(id: Int, data: Array<Int> = []) {

        switch id {
        case 1:
            //set write bus 1
            write1V = data[0]
            break
        case 2:
            //set write bus 2
            write2V = data[0]
        case 3:
            //set read bus
            readV = data[0]
        case 4:
            //value received for data bus
            inputBus?.value = data[0]
        case 5:
            //subtract bus set
            subtractV = data[0]
        default:
            print("ALU Event Error")
        }
    }
    func updateLabel() {
        let sign = subtractV == 0 ? "+" : "-"
        let text = "\(reg1!.value) \(sign) \(reg2!.value)"
        label!.text = text

        var result = subtractV == 0 ? reg1!.value + reg2!.value : reg1!.value - reg2!.value
        result = result < 0 ? 0 : result
        result = result > 65535 ? 65535 : result
        zeroFlag = result == 0
        resultLabel!.text = String(result)
        regOut?.value = result
    }

    override func show() {
        super.show()
        write1Ind?.isHidden = true
        write2Ind?.isHidden = true
        readInd?.isHidden = true
    }
}

