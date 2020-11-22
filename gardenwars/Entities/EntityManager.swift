import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    lazy var componentSystems: [GKComponentSystem] = {
      let gardenerSystem = GKComponentSystem(componentClass: GardenerComponent.self)
      return [gardenerSystem]
    }()
    // 1
    var entities = Set<GKEntity>()
    let scene: SKScene
    var toRemove = Set<GKEntity>()

  // 2
  init(scene: SKScene) {
    self.scene = scene
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
