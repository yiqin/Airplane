//
//  YQViewController.swift
//  Airplane
//
//  Created by yiqin on 7/13/14.
//  Copyright (c) 2014 yipick. All rights reserved.
//

import UIKit
import SpriteKit


class YQViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure the view
        let skView = SKView(frame: self.view.frame)
        self.view.addSubview(skView)
        
        // No color show...
        skView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        var scene = YQMainScene.sceneWithSize(skView.bounds.size)
        
        // Configure the scene
        scene.scaleMode = .AspectFill
        
        // Present the scene
        skView.presentScene(scene)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

