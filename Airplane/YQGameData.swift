//
//  YQGameData.swift
//  Airplane
//
//  Created by yiqin on 7/13/14.
//  Copyright (c) 2014 yipick. All rights reserved.
//

import Foundation


class YQGameData: NSObject {
    
    var score: Int
    var time: Int
    
    init() {
    
        
        self.score = 0
        self.time = 0
        
        super.init()
    }
}