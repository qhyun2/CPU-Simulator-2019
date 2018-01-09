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



class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    var memory = SKScene(fileNamed: "Memory")!
    var alu = SKScene(fileNamed: "ALU")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the SKScene from 'GameScene.sks'
        // Set the scale mode to scale to fit the window
        let viewer = self.skView!
        memory.scaleMode = .aspectFit
        
        //instructiondecoder.setGD(self)

        // Present the scene
        viewer.presentScene(memory)

        let presOptions: NSApplication.PresentationOptions = ([.fullScreen, .autoHideMenuBar])
        /*These are all of the options for NSApplicationPresentationOptions
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
             .AutoHideToolbar */

        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions:
                presOptions.rawValue]

        viewer.enterFullScreenMode(NSScreen.main!, withOptions: optionsDictionary)
        viewer.ignoresSiblingOrder = true
        viewer.showsFPS = true
        viewer.showsNodeCount = true
    }
}
