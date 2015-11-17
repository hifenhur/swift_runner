//
//  PlayScene.swift
//  RunnerSwift
//
//  Created by ben-hur batista oliveira on 16/11/15.
//  Copyright © 2015 ben-hur batista oliveira. All rights reserved.
//

import SpriteKit

class PlayScene : GameScene, SKPhysicsContactDelegate{
    
    //ground
    var parentView = SKScene()
    let runningBar = SKSpriteNode(imageNamed: "bar")
    var originRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var groundSpeed = 5
    var onGround = true
    var velocityY = CGFloat(0)
    var gravity = CGFloat(0.6)
    var initialTime = NSDate(timeIntervalSinceNow: 0.0)
    var nextSquareTime = Double(0)
    var nextRectangleTime = Double(0)
    var score = 0
    
    var pointableSquare = true
    var pointableRect = true
    
    enum heroContactCategories: UInt32{
        case none = 0
        case block = 2
        
    }
    
    //hero
    let hero = SKSpriteNode(imageNamed: "hero")
    var heroBaseLine = CGFloat(0)
    
    //squares
    let square = SKSpriteNode(imageNamed: "square")
    var squareBaseLine = CGFloat(0)
    
    let rectangle = SKSpriteNode(imageNamed: "rectangle")
    var rectangleBaseLine = CGFloat(0)
    
    //score
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")

    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        print("we are in the new scene now!")
        
        self.backgroundColor = UIColor(red: 0.1, green: 0.5, blue: 0.6, alpha: 1)
        
        self.runningBar.anchorPoint = CGPointMake(0, 0.5)
        self.runningBar.position = CGPointMake(
            CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.runningBar.size.height / 2))
        
        maxBarX = runningBar.size.width - self.frame.width
        maxBarX *= -1
        
        heroBaseLine = runningBar.position.y + (runningBar.size.height / 2) + (hero.size.height / 2)
        
        hero.position = CGPointMake(hero.size.width, heroBaseLine)
        
        hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(hero.size.width / 2))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.collisionBitMask = 1
        hero.physicsBody?.contactTestBitMask = heroContactCategories.block.rawValue
        
        square.physicsBody = SKPhysicsBody(rectangleOfSize: square.size)
        square.physicsBody?.affectedByGravity = false
        square.physicsBody?.dynamic = false
        square.physicsBody?.collisionBitMask = 2
        
        rectangle.physicsBody = SKPhysicsBody(rectangleOfSize: rectangle.size)
        rectangle.physicsBody?.affectedByGravity = false
        rectangle.physicsBody?.dynamic = false
        rectangle.physicsBody?.collisionBitMask = 2
        
        
        
        // squares
        squareBaseLine = runningBar.position.y + (runningBar.size.height / 2) + (square.size.height / 2)
        
        square.position = CGPointMake(self.size.width, squareBaseLine)
        
        
        rectangleBaseLine = runningBar.position.y + (runningBar.size.height / 2) + (rectangle.size.height / 2)
        
        rectangle.position = CGPointMake(self.size.width, rectangleBaseLine)
        
        //scoreLabel
        self.scoreLabel.fontSize = 44
        self.scoreLabel.text = "\(score)"
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
            CGRectGetMaxY(self.frame) - 44)

        
        self.addChild(runningBar)
        self.addChild(square)
        self.addChild(rectangle)
        self.addChild(hero)
        self.addChild(scoreLabel)
        
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        if(runningBar.position.x <= maxBarX){
            runningBar.position.x = originRunningBarPositionX
        }
        let degreeRotation = CDouble(groundSpeed) * M_PI / 180
        
        self.hero.zRotation -= CGFloat(degreeRotation)
        runningBar.position.x -= CGFloat(groundSpeed)
        
        self.square.position.x -= CGFloat(groundSpeed)
        self.rectangle.position.x -= CGFloat(groundSpeed)
        
        self.velocityY += gravity
        self.hero.position.y -= velocityY

        
        if(hero.position.y < heroBaseLine){
            self.hero.position.y = heroBaseLine
            velocityY = 0.0
            onGround = true
        }
        
        putBlock()
        updateScore()
        
        self.scoreLabel.text = "\(score)"
        

        
    }
    
    func makeItHarder(){
        self.groundSpeed += 1
    }
    
    func updateScore(){

        if(pointableRect && (hero.position.x > rectangle.position.x)){
            score += 1
            pointableRect = false
            makeItHarder()
        }
        
        if(pointableSquare && (hero.position.x > square.position.x)){
            score += 1
            pointableSquare = false
            makeItHarder()
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(onGround){
            self.velocityY -= 18.0
            self.onGround = false
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if velocityY < -9{
            velocityY = -9
        }
        
    }
    
    func putBlock(){
        let timeElapsed = Double(NSDate(timeIntervalSinceNow: 0.0).timeIntervalSinceDate(initialTime))

        
        if nextSquareTime <= timeElapsed{
            nextSquareTime = Double(Double(arc4random_uniform(500-200)) / 100.0 + 2) + timeElapsed
            square.position = CGPointMake(self.size.width + (square.size.width / 2), squareBaseLine)
            pointableSquare = true
        }
        
        if nextRectangleTime <= timeElapsed{
            nextRectangleTime = Double(Double(arc4random_uniform(500-200)) / 100.0 + 2) + timeElapsed
            rectangle.position = CGPointMake(self.size.width + (square.size.width / 2), rectangleBaseLine)
            pointableRect = true
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("colidiu")
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.0)
        
        let nextScene = PlayScene(size: self.scene!.size)
        nextScene.scaleMode = SKSceneScaleMode.AspectFill
        
        self.scene!.view!.presentScene(nextScene, transition: transition)
    }
    
    
    
    
}
