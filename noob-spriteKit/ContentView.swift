//
//  ContentView.swift
//  noob-spriteKit
//
//  Created by Despo on 27.06.25.
//

import SwiftUI
import SpriteKit


struct ContentView: View {
  @StateObject private var vm = ShooterScene()
  let width = UIScreen.main.bounds.width
  let height = UIScreen.main.bounds.height
  
  var scene: SKScene {
    let scene = ShooterScene()
    scene.size.width = width
    scene.size.height = height
    scene.scaleMode = .fill
    
    return scene
  }
  
  var body: some View {
    VStack {
      
      SpriteView(scene: scene)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
  }
}

#Preview {
  ContentView()
}


struct PhysicsCategory {
  static let enemy: UInt32 = 1
  static let bullet: UInt32 = 2
  static let square: UInt32 = 4
}

import Combine
final class ShooterScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
  let square = SKSpriteNode()
  let scoreLabel = SKLabelNode()
  let gameOverLabel = SKLabelNode()
  var score = 0
  
  let screenWidth: CGFloat = UIScreen.main.bounds.width
  let screenHeight: CGFloat = UIScreen.main.bounds.height
  
  override func didMove(to view: SKView) {
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
    self.physicsWorld.contactDelegate = self
    
    createSquareSprite()
    spawnEnemy()
    setupScore()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let newLocation = touch.location(in: self)
      
      let move = SKAction.move(to: CGPoint(x: newLocation.x, y: square.position.y), duration: 0.1)
      
      square.run(move)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if square.parent != nil {
      shootBullets()
    }
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodeAtPoint = atPoint(location)
    if nodeAtPoint.name == "restartButton" {
      restartGame()
      return
    }
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let collisionObject = contact.bodyA.categoryBitMask == PhysicsCategory.bullet ? contact.bodyB : contact.bodyA
    
    if collisionObject.categoryBitMask == PhysicsCategory.enemy {
      score += 1
      scoreLabel.text = "Score: \(score)"
      contact.bodyA.node?.removeFromParent()
      contact.bodyB.node?.removeFromParent()
    }
    
    let collisionSquare = contact.bodyA.categoryBitMask == PhysicsCategory.square ? contact.bodyA : contact.bodyB
    
    if collisionSquare.categoryBitMask == PhysicsCategory.square {
      contact.bodyA.node?.removeFromParent()
      contact.bodyB.node?.removeFromParent()
      removeAction(forKey: "spawnEnemy")
      gameOver()
    }
  }
  
  func createSquareSprite() {
    square.name = "ship"
    square.size = CGSize(width: 40, height: 40)
    square.color = .green
    square.position = CGPoint(x: screenWidth / 2, y: CGFloat(UIScreen.main.bounds.minY + 40))
    
    square.physicsBody = SKPhysicsBody(rectangleOf: square.frame.size)
    square.physicsBody?.isDynamic = false
    square.physicsBody?.affectedByGravity = false
    square.physicsBody?.usesPreciseCollisionDetection = true
    square.physicsBody?.categoryBitMask = PhysicsCategory.square
    square.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    
    addChild(square)
  }
  
  func shootBullets() {
    let bullet = SKShapeNode(circleOfRadius: 10)
    bullet.name = "bullet"
    bullet.fillColor = .red
    bullet.strokeColor = .yellow
    bullet.position = CGPoint(x: square.position.x, y: square.position.y + 20)
    
    bullet.physicsBody = SKPhysicsBody(circleOfRadius: 10)
    bullet.physicsBody?.isDynamic = true
    bullet.physicsBody?.affectedByGravity = false
    bullet.physicsBody?.usesPreciseCollisionDetection = true
    bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
    bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    
    let bulletMove = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 0.5)
    let removeBullet = SKAction.removeFromParent()
    
    let sequence = SKAction.sequence([bulletMove, removeBullet])
    
    bullet.run(sequence)
    
    addChild(bullet)
  }
  
  func generateEnemies() {
    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    let randomX = CGFloat.random(in: minX...maxX)
    
    let enemy = SKSpriteNode()
    
    enemy.size = CGSize(width: 30, height: 30)
    enemy.color = .blue
    enemy.position = CGPoint(x: randomX, y: UIScreen.main.bounds.maxY - 20)
    enemy.name = "enemy"
    
    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
    enemy.physicsBody?.isDynamic = true
    enemy.physicsBody?.usesPreciseCollisionDetection = true
    enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.bullet | PhysicsCategory.square
    
    let move = SKAction.move(by: CGVector(dx: 0, dy: -800), duration: 3)
    let remove = SKAction.removeFromParent()
    let sequence = SKAction.sequence([move, remove])
    
    enemy.run(sequence)
    
    addChild(enemy)
    
    //        removeAction(forKey: "spawningEnemies")
  }
  
  func spawnEnemy() {
    let spawn = SKAction.run { [weak self] in
      self?.generateEnemies()
    }
    
    let wait = SKAction.wait(forDuration: 1)
    let sequence = SKAction.sequence([spawn, wait])
    let repeatForever = SKAction.repeatForever(sequence)
    
    run(repeatForever, withKey: "spawnEnemy")
  }
  
  func setupScore() {
    scoreLabel.text = "Score: \(score)"
    scoreLabel.fontColor = .yellow
    scoreLabel.fontName = "Helvetica-Bold"
    scoreLabel.fontSize = 20
    scoreLabel.position = CGPoint(x: UIScreen.main.bounds.maxX - 70, y: UIScreen.main.bounds.maxY - 60)
    
    addChild(scoreLabel)
  }
  
  func gameOver() {
    gameOverLabel.fontColor = .red
    gameOverLabel.fontName = "Helvetica-Bold"
    gameOverLabel.fontSize = 30
    gameOverLabel.text = "Game Over"
    gameOverLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
    
    addChild(gameOverLabel)
    
    showRestartButton()
  }
  
  func restartGame() {
    removeAllChildren()
    removeAllActions()
    
    createSquareSprite()
    spawnEnemy()
    setupScore()
  }
  
  func showRestartButton() {
    let restartButton = SKLabelNode(text: "Restart")
    restartButton.name = "restartButton"
    restartButton.fontSize = 30
    restartButton.fontColor = .white
    restartButton.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 - 40)
    
    addChild(restartButton)
  }
}

