//
//  GameScene.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//

import SpriteKit
import GameplayKit
import Cocoa

class Memory: Scene {

    //constant "settings"
    //hindsight comment - this was a mistake there does not need to be this many things especially all uninitialized, some of them are still being used somenot. I do not have the time or effort to figure that out
    var dataSize = 16
    var storageSize = 32
    var row = 0
    var col = 0
    var screenWidth = Float()
    var screenHeight = Float()
    var CGwidth = CGFloat()
    var width = Float()
    var unitWidth = Float()
    var unitHeight = Float()
    var centerX = Float()
    var centerY = Float()
    var memoryX = Float()
    var memoryY = Float()
    var memoryTop = CGFloat()
    var busWidth = CGFloat()
    var busHeight = CGFloat()
    var lineLocation = CGFloat()

    //objects in scene
    var memory: Array<SKShapeNode> = Array()
    var memoryLabels: Array<SKLabelNode> = Array()
    var accessIndicator = SKShapeNode()
    var writeIndicator = SKShapeNode()
    var readLine = SKShapeNode()
    var writeLine = SKShapeNode()
    var dataBus: Bus?
    var addressBus: Bus?
    var memoryValue: Array<Int> = Array(repeating: 0, count: 256)

    //busses that need to be kept updated
    public var addressBusValue = 0 {
        didSet {
            addressBus!.value = addressBusValue
            addressBus!.updateDisplay()
            
            //update overview display
            controller.overview?.event(id: 2, data:[addressBus!.value])
        }
    }
    public var dataBusValue = 0 {
        didSet {
            dataBus!.value = dataBusValue
            dataBus!.updateDisplay()
        }
    }
    public var reading = false {
        didSet {
            readLine.fillColor = reading ? SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1) : SKColor.gray
            if (reading && controller.currentScene == id) {
                //update read indicator
                accessIndicator.position = CGPoint.init(x: CGFloat(53 + Float(addressBusValue % 32) * 43), y: memoryTop + 39)
                accessIndicator.isHidden = false
            } else {
                accessIndicator.isHidden = true
            }
            updateState()
        }
    }
    public var writing = false {
        didSet {
            writeLine.fillColor = writing ? SKColor.green : SKColor.gray
            if (writing && controller.currentScene == id) {
                //update read indicator
                writeIndicator.position = CGPoint.init(x: CGFloat(53 + Float(addressBusValue % 32) * 43), y: memoryTop + 39)
                writeIndicator.isHidden = false
            } else {
                writeIndicator.isHidden = true
            }
            updateState()
        }
    }

    //current page the memory is displaying
    var page = 0

    //initialize the game scene
    override init(id: Int, controller: SceneController, bg: String) {

        super.init(id: id, controller: controller, bg: bg)

        row = 16
        col = 32
        screenWidth = Float(stage.size.width)
        screenHeight = Float(stage.size.height)
        CGwidth = (stage.size.width + stage.size.height) * 0.017
        width = Float(CGwidth)
        unitWidth = width * Float(col)
        unitHeight = width * Float(row)
        centerX = Float(stage.size.width / 2)
        centerY = Float(stage.size.height / 2)
        memoryX = screenWidth * 0.04
        memoryY = screenHeight * 0.05
        memoryTop = CGFloat(memoryY + unitHeight / 2 - 14)
        dataBus = Bus(x: 400, y: 770, width: 600, height: 200, bits: 16, spacing: 0.75, scene: self)
        dataBus?.enableLabel(x: 678, y: 710, fontSize: 45, scene: self)
        addressBus = Bus(x: 50, y: 770, width: 300, height: 200, bits: 8, spacing: 0.75, scene: self)
        addressBus?.enableLabel(x: 180, y: 710, fontSize: 45, scene: self)

        //******** background box ********
        let memoryBackground = SKShapeNode.init(rectOf: CGSize.init(width: CGFloat(screenWidth * 0.96), height: CGFloat(screenWidth * 0.46)))
        memoryBackground.position.x = 720
        memoryBackground.position.y = CGFloat(memoryY + unitHeight / 2)
        memoryBackground.fillColor = SKColor.init(white: 0, alpha: 0.65)
        memoryBackground.lineWidth = 4
        memoryBackground.strokeColor = SKColor.blue
        addNode(node: memoryBackground)

        //******** read line ********
        readLine = SKShapeNode.init(rectOf: CGSize.init(width: 30, height: 200))
        readLine.position = CGPoint(x: 1160, y: 770)
        readLine.fillColor = SKColor.gray
        readLine.strokeColor = SKColor.black
        readLine.lineWidth = 4
        readLine.zPosition = 5
        addNode(node: readLine)

        //******** write line ********
        writeLine = SKShapeNode.init(rectOf: CGSize.init(width: 30, height: 200))
        writeLine.position = CGPoint(x: 1100, y: 770)
        writeLine.fillColor = SKColor.gray
        writeLine.strokeColor = SKColor.black
        writeLine.lineWidth = 4
        writeLine.zPosition = 5
        addNode(node: writeLine)

        //******** memory labels ********
        for i in 0..<col {

            let offsetX = CGFloat(Float(i) * 43 + 53)
            let position = CGPoint.init(x: offsetX, y: CGFloat(memoryY + unitHeight))
            let addressLabel = SKLabelNode(text: String(i))
            addressLabel.position = position
            addressLabel.fontName = "AmericanTypewriter-Bold"
            addressLabel.fontSize = 20
            addressLabel.fontColor = SKColor.orange
            addNode(node: addressLabel)
        }

        //******** access indicator ********
        accessIndicator = SKShapeNode.init(rectOf: CGSize.init(width: CGwidth, height: CGFloat(unitHeight - 54)))
        accessIndicator.fillColor = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 0.4)
        accessIndicator.zPosition = 3
        accessIndicator.isHidden = true
        addNode(node: accessIndicator)

        //******** write indicator *******
        writeIndicator = SKShapeNode.init(rectOf: CGSize.init(width: CGwidth, height: CGFloat(unitHeight - 54)))
        writeIndicator.fillColor = SKColor.init(red: 0.0196, green: 0.6862, blue: 0.2274, alpha: 0.4)
        writeIndicator.zPosition = 3
        writeIndicator.isHidden = true
        addNode(node: writeIndicator)

        //******** memory cell bank ********
        for i in 0..<col {
            for j in 0..<row {

                //determine positions and size
                let offsetX = CGFloat(Float(i) * 43 + 53)
                let offsetY = CGFloat(Float(j) * 33 + 120)

                let cellWidth = CGFloat(43 * 0.45)
                let cellHeight = CGFloat(33 * 0.8)

                //create position object
                let position = CGPoint.init(x: offsetX, y: offsetY)

                //create cell
                let cell = SKShapeNode.init(rectOf: CGSize.init(width: cellWidth, height: cellHeight), cornerRadius: 0)
                cell.position = position
                cell.lineWidth = 2
                cell.fillColor = SKColor.gray
                cell.strokeColor = SKColor.black


                //add to array and scene
                memory.append(cell)
                addNode(node: cell)
            }
        }

        //memory value labels
        for i in 0...31 {
            let label = SKLabelNode(text: "0")
            if i % 2 == 0 {
                label.position = CGPoint(x: 52 + i * 43, y: 65)
            } else {
                label.position = CGPoint(x: 52 + i * 43, y: 30)
            }
            label.fontName = "AmericanTypewriter-Bold"
            label.fontSize = 27
            label.fontColor = SKColor.orange
            label.zPosition = 15
            memoryLabels.append(label)
            addNode(node: label)
        }

        //test values
        updateMemory(address: 0, data: 1)
        updateMemory(address: 1, data: 1)
        updateMemory(address: 2, data: 0)
        updateMemory(address: 3, data: 0)
        updateMemory(address: 24, data: 1324)
    }

    //update values in memory or on data bus based on write or read
    //writing takes precedent over reading
    //if both lines are on (should never happen in normal operation)
    //writing will happen and reading will be skipped
    func updateState() {
        if writing {
            updateMemory(address: addressBusValue, data: dataBusValue)
        } else {
            if reading {
                dataBusValue = memoryValue[addressBusValue]
                controller.overview?.event(id: 1, data: [dataBusValue])
            } else {
                dataBusValue = 0
                controller.overview?.event(id: 1, data: [dataBusValue])
            }
        }
    }

    //updated given memory location with given data
    func updateMemory(address: Int, data: Int) {

        //update value
        memoryValue[address] = data
        memoryLabels[address].text = String(data)

        //determine first cell of the set to be modified
        let firstCell = dataSize * address

        //binary visual representation
        let unpaddedBinary = String(data, radix: 2) //binary base
        let padding = String.init(repeating: "0", count: (dataSize - unpaddedBinary.count))
        let binary = Array(padding + unpaddedBinary)

        //update each individual cell
        for i in 0..<dataSize {
            //determine color based on binary value
            if(binary[i] == "1" || binary[i] == "-") {
                memory[firstCell + i].fillColor = SKColor.blue
            } else {
                memory[firstCell + i].fillColor = SKColor.gray
            }
        }
    }

    override func event(id: Int, data: Array<Int> = []) {
        switch id {
        case 1:
            //set write line
            writing = data[0] == 1
        case 2:
            //set read line
            reading = data[0] == 1
        case 3:
            //data bus value received from overview
            dataBusValue = data[0]
        case 4:
            //address bus value received from overview
            addressBusValue = data[0]

        default:
            print("Memory Event Error")
        }
    }
}
