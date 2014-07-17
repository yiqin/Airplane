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
    
    let kMyPlaneMask = UInt32(1)
    let kEnemyPlaneMask = UInt32(2)
    let kBulletMask = UInt32(3)
    
    
    var timer = NSTimer()
    
    var background1 = SKSpriteNode()
    var background2 = SKSpriteNode()
    
    var myPlaneNode = SKNode()
    var pauseButton = UIButton()
    
    var bullet = SKSpriteNode()
    var bulletSpeed = Double()
    
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
        
        self.myPlaneNode.addChild(myPlane)
        self.myPlaneNode.addChild(myPropeller)
        self.myPlaneNode.position = CGPointMake(CGRectGetMidX(self.frame), 100)
        self.myPlaneNode.zPosition = 10
        self.myPlaneNode.physicsBody = SKPhysicsBody(rectangleOfSize: myPlane.size)
        self.myPlaneNode.physicsBody.allowsRotation = false
        self.myPlaneNode.physicsBody.categoryBitMask = self.kMyPlaneMask
        self.myPlaneNode.physicsBody.contactTestBitMask = self.kEnemyPlaneMask
        self.myPlaneNode.physicsBody.collisionBitMask = self.kEnemyPlaneMask
        self.addChild(self.myPlaneNode)
        
        self.scoreLabel.fontName = "AmericanTypewriter-Bold"
        self.scoreLabel.fontSize = 20
        self.scoreLabel.fontColor = UIColor.blackColor()
        self.addChild(self.scoreLabel)
        
        self.playTimeLabel.fontName = "AmericanTypewriter-Bold"
        self.playTimeLabel.fontSize = 20
        self.playTimeLabel.fontColor = UIColor.blackColor()
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.3),SKAction.runBlock(self.shoot)])), withKey: "shootAction")
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0/100.0, target: self, selector: Selector("mainloop"), userInfo: nil, repeats: true)
    }
    
    func mainloop() {
        self.playTime++;
        
        self.backgroundLoop()
        
        if 0 == arc4random()%500 {
            self.newRandomCloud()
        }
        
        
    }
    
    // Background
    func backgroundLoop() {
        
    }
    
    // Generate random cloud
    func newRandomCloud() {
        let cloud = SKSpriteNode(imageNamed: "cloud")
        
        // This is the reason why I feel Swift sucks........................
        // let x = arc4random()%(Int)(self.frame.size.width+cloud.frame.size.width)- cloud.frame.size.width
        let x =  CGFloat (Int(arc4random())%Int(self.frame.size.width+cloud.frame.size.width))
        cloud.position = CGPointMake(x, self.frame.size.height+cloud.frame.size.height/2)
        
        let speed = Double (Int(arc4random())%Int(self.kCloudSpeedMax-self.kCloudSpeedMin)+self.kCloudSpeedMin)
        
        var cloudAction = SKAction.moveToY(0.0-cloud.frame.size.height, duration: 1)
        
        /*
        cloud.runAction(cloudAction, completion: {
            cloud.removeFromParent()
            
        })
        */
        
        let remove = SKAction.removeFromParent()
        
        cloud.runAction(SKAction.sequence([cloudAction, remove]))
        
        // cloud.runAction(cloudAction,
            
        // cloud.zPosition = CGFloat(arc4random()%20 + 1)
        cloud.zPosition = 2
        
        
        self.addChild(cloud)
    }
    
    // Shoot
    func shoot() {
        // Why self.bullet ??????
        self.bullet = SKSpriteNode(imageNamed: "bullet")
        self.bullet.position = CGPointMake(self.myPlaneNode.position.x, self.myPlaneNode.position.y+self.bullet.size.height+30)
        self.bullet.zPosition = 1
        self.bullet.setScale(0.8)
        self.bullet.physicsBody = SKPhysicsBody(rectangleOfSize: self.bullet.size)
        self.bullet.physicsBody.allowsRotation = false
        self.bullet.physicsBody.categoryBitMask = self.kBulletMask
        self.bullet.physicsBody.contactTestBitMask = self.kEnemyPlaneMask
        self.bullet.physicsBody.collisionBitMask = self.kEnemyPlaneMask

        
        let action = SKAction.moveToY(self.frame.size.height + self.bullet.size.height, duration: self.bulletSpeed)
        let remove = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, remove]))
        
        self.addChild(bullet)
    }
    
    // Control the airplane
    override func didMoveToView(view: SKView!) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        self.view.addGestureRecognizer(panRecognizer)
    }
    
    func handlePanGesture(recognier: UIPanGestureRecognizer) {
        let translation = recognier.translationInView(self.view)
        var x = self.myPlaneNode.position.x + translation.x
        var y = self.myPlaneNode.position.y - translation.y
        
        x = fminf(fmaxf(x, self.myPlaneNode.frame.size.width/2), self.frame.size.width-self.myPlaneNode.frame.size.width/2)
        y = fminf(fmaxf(y, self.myPlaneNode.frame.size.width/2), self.frame.size.height-self.myPlaneNode.frame.size.width/2)
        
        self.myPlaneNode.position = CGPointMake(x, y)
        
        recognier.setTranslation(CGPointMake(0.0, 0.0), inView: self.view)
    }
    
}
































