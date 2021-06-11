//
//  GameScene.swift
//  project17
//
//  Created by Ярослав on 4/14/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var label: SKLabelNode!
    
    var possibleEnemys = ["hammer","ball","tv"]
    var gameTimer: Timer?
    var isGameOver = false
    var speedLevel = 0.01 {
        didSet{
            if speedLevel > 10{
                speedLevel = 0.5
            }
        }
    }
    
    var enemyCounter = 0 {
        didSet{
            if enemyCounter > 10{
                speedLevel += 0.01
                enemyCounter = 0
            }
        }
    }
    var score = 0{
        didSet{
            label.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 300, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        label = SKLabelNode(fontNamed: "Chalkduster")
        label.position = CGPoint(x: 16, y: 16)
        label.horizontalAlignmentMode = .left
        addChild(label)
        
        score = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35 - speedLevel, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    
    @objc func createEnemy(){
        guard let enemy = possibleEnemys.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        enemyCounter += 1
        addChild(sprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children{
            if node.position.x < -300 {
                node.removeFromParent()
            }
            
            if !isGameOver {
                score += 1
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        }else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        
        
    }
}
