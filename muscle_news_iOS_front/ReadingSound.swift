//
//  ReadingSound.swift
//  muscle_news_iOS_front
//
//  Created by admin on 2019/05/18.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation

class ReadingSound: UIViewController {

    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // mp3音声(SOUND.mp3)の再生
        playSound(name: "")
    }

}

extension ReadingSound: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        
        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
            
            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
}
