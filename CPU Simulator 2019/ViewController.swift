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
 
 Memory Scene:
 
 ALU:
 -Input and Result registers
 -Op Codes
 -Flags
 
 Control Unit:
 -Intruction id input
 -Intruction representation
 
 */

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    var SceneController = SKScene(fileNamed: "SceneController")!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Set the scale mode to scale to fit the window
        let viewer = self.skView!
        viewer.preferredFramesPerSecond = 40
        SceneController.scaleMode = .aspectFit
        // Present the scene
        viewer.presentScene(SceneController)

        /* These are all of the options for NSApplicationPresentationOptions
             .Default
             .AutoHideDock              |   /
             .AutoHideMenuBar           |   /
             .DisableForceQuit          |   /
             .DisableMenuBarTransparency|   /
             .FullScreen                |   /
             .HideDock                  |   /
             .HideMenuBar               |   /
             .DisableAppleMenu          |   /
             .DisableProcessSwitching   |   /
             .DisableSessionTermination |   /
             .DisableHideApplication    |   /
             .AutoHideToolbar
             .HideMenuBar               |   /
             .DisableAppleMenu          |   /
             .DisableProcessSwitching   |   /
             .DisableSessionTermination |   /
             .DisableHideApplication    |   /
             .AutoHideToolbar
         */

        let presOptions: NSApplication.PresentationOptions = ([.fullScreen, .autoHideMenuBar])
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions:
                presOptions.rawValue]

        viewer.enterFullScreenMode(NSScreen.main!, withOptions: optionsDictionary)
        viewer.ignoresSiblingOrder = true
        viewer.showsFPS = true
        viewer.showsNodeCount = true
    }
}
