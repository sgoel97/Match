//
//  SoundManager.swift
//  Match
//
//  Created by Samarth Goel on 11/19/19.
//  Copyright © 2019 Samarth Goel. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager{
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect{
        case shuffle
        case flip
        case match
        case wrong
    }
    
    static func playSound(_ effect:SoundEffect){
        var soundFileName = ""
        
        switch effect {
            case .shuffle:
                soundFileName = "shuffle"
            case .flip:
                soundFileName = "cardflip"
            case .match:
                soundFileName = "dingcorrect"
            case .wrong:
                soundFileName = "dingwrong"
        }
        //get path to sound file within bundle
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else{
            print("couldn't find sound file \(soundFileName) in the bundle")
            return
        }
        //create URL object from string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
            //create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //play sound
            audioPlayer?.play()
        }
        catch{
            
        }
    }
}
