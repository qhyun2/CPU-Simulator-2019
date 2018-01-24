//
//  EventQueue.swift
//  CPU Simulator 2019
//
//  Created by Hao Yun on 2018-01-14.
//  Copyright © 2018 Hao Yun. All rights reserved.
//

import Foundation

struct Event {
    //delay until this event should be run in ms
    var delay = 0

    //id of event and which scene to trigger event in
    var id = 0
    var scene: Scene

    //extra parameters for the event
    var data: Array<Int>

    init(delay: Int, id: Int, scene: Scene, data: Array<Int> = []) {
        self.delay = delay
        self.id = id
        self.scene = scene
        self.data = data
    }
}

class EventQueue {

    var events: Array<Event> = []
    var timer: Int = 0
    var last = 0
    var speedMod = 1.0

    func addEvent(event: Event) {
        events.append(event)
    }

    func update(delta: TimeInterval) {

        if !events.isEmpty {
            //current time in ms
            let now = Int(delta.magnitude * 1000)

            //calculate time passed
            let passed = now - last

            //store current time as previous time
            last = now

            //add on to timer
            timer += Int(Double(passed) * speedMod)
        }

        //then timer is greater then the required delay the event will be triggered
        if let current = events.first {
            if timer >= current.delay {
                current.scene.event(id: current.id, data: current.data)

                //event passed, remove from queue
                events.removeFirst()

                //reset timer
                timer -= current.delay
            }
        }
    }
}
