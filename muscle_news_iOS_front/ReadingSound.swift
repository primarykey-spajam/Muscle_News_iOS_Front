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
    @IBOutlet weak var testLabel: UILabel!
    var text1: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let TrainingJudgement =  TrainingJudgement_demo()
        
        if(TrainingJudgement.A(name: text1 as! String)) { playSound(name: "test") }
    }

}

extension ReadingSound: AVAudioPlayerDelegate {
    func playSound(name: String) {
        print(name)
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
        }
    }
}
