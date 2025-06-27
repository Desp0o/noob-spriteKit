//
//  GameScene.swift
//  noob-spriteKit
//
//  Created by Despo on 27.06.25.
//

import SpriteKit

final class GaameScene: SKScene {
  let square = SKSpriteNode()
  
  override func didMove(to view: SKView) {
    self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.8)
    
    square.size = CGSize(width: 20, height: 20)
    square.color = .systemPink
    square.position = CGPoint(x: 100, y: 400)
    
    square.physicsBody = SKPhysicsBody(rectangleOf: square.size)
    square.physicsBody?.isDynamic = true
    square.physicsBody?.affectedByGravity = true
    
    addChild(square)
    createPlatform()
    
  }
  
  func createPlatform() {
    let platform = SKSpriteNode()
    platform.size = CGSize(width: UIScreen.main.bounds.width, height: 20)
    platform.position = CGPoint(x: 200, y: 0)
    platform.color = .yellow
    
    platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
    platform.physicsBody?.isDynamic = false
    platform.physicsBody?.affectedByGravity = false
    addChild(platform)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let newSprite = SKSpriteNode()
      newSprite.size = CGSize(width: 50, height: 50)
      newSprite.color = .systemMint
      newSprite.position = touch.location(in: self)
      
      newSprite.physicsBody = SKPhysicsBody(rectangleOf: newSprite.size)
      newSprite.physicsBody?.isDynamic = true
      newSprite.physicsBody?.affectedByGravity = true
      
      addChild(newSprite)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let positinon = touch.location(in: self)
      
      let move = SKAction.move(to: positinon, duration: 0.5)
      square.run(move)
    }
  }
}
