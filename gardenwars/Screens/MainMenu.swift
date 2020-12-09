import SpriteKit

class MainMenu: SKScene {
    let logo = SKSpriteNode(imageNamed: "image/logo")
    var menuPhase = 1
    
    var landingSection = SKNode()
    var chooseCharacter = SKNode()
    var chooseDifficulty = SKNode()
    
    private var chosenPlayerLeftFrames: [SKTexture] = []
    private var chosenPlayerRightFrames: [SKTexture] = []
    private var chosenPlayerStillFrame: SKTexture?
    
    override func didMove(to view: SKView) {
//        let background = SKSpriteNode(imageNamed: "image/sky")
//
//        background.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
//        background.size = self.frame.size
//        background.zPosition = 1
        logo.zPosition = 100
        logo.scale(to: CGSize(width: 325, height: 200))
        logo.position = CGPoint(x: ScreenSize.width / 3, y: ScreenSize.height / 2)
//        addChild(background)
//        landingSection.addChild(background)
        landingSection.addChild(logo)
//
//        let startLabel = SKLabelNode(fontNamed: systemFont)
//        startLabel.text = "Play"
//        startLabel.zPosition = 6
//        startLabel.fontSize = 18
//        startLabel.fontColor = UIColor.green
//        startLabel.alpha = 1
//        let startButton = SKSpriteNode(color: .white, size: CGSize(width: 200, height: 50))
//        startButton.position = CGPoint(x: ScreenSize.width / 3, y: ScreenSize.height / 2 - 100)
//        startLabel.position = startButton.position
//
//        startLabel.verticalAlignmentMode = .center
//        startLabel.horizontalAlignmentMode = .center
        
//        let button = SKButton(normalTexture: <#T##SKTexture!#>, selectedTexture: <#T##SKTexture!#>, disabledTexture: <#T##SKTexture?#>)
        
//        landingSection.addChild(startLabel)
//        landingSection.addChild(startButton)
        addChild(landingSection)
        
        let chooseLabel = SKLabelNode(fontNamed: systemFont)
        chooseLabel.text = "Choose your gardener"
        chooseLabel.fontSize = 16
        chooseLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.8)
        chooseCharacter.addChild(chooseLabel)
        let parker = SKSpriteNode(imageNamed: "image/parker5")
        let enemy = SKSpriteNode(imageNamed: "image/enemy5")
        let darla = SKSpriteNode(imageNamed: "image/darla5")
        chooseCharacter.addChild(parker)
        parker.position = CGPoint(x: ScreenSize.width * 0.25, y: ScreenSize.height * 0.4)
        parker.name = "parker"
        chooseCharacter.addChild(enemy)
        enemy.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.4)
        enemy.name = "enemy"
        chooseCharacter.addChild(darla)
        darla.position = CGPoint(x: ScreenSize.width * 0.75, y: ScreenSize.height * 0.4)
        darla.name = "darla"
        addChild(chooseCharacter)
        
        chooseCharacter.position = CGPoint(x: 0, y: -500)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        let chooseDifficultyLabel = SKLabelNode(fontNamed: systemFont)
        chooseDifficultyLabel.text = "Choose difficulty"
        chooseDifficultyLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.8)
        
        let easyLabel = SKLabelNode(fontNamed: systemFont)
        easyLabel.text = "Easy"
        easyLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.4)
        easyLabel.fontSize = 26
        easyLabel.name = "easy"
        let hardLabel = SKLabelNode(fontNamed: systemFont)
        hardLabel.text = "Hard"
        hardLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.2)
        hardLabel.fontSize = 26
        hardLabel.name = "hard"
        chooseDifficulty.addChild(chooseDifficultyLabel)
        chooseDifficulty.addChild(easyLabel)
        chooseDifficulty.addChild(hardLabel)
        chooseDifficulty.position = CGPoint(x: 0, y: -500)
        addChild(chooseDifficulty)
    }
    
    func showChooseCharacter() {
        landingSection.run(SKAction.move(by: CGVector(dx: 0, dy: 500), duration: 0.1))
        chooseCharacter.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1))
        
        //        self.removeAllChildren()
        
        menuPhase = 2
        
    }
    
    func showChooseDifficulty() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            self.chooseCharacter.run(SKAction.move(by: CGVector(dx: 0, dy: 500), duration: 0.1))
            self.chooseDifficulty.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1))
        }
        
    }
    
    func choosePlayerAnimation(player: String) {
        let chosenPlayerAnimatedAtlas = SKTextureAtlas(named: player)
        var leftFrames: [SKTexture] = []
        var rightFrames: [SKTexture] = []
        for i in 2...4 {
            let chosenPlayerTextureName = "\(player)\(i)"
            leftFrames.append(chosenPlayerAnimatedAtlas.textureNamed(chosenPlayerTextureName))
        }
        for i in 6...8 {
            let chosenPlayerTextureName = "\(player)\(i)"
            rightFrames.append(chosenPlayerAnimatedAtlas.textureNamed(chosenPlayerTextureName))
        }
        chosenPlayerStillFrame = chosenPlayerAnimatedAtlas.textureNamed("\(player)5")
        chosenPlayerLeftFrames = leftFrames
        chosenPlayerRightFrames = rightFrames
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "parker" {
                    choosePlayerAnimation(player: "parker")
                    chosenCharacter = "parker"
                    enemyCharacter = "enemy"
                    walkAnimation(node)
                    showChooseDifficulty()
                }
                if node.name == "enemy" {
                    choosePlayerAnimation(player: "enemy")
                    enemyCharacter = "darla"
                    chosenCharacter = "enemy"
                    walkAnimation(node)
                    showChooseDifficulty()
                    
                }
                if node.name == "darla" {
                    choosePlayerAnimation(player: "darla")
                    chosenCharacter = "darla"
                    enemyCharacter = "parker"
                    walkAnimation(node)
                    showChooseDifficulty()
                }
                
                if node.name == "easy" {
                    enemyPredictionTime = 25
                    enemyTopSpeed = 1500
                    startGamePlay()
                }
                if node.name == "hard" {
                    enemyPredictionTime = 1
                    enemyTopSpeed = 3000
                    startGamePlay()
                }
            }
            
        }
    }
    
    func walkAnimation(_ node: SKNode) {
        node.run(SKAction.repeat(
            SKAction.animate(
                with: chosenPlayerRightFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: true
            ), count: 2
        ), withKey: "WALK_LEFT")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if menuPhase == 1 {
            showChooseCharacter()
        }
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                
                if menuPhase == 2 {
                    //                    showChooseDifficulty()
                    
                    //                    if node.name == "parker" {
                    //                        choosePlayerAnimation(player: "parker")
                    //                        chosenCharacter = "parker"
                    //                        enemyCharacter = "enemy"
                    //                        node.run(SKAction.repeat(
                    //                            SKAction.animate(
                    //                                with: chosenPlayerRightFrames,
                    //                                timePerFrame: 0.05,
                    //                                resize: false,
                    //                                restore: true
                    //                            ), count: 2
                    //                        ), withKey: "WALK_LEFT")
                    //                        showChooseDifficulty()
                    //        //                    startGamePlay()
                    //                    }
                    //                    if node.name == "enemy" {
                    ////                        choosePlayerAnimation(player: "enemy")
                    ////                        enemyCharacter = "darla"
                    ////                        chosenCharacter = "enemy"
                    ////                        node.run(SKAction.repeat(
                    ////                            SKAction.animate(
                    ////                                with: chosenPlayerRightFrames,
                    ////                                timePerFrame: 0.05,
                    ////                                resize: false,
                    ////                                restore: true
                    ////                            ), count: 2
                    ////                        ), withKey: "WALK_LEFT")
                    //                        showChooseDifficulty()
                    //
                    //        //                    startGamePlay()
                    //                    }
                    //                    if node.name == "darla" {
                    ////                        choosePlayerAnimation(player: "darla")
                    ////                        chosenCharacter = "darla"
                    ////                        enemyCharacter = "parker"
                    ////                        node.run(SKAction.repeat(
                    ////                            SKAction.animate(
                    ////                                with: chosenPlayerRightFrames,
                    ////                                timePerFrame: 0.05,
                    ////                                resize: false,
                    ////                                restore: true
                    ////                            ), count: 2
                    ////                        ), withKey: "WALK_LEFT")
                    //                        showChooseDifficulty()
                    //
                    //        //                    startGamePlay()
                    //                    }
                }
                
            }
        }
        
    }
    
    
    func setupNodes() {
        
    }
    
    
    func addNodes() {
        
    }
    
    
    @objc func startGamePlayNotification(_ info:Notification) {
        startGamePlay()
    }
    
    
    func startGamePlay() {
        currentLevel = 1
        GameManager.shared.transition(self, toScene: .Gameplay, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 1))
    }
}
