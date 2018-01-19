//
//  ViewController.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2017-11-21.
//  Copyright © 2017 Hao Yun. All rights reserved.
//
import Cocoa
import SpriteKit
import GameplayKit

/* Project Outline
 
 Sprint 2:
 XCreate working memory display
 XDisplay when sections are accessed
 
 Sprint 3:
 -Write Scene Controller
 
 
 Overall:

 
 Overview:
 -Represent each scene connected together
 -component selection
 -returning from scenes
 
 Memory Scene:
 -split up updateState function
 
 ALU:
 -Input and Result registers
 -Op Codes
 -Flags
 
 Control Unit:
 -Intruction id input
 -Intruction representation
 -intruction execution
 
 */

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!

    var SceneController = SKScene(fileNamed: "SceneController")!

    lazy var window: NSWindow = self.view.window!
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        // Set the scale mode to scale to fit the window
        let viewer = self.skView!
        SceneController.scaleMode = .aspectFit
        // Present the scene
        viewer.presentScene(SceneController)
        
        //mystery most of the time fullscreen works stuff
        let presOptions: NSApplication.PresentationOptions = ([])
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions:
                presOptions.rawValue]
        viewer.enterFullScreenMode(NSScreen.main!, withOptions: optionsDictionary)
        viewer.showsFPS = true
        viewer.showsNodeCount = true

        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            //print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
            return $0
        }
    }
}
