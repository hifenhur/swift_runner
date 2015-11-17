//
//  GameScene.swift
//  RunnerSwift
//
//  Created by ben-hur batista oliveira on 15/11/15.
//  Copyright (c) 2015 ben-hur batista oliveira. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playButton = SKSpriteNode(imageNamed: "play")
    
    override func didMoveToView(view: SKView) {
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(playButton)
        self.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.5, alpha: 1)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == playButton{
                let scene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                scene.parentView = self
                skView.presentScene(scene)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
    
   
    
    
    
    
    
}
