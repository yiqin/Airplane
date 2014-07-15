//
//  YQMainScene.swift
//  Airplane
//
//  Created by yiqin on 7/13/14.
//  Copyright (c) 2014 yipick. All rights reserved.
//

import SpriteKit


class YQMainScene: SKScene, SKPhysicsContactDelegate {
    
    let kBgImageHeight = 600.0
    let kBgSpeed = 10
    let kScorePerPlane = 100
    
    let kCloudSpeedMin = 5
    let kCloudSpeedMax = 15
    
    let kEnemySpeedMin = 3
    let kEnemySpeedMax = 5
    
    let kMyPlaneMask = 1
    let kEnemyPlaneMask = 2
    let kBulletMask = 3
    
    
    var timer = NSTimer()
    
    var bg1 = SKSpriteNode()
    var bg2 = SKSpriteNode()
    
    var myPlaneNode = SKNode()
    var pauseButton = UIButton()
    
    var bullet = SKSpriteNode()
    var bulletSpeed = Float()
    
    var scoreLabel = SKLabelNode()
    var score = Int()
    var playTimeLabel = SKLabelNode()
    var playTime = Int()
    
    
    init(size: CGSize) {
        super.init(size: size)
        self.startGame()
    }
    
    func startGame() {
        self.removeAllActions()
        self.removeAllChildren()
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self;
        
        self.score = 0
        self.playTime = 0
        self.bulletSpeed = 0.5
        
        self.bg1 = SKSpriteNode(imageNamed:"bg")
        self.bg2 = SKSpriteNode(imageNamed: "bg")
        
        
        self.bg1.position = CGPointMake(CGRectGetMidX(self.frame), CGFloat((kBgImageHeight)/Double(2.0)))
        self.bg2.position = CGPointMake(CGRectGetMidX(self.frame), CGFloat(kBgImageHeight*0.5+kBgImageHeight))
        
        
        
    }
    
    
    
}
