import SpriteKit

class MainMenu: SKScene {
    let logo = SKSpriteNode(imageNamed: "image/logo")
    var menuPhase = 1
    
    let pseudoScreenSize = 1.5 * ScreenSize.height
    
    let titlePosition = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2 + (ScreenSize.height / 6))
    let bodyPosition = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2 - 100)
    
    let settingsMenu = PauseScreenOverlay()

    var settingsMenuOpened = false
    var landingSection = SKNode()
    var chooseCharacter = SKNode()
    var chooseDifficulty = SKNode()
    
    let playerNames = ["parker", "enemy", "flowergirl", "darla", "michelle"]
    
    private var chosenPlayerLeftFrames: [SKTexture] = []
    private var chosenPlayerRightFrames: [SKTexture] = []
    private var chosenPlayerStillFrame: SKTexture?
    
    override func didMove(to view: SKView) {
        settingsMenu.exitLabel.removeFromParent()

        let settingsNode = SKSpriteNode(imageNamed: "image/settings")
        settingsNode.position = CGPoint(x: ScreenSize.width - 50, y: ScreenSize.height - 50)
        settingsNode.scale(to: CGSize(width: 25, height: 25))
        settingsNode.name = "settings"
        addChild(settingsNode)
        
        logo.zPosition = 100
        logo.scale(to: CGSize(width: 325, height: 200))
        logo.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2 + (ScreenSize.height / 8))
        
        landingSection.addChild(logo)
        let startLabel = SKLabelNode(fontNamed: systemFont)
        startLabel.text = "Tap the screen to begin"
        startLabel.zPosition = 6
        startLabel.fontSize = 18
        startLabel.fontColor = UIColor.white
        startLabel.alpha = 1
        startLabel.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2 - 100)
        
        landingSection.addChild(startLabel)
        addChild(landingSection)
        
        let chooseLabel = SKLabelNode(fontNamed: systemFont)
        chooseLabel.text = "Choose your gardener"
        chooseLabel.fontSize = 16
        chooseLabel.position = titlePosition
        chooseCharacter.addChild(chooseLabel)
        let parker = SKSpriteNode(imageNamed: "image/parker5")
        let enemy = SKSpriteNode(imageNamed: "image/enemy5")
        let darla = SKSpriteNode(imageNamed: "image/darla5")
        let michelle = SKSpriteNode(imageNamed: "image/michelle5")
        let flowerGirl = SKSpriteNode(imageNamed: "image/flowergirl5")
        
        chooseCharacter.addChild(parker)
        parker.position = CGPoint(x: ScreenSize.width * 0.125, y: ScreenSize.height * 0.4)
        parker.name = playerNames[0]
        
        chooseCharacter.addChild(enemy)
        enemy.position = CGPoint(x: ScreenSize.width * 0.315, y: ScreenSize.height * 0.4)
        enemy.name = playerNames[1]
        
        chooseCharacter.addChild(flowerGirl)
        flowerGirl.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.4)
        flowerGirl.name = playerNames[2]
        
        chooseCharacter.addChild(darla)
        darla.position = CGPoint(x: ScreenSize.width * 0.685, y: ScreenSize.height * 0.4)
        darla.name = playerNames[3]
        
        chooseCharacter.addChild(michelle)
        michelle.position = CGPoint(x: ScreenSize.width * 0.875, y: ScreenSize.height * 0.4)
        michelle.name = playerNames[4]
        
        addChild(chooseCharacter)
        
        chooseCharacter.position = CGPoint(x: 0, y: -pseudoScreenSize)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        let chooseDifficultyLabel = SKLabelNode(fontNamed: systemFont)
        chooseDifficultyLabel.text = "Choose difficulty"
        chooseDifficultyLabel.position = titlePosition
        
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
        chooseDifficulty.position = CGPoint(x: 0, y: -pseudoScreenSize)
        addChild(chooseDifficulty)
    }
    
    func showChooseCharacter() {
        landingSection.run(SKAction.move(by: CGVector(dx: 0, dy: pseudoScreenSize), duration: 0.1))
        chooseCharacter.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1))
        menuPhase = 2
        
    }
    
    func showChooseDifficulty() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            self.chooseCharacter.run(SKAction.move(by: CGVector(dx: 0, dy: self.pseudoScreenSize), duration: 0.1))
            self.chooseDifficulty.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.1))
        }
        
    }
    
    func choosePlayerAndSetRandomEnemy(player: String) {
        chosenCharacter = player
        enemyCharacter = playerNames.filter({ $0 != chosenCharacter}).randomElement() ?? "parker"
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
                if settingsMenuOpened {
                    switch node.name {
                    case "close":
                        openSettingsMenu()
                        break
                    case "enableMusic":
                        backgroundMusicPlayer.volume = 0.25
                        musicVolume = 0.25
                        settingsMenu.musicLabel.text = "Disable music"
                        settingsMenu.musicLabel.name = "disableMusic"
    //                    musicVolume
                        break
                    case "disableMusic":
                        backgroundMusicPlayer.volume = 0.00
                        musicVolume = 0.00
                        settingsMenu.musicLabel.text = "Enable music"
                        settingsMenu.musicLabel.name = "enableMusic"
                        break
                    case "disableFx":
                        effectsEnabled = false
                        settingsMenu.soundEffectsLabel.text = "Enable sound effects"
                        settingsMenu.soundEffectsLabel.name = "enableFx"
                        break
                    case "enableFx":
                        effectsEnabled = true
                        settingsMenu.soundEffectsLabel.text = "Disable sound effects"
                        settingsMenu.soundEffectsLabel.name = "disableFx"
                        break
                    
                    case "exit":
                        GameManager.shared.transition(self.scene!, toScene: .MainMenu, transition:
                                                        SKTransition.fade(with: UIColor.black, duration: 1))
                    default:
                        return
                    }
                    return
                } else {
                    if node.name == "settings" {
                        openSettingsMenu()
                        break
                    }
                    if playerNames.contains(node.name ?? "") {
                        if settingsMenuOpened {return}
                        choosePlayerAnimation(player: node.name!)
                        choosePlayerAndSetRandomEnemy(player: node.name!)
                        walkAnimation(node)
                        showChooseDifficulty()
                        break
                    }
                    if node.name == "easy" {
                        enemyTopSpeed = 125
                        startGamePlay()
                    }
                    if node.name == "hard" {
                        enemyTopSpeed = 250
                        startGamePlay()
                    }
                }
        
                
        
            }
            
        }
    }
    
    func openSettingsMenu() -> Void {
        if settingsMenuOpened == true {
            settingsMenu.removeFromParent()
            settingsMenuOpened = false
        } else {
            addChild(settingsMenu)
            settingsMenuOpened = true
            settingsMenu.zPosition = 5000000
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
        if menuPhase == 1 && !settingsMenuOpened {
            showChooseCharacter()
        }
        
    }
    
    func startGamePlay() {
        currentLevel = 1
        GameManager.shared.transition(self, toScene: .Level1, transition:
                                        SKTransition.fade(with: UIColor.black, duration: 1))
    }
}
