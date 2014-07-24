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
        startGame()
    }
    
    func startGame() {
        removeAllActions()
        removeAllChildren()
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self;
        
        score = 0
        playTime = 0
        bulletSpeed = 0.5
        
        background1 = SKSpriteNode(imageNamed:"background")
        background2 = SKSpriteNode(imageNamed: "background")
        
        background1.position = CGPointMake(CGRectGetMidX(self.frame), CGFloat((kBgImageHeight)/Double(2.0)))
        background2.position = CGPointMake(CGRectGetMidX(self.frame), CGFloat(kBgImageHeight*0.5+kBgImageHeight))
        
        addChild(background1)
        addChild(background2)
        
        let myPlane = SKSpriteNode(imageNamed: "myplane")
        let myPropeller = SKSpriteNode(imageNamed: "propeller1")
        let propeller1 = SKTexture(imageNamed: "propeller1")
        let propeller2 = SKTexture(imageNamed: "propeller2")
        let rotateAction = SKAction.animateWithTextures([propeller1,propeller2], timePerFrame: 0.01)
        let rotateForever = SKAction.repeatActionForever(rotateAction)
        myPropeller.runAction(rotateForever)
        myPropeller.position = CGPointMake(-1, myPlane.size.height/2-2)
        
        myPlaneNode.addChild(myPlane)
        myPlaneNode.addChild(myPropeller)
        myPlaneNode.position = CGPointMake(CGRectGetMidX(frame), 100)
        myPlaneNode.zPosition = 10
        myPlaneNode.physicsBody = SKPhysicsBody(rectangleOfSize: myPlane.size)
        myPlaneNode.physicsBody.allowsRotation = false
        myPlaneNode.physicsBody.categoryBitMask = kMyPlaneMask
        myPlaneNode.physicsBody.contactTestBitMask = kEnemyPlaneMask
        myPlaneNode.physicsBody.collisionBitMask = kEnemyPlaneMask
        addChild(myPlaneNode)
        
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = UIColor.blackColor()
        addChild(scoreLabel)
        
        playTimeLabel.fontName = "AmericanTypewriter-Bold"
        playTimeLabel.fontSize = 20
        playTimeLabel.fontColor = UIColor.blackColor()
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.3),SKAction.runBlock(self.shoot)])), withKey: "shootAction")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0/100.0, target: self, selector: Selector("mainloop"), userInfo: nil, repeats: true)
    }
    
    func mainloop() {
        playTime++;
        
        backgroundLoop()
        
        if 0 == arc4random()%500 {
            // newRandomCloud()
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
        let x =  CGFloat (Int(arc4random())%Int(frame.size.width+cloud.frame.size.width))
        cloud.position = CGPointMake(x, frame.size.height+cloud.frame.size.height/2)
        
        let speed = Double (Int(arc4random())%Int(kCloudSpeedMax-kCloudSpeedMin)+kCloudSpeedMin)
        
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
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = CGPointMake(myPlaneNode.position.x, myPlaneNode.position.y+bullet.size.height+30)
        bullet.zPosition = 1
        bullet.setScale(0.8)
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody.allowsRotation = false
        bullet.physicsBody.categoryBitMask = kBulletMask
        bullet.physicsBody.contactTestBitMask = kEnemyPlaneMask
        bullet.physicsBody.collisionBitMask = kEnemyPlaneMask

        
        let action = SKAction.moveToY(self.frame.size.height + bullet.size.height, duration: bulletSpeed)
        let remove = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, remove]))
        
        addChild(bullet)
    }
    
    // Control the airplane
    override func didMoveToView(view: SKView!) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        view.addGestureRecognizer(panRecognizer)
    }
    
    func handlePanGesture(recognier: UIPanGestureRecognizer) {
        let translation = recognier.translationInView(self.view)
        var x = myPlaneNode.position.x + translation.x
        var y = myPlaneNode.position.y - translation.y
        
        x = fminf(fmaxf(x, myPlaneNode.frame.size.width/2), frame.size.width-myPlaneNode.frame.size.width/2)
        y = fminf(fmaxf(y, myPlaneNode.frame.size.width/2), frame.size.height-myPlaneNode.frame.size.width/2)
        
        myPlaneNode.position = CGPointMake(x, y)
        
        recognier.setTranslation(CGPointMake(0.0, 0.0), inView: self.view)
    }
    
}
































