import Foundation
import SpriteKit

let kBackgroundMusicName = "awesomeness"
let kBackgroundMusicExtension = "ogg"
let kSoundState = "kSoundState"
let kNoAdsState = "kNoAdsState"
let kScore = "kScore"
let kBestScore = "kBestScore"
let kMusicVolume = "kMusicVolume"

enum SoundFileName: String {
  case TapFile = "Tap.wav"
}

class PlayerStats {
  
  private init() {}
  static let shared = PlayerStats()
  
  func setScore(_ value: Int) {
    
    if value > getBestScore() {
      setBestScore(value)
    }
    
    UserDefaults.standard.set(value, forKey: kScore)
    UserDefaults.standard.synchronize()
  }
  
  func getScore() -> Int {
    return UserDefaults.standard.integer(forKey: kScore)
  }
  
  func setBestScore(_ value: Int) {
    UserDefaults.standard.set(value, forKey: kBestScore)
    UserDefaults.standard.synchronize()
  }
  
  func getBestScore() -> Int {
    return UserDefaults.standard.integer(forKey: kBestScore)
  }
  
  func setSounds(_ state: Bool) {
    UserDefaults.standard.set(state, forKey: kSoundState)
    UserDefaults.standard.synchronize()
  }
  
  func getSound() -> Bool {
    return UserDefaults.standard.bool(forKey: kSoundState)
  }
  
  func setNoAds(_ state: Bool) {
    UserDefaults.standard.set(state, forKey: kNoAdsState)
    UserDefaults.standard.synchronize()
  }
  
  func getNoAds() -> Bool {
    return UserDefaults.standard.bool(forKey: kNoAdsState)
  }
  
  func saveMusicVolume(_ value: Float) {
    UserDefaults.standard.set(value, forKey: kMusicVolume)
    UserDefaults.standard.synchronize()
  }
  
  func getMusicVolume() -> Float {
    return UserDefaults.standard.float(forKey: kMusicVolume)
  }
  
}
