import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    lazy var componentSystems: [GKComponentSystem] = {
        let gardenerSystem = GKComponentSystem(componentClass: GardenerComponent.self)
        let enemySystem = GKComponentSystem(componentClass: EnemyAgentComponent.self)
        let fallingSystem = GKComponentSystem(componentClass: FallingItemComponent.self)
        return [gardenerSystem, enemySystem, fallingSystem]
    }()
    // 1
    var entities = Set<GKEntity>()
    let scene: SKScene
    var toRemove = Set<GKEntity>()
    
    // 2
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func entities(for team: Team) -> [GKEntity] {
        return entities.compactMap{ entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
    }
    
    
    
    // 3
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        
        
    }
    
    // 4
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
        
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        // 1
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        // 2
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }
    
    
    func gardener(for team: Team) -> GKEntity? {
        for entity in entities {
            if let teamComponent = entity.component(ofType: TeamComponent.self),
               let _ = entity.component(ofType: GardenerComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
        }
        return nil
    }
    

    
}
