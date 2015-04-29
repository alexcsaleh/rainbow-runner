//
//  Position.swift
//  RainbowRun
//
//  Created by Natili, Giorgio on 4/21/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation

class Slot{
    
    var x:Float
    var id:UInt32
    var used:Bool = false
    
    init (x:Float){
    
        self.x = x
        self.id = UInt32(0.175 * Float(100))
    
    }
    
}