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
    private var memory: Array<SKShapeNode> = Array()
    private var accessIndicator = SKShapeNode()
    private var writeIndicator = SKShapeNode()
    private var addressBus: Array<SKShapeNode> = Array()
    private var dataBus: Array<SKShapeNode> = Array()
    private var readLine = SKShapeNode()
    private var writeLine = SKShapeNode()

    //other variables
    private var memoryValue: Array<Int> = Array(repeating: 0, count: 256)

    public var addressBusValue = 0 {
        didSet {
            updateState(source: 1)
        }
    }
    public var dataBusValue = 0 {
        didSet {
            if dataBusValue < 32768 && dataBusValue > -32768 {
                updateState(source: 2)
            }
        }
    }
    public var reading = false {
        didSet {
            updateState(source: 3)
        }
    }
    public var writing = false {
        didSet {
            updateState(source: 4)
        }
    }

    //current page the memory is displaying
    var page = 0

    //initialize the game scene
    override init(id: Int, controller: SceneController, bg: String) {

        super.init(id: id, controller: controller, bg:bg)

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
        busWidth = CGFloat(screenWidth * 0.04)
        busHeight = CGFloat(screenHeight * 0.2)
        lineLocation = CGFloat(screenHeight * 0.945)

        //******** background box ********
        let memoryBackground = SKShapeNode.init(rectOf: CGSize.init(width: CGFloat(screenWidth * 0.88), height: CGFloat(screenWidth * 0.46)))
        memoryBackground.position.x = CGFloat(centerX - 70)
        memoryBackground.position.y = CGFloat(memoryY + unitHeight / 2)
        memoryBackground.fillColor = SKColor.init(white: 0, alpha: 0.65)
        memoryBackground.lineWidth = 4
        memoryBackground.strokeColor = SKColor.blue
        addNode(node: memoryBackground)

        //******** read line ********
        var offsetX = CGFloat(screenWidth * 0.77)
        var cellWidth = CGFloat(busWidth * 0.45)
        var cellHeight = CGFloat(busHeight)

        //create position object
        var position = CGPoint.init(x: offsetX, y: lineLocation)

        //create cell
        readLine = SKShapeNode.init(rectOf: CGSize.init(width: cellWidth, height: cellHeight), cornerRadius: 0)
        readLine.position = position
        readLine.lineWidth = 2
        readLine.fillColor = SKColor.gray
        readLine.lineWidth = 4
        readLine.strokeColor = SKColor.black
        readLine.zPosition = 5

        //add to array and scene
        addNode(node: readLine)

        //******** write line ********
        offsetX = CGFloat(screenWidth * 0.8)
        cellWidth = CGFloat(busWidth * 0.45)
        cellHeight = CGFloat(busHeight)

        //create position object
        position = CGPoint.init(x: offsetX, y: lineLocation)

        //create cell
        writeLine = SKShapeNode.init(rectOf: CGSize.init(width: cellWidth, height: cellHeight), cornerRadius: 0)
        writeLine.position = position
        writeLine.lineWidth = 2
        writeLine.fillColor = SKColor.gray
        writeLine.lineWidth = 4
        writeLine.strokeColor = SKColor.black
        writeLine.zPosition = 5

        //add to array and scene
        addNode(node: writeLine)

        //******** address bus ************
        for i in 0...7 {
            let offsetX = CGFloat(Float(i) * width + screenWidth * 0.04)
            let cellWidth = CGFloat(busWidth * 0.45)
            let cellHeight = CGFloat(busHeight)

            //create position object
            let position = CGPoint.init(x: offsetX, y: lineLocation)

            //create cell
            let cell = SKShapeNode.init(rectOf: CGSize.init(width: cellWidth, height: cellHeight), cornerRadius: 0)
            cell.position = position
            cell.lineWidth = 2
            cell.fillColor = SKColor.gray
            cell.lineWidth = 4
            cell.strokeColor = SKColor.black
            cell.zPosition = 5


            //add to array and scene
            addressBus.append(cell)
            addNode(node: cell)
        }

        //******** data bus ***********
        for i in 0...15 {
            let offsetX = CGFloat(Float(i) * width + screenWidth * 0.2754)
            let cellWidth = CGFloat(busWidth * 0.45)
            let cellHeight = CGFloat(busHeight)

            //create position object
            let position = CGPoint.init(x: offsetX, y: lineLocation)

            //create cell
            let cell = SKShapeNode.init(rectOf: CGSize.init(width: cellWidth, height: cellHeight))
            cell.position = position
            cell.lineWidth = 2
            cell.fillColor = SKColor.gray
            cell.lineWidth = 4
            cell.strokeColor = SKColor.black
            cell.zPosition = 5


            //add to array and scene
            dataBus.append(cell)
            addNode(node: cell)
        }

        //******** memory labels ********
        for i in 0..<col {

            let offsetX = CGFloat(Float(i) * width + memoryX)
            let position = CGPoint.init(x: offsetX, y: CGFloat(memoryY + unitHeight))

            //external display counts from 1 not 0
            let addressLabel = SKLabelNode(text: String(i + 1))
            addressLabel.position = position
            addressLabel.fontName = "AmericanTypewriter-Bold"
            addressLabel.fontSize = 20
            addressLabel.fontColor = SKColor.orange

            addNode(node: addressLabel)
        }

        //******** access indicator ********
        accessIndicator = SKShapeNode.init(rectOf: CGSize.init(width: CGwidth, height: CGFloat(unitHeight + 15)))
        accessIndicator.fillColor = SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 0.4)
        accessIndicator.zPosition = 3
        addNode(node: accessIndicator)

        //******** write indicator *******
        writeIndicator = SKShapeNode.init(rectOf: CGSize.init(width: CGwidth, height: CGFloat(unitHeight + 15)))
        writeIndicator.fillColor = SKColor.init(red: 0.0196, green: 0.6862, blue: 0.2274, alpha: 0.4)
        writeIndicator.zPosition = 3
        addNode(node: writeIndicator)

        //******** memory cell bank ********
        for i in 0..<col {
            for j in 0..<row {

                //determine positions and size
                let offsetX = CGFloat(Float(i) * width + memoryX)
                let offsetY = CGFloat(Float(j) * width + memoryY)

                let cellWidth = CGFloat(CGwidth * 0.45)
                let cellHeight = CGFloat(CGwidth * 0.8)

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

        //fill memory with random values
        
        updateMemory(address: 1, data: 41)
        updateMemory(address: 2, data: 31)
        addressBusValue = 1
        
        for _ in 0...31 {
            //let randomInt = Int(arc4random_uniform(65536)) - 32768
            //let _ = updateMemory(address: i, data: randomInt)
        }
    }

    //update state when a change in state is detected
    func updateState(source: Int) {

        //******** update displays ********
        switch source {
        case 1: //address bus changed

            //external display counts from 1
            let unpaddedBinary = String(addressBusValue + 1, radix: 2) //binary base
            let padding = String.init(repeating: "0", count: (8 - unpaddedBinary.count))
            let binary = Array(padding + unpaddedBinary)

            //update each individual cell
            for (index, i) in addressBus.enumerated() {

                //determine color based on binary value
                if(binary[index] == "1") {
                    i.fillColor = SKColor.blue
                } else {
                    i.fillColor = SKColor.gray
                }
            }
            break
        case 2: //data bus changed
            let unpaddedBinary = String(dataBusValue, radix: 2) //binary base
            let padding = String.init(repeating: "0", count: (16 - unpaddedBinary.count))
            let binary = Array(padding + unpaddedBinary)

            //update each individual cell
            for (index, i) in dataBus.enumerated() {

                //determine color based on binary value
                if(binary[index] == "1" || binary[index] == "-") {
                    i.fillColor = SKColor.blue
                } else {
                    i.fillColor = SKColor.gray
                }
            }
            break
        case 3: //read line changed
            readLine.fillColor = reading ? SKColor.init(red: 0.4823, green: 0.078, blue: 0.6588, alpha: 1) : SKColor.gray
            if (reading && controller.currentScene == id) {
                //update read indicator
                accessIndicator.position = CGPoint.init(x: CGFloat(memoryX + Float(addressBusValue % 32) * width), y: memoryTop)
                accessIndicator.isHidden = false
            } else {
                accessIndicator.isHidden = true
            }
            break
        case 4: //write line changed
            writeLine.fillColor = writing ? SKColor.green : SKColor.gray
            if (writing && controller.currentScene == id) {
                //update read indicator
                writeIndicator.position = CGPoint.init(x: CGFloat(memoryX + Float(addressBusValue % 32) * width), y: memoryTop)
                writeIndicator.isHidden = false
            } else {
                writeIndicator.isHidden = true
            }
            break
        default:
            break
        }

        //update values in memory or on data bus based on write or read
        //writing takes precedent over reading
        //if both lines are on (should never happen in normal operation) writing will happen and reading will be skipped
        if writing {
            let _ = updateMemory(address: addressBusValue, data: dataBusValue)
        } else {
            //source cannot be 2 as that is from the data bus value updating leading to an infinite loop
            if source != 2 {
                if reading {
                    dataBusValue = memoryValue[addressBusValue]
                } else {
                    dataBusValue = 0
                }
            }
        }
    }

    //updated given memory location with given data
    func updateMemory(address: Int, data: Int) -> Bool {

        //update value
        memoryValue[address] = data

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

        return false
    }

    override func event(id: Int) {
        switch id {
        case 1:
            //read line on
            reading = true
            break
        case 2:
            //read line off
            reading = false
            break
        case 3:
            //write line on
            writing = true
            break
        case 4:
            //write line off
            writing = false
            break
        case 5:
            //
            break
        case 6:
            //
            break
        default:
            print("Memory Event Error")
        }
    }

    override func update(_ currentTime: TimeInterval) {

//        sleep(1)
//        dataBusValue = Int(arc4random_uniform(65536)) - 32768
//        addressBusValue = Int(arc4random_uniform(30) + 1)
//        writing = true
        //reading = true
        //addressBusValue = 30
        //dataBusValue = 1231
        //addressBusValue = 0
        //writing = true
        //writing = arc4random_uniform(2) == 1
        //reading = arc4random_uniform(2) == 1
    }
}
