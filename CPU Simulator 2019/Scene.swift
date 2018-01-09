//
//  Scene.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-09.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation

open class Scene {

    var id: Int

    init(id: Int) {
        self.id = id
    }

    open func sceneDidLoad() { }
    open func update(_ currentTime: TimeInterval) { }

    func getID() -> Int {
        return id
    }
}
