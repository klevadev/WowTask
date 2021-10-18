//
//  SoundPlayer.swift
//  WowTask
//
//  Created by Lev Kolesnikov on 18.10.2021.
//

import Foundation
import AVFoundation

enum Sound: String {
    case ding = "sound-ding"
    case rise = "sound-rise"
    case tap = "sound-tap"
}

class TaskAudioPlayer {
    static let shared = TaskAudioPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init () {}
    
    func playSound(sound: String, type: String = "mp3") {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch let error {
                print("Файл звука не был найден, ошибка \(error.localizedDescription)")
            }
        }
    }
}
