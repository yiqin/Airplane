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
    
    var background1 = SKSpriteNode()
    var background2 = SKSpriteNode()
    
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
        
        self.background1 = SKSpriteNode(imageNamed:"background")
        self.background2 = SKSpriteNode(imageNamed: "background")
        
        self.background1.position = CGPointMake(CGRectGetMidX(self.frame), CGFloat((kBgImageHeight)/Double(2.0)))
        self.background2.position = CGPointMake(CGRectGetMidX(self.frame), CGFloat(kBgImageHeight*0.5+kBgImageHeight))
        
        self.addChild(self.background1)
        self.addChild(self.background2)
        
        let myPlane = SKSpriteNode(imageNamed: "myplane")
        let myPropeller = SKSpriteNode(imageNamed: "propeller1")
        let propeller1 = SKTexture(imageNamed: "propeller1")
        let propeller2 = SKTexture(imageNamed: "propeller2")
        let rotateAction = SKAction.animateWithTextures([propeller1,propeller2], timePerFrame: 0.01)
        let rotateForever = SKAction.repeatActionForever(rotateAction)
        myPropeller.runAction(rotateForever)
        myPropeller.position = CGPointMake(-1, myPlane.size.height/2-2)
        
        
        // not sure whether myPlaneNode init or not
        // yes
        self.myPlaneNode.addChild(myPlane)
        self.myPlaneNode.addChild(myPropeller)
        self.myPlaneNode.position = CGPointMake(CGRectGetMidX(self.frame), 100)
        self.myPlaneNode.zPosition = 10
        self.myPlaneNode.physicsBody = SKPhysicsBody(rectangleOfSize: myPlane.size)
        self.myPlaneNode.physicsBody.allowsRotation = false
        self.myPlaneNode.physicsBody.categoryBitMask = UInt32(self.kMyPlaneMask)
        self.myPlaneNode.physicsBody.contactTestBitMask = UInt32(self.kEnemyPlaneMask)
        self.myPlaneNode.physicsBody.collisionBitMask = UInt32(self.kEnemyPlaneMask)
        self.addChild(self.myPlaneNode)
        
        // same problem
        self.scoreLabel.fontName = "AmericanTypewriter-Bold"
        self.scoreLabel.fontSize = 20
        self.scoreLabel.fontColor = UIColor.blackColor()
        self.addChild(self.scoreLabel)
        
        self.playTimeLabel.fontName = "AmericanTypewriter-Bold"
        self.playTimeLabel.fontSize = 20
        self.playTimeLabel.fontColor = UIColor.blackColor()
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.3),SKAction.runBlock(self.shoot)])), withKey: "shootAction")
        
        // No selector anymore
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0/100.0, target: self, selector: Selector("mainloop"), userInfo: nil, repeats: true)
        
    }
    
    func mainloop() {
        
        
    }
    
    func shoot() {
        
        
    }
    
    
}
