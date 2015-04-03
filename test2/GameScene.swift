//
//  GameScene.swift
//  test2
//
//  Created by 坂野健 on 2015/04/02.
//  Copyright (c) 2015年 坂野健. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate {
    let redCategory: UInt32 = 0x1 << 0
    let greenCategory: UInt32 = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 55;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        let redSquare = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(200, 30))
        redSquare.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: 50
        )
        redSquare.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(200, 30))
        redSquare.physicsBody?.affectedByGravity = false
        redSquare.physicsBody?.dynamic = false
        self.addChild(redSquare)
        
        
        let greenSquare = SKSpriteNode(imageNamed:"ufo")
        greenSquare.position = CGPoint(
            x: 250,
            y: 400
        )
        greenSquare.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(200, 100))
        greenSquare.physicsBody?.affectedByGravity = false
        greenSquare.physicsBody?.dynamic = false
        greenSquare.physicsBody?.categoryBitMask = redCategory
        greenSquare.physicsBody?.contactTestBitMask = greenCategory
        
        self.addChild(greenSquare)
        let moveA=SKAction.moveTo(CGPoint(x:250,y:400), duration: 6)
        let moveB=SKAction.moveTo(CGPoint(x:900,y:400), duration: 1)
        let moveSequens=SKAction.sequence([moveA,moveB])
        let moveRepeat=SKAction.repeatActionForever(moveSequens)
        greenSquare.runAction(moveRepeat)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )        /* Setup your scene here */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let name :[String]=["dog","cat","bird"]
            let ran = Int(arc4random_uniform(3));
            let sprite = SKSpriteNode(imageNamed:name[ran])
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            sprite.physicsBody=SKPhysicsBody(rectangleOfSize: CGSizeMake(30, 50))
            sprite.physicsBody?.affectedByGravity=true;
            sprite.physicsBody?.dynamic=true;
            sprite.physicsBody?.categoryBitMask = greenCategory
            sprite.physicsBody?.contactTestBitMask = redCategory
            self.addChild(sprite)
            let sound = SKAction.playSoundFileNamed(name[ran]+".mp3", waitForCompletion: false)
            self.runAction(sound)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    func didBeginContact(contact: SKPhysicsContact!) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        // firstを赤、secondを緑とする。
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 赤と緑が接したときの処理。
        if firstBody.categoryBitMask & redCategory != 0 &&
            secondBody.categoryBitMask & greenCategory != 0 {
                secondBody.node?.removeFromParent()
        }
    }
   }
