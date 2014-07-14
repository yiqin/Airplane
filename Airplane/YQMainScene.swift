//
//  YQMainScene.swift
//  Airplane
//
//  Created by yiqin on 7/13/14.
//  Copyright (c) 2014 yipick. All rights reserved.
//

import SpriteKit


class YQMainScene: SKScene, SKPhysicsContactDelegate {
    
    let kBgImageHeight = 600
    let kBgSpeed = 10
    let kScorePerPlane = 100
    
    let kCloudSpeedMin = 5
    let kCloudSpeedMax = 15
    
    let kEnemySpeedMin = 3
    let kEnemySpeedMax = 5
    
    let kMyPlaneMask = 1
    let kEnemyPlaneMask = 2
    let kBulletMask = 3
    
    
    
    init(size: CGSize) {
        super.init(size: size)
        self.startGame()
    }
    
    func startGame() {
        self.removeAllActions()
        self.removeAllChildren()
    }
}
