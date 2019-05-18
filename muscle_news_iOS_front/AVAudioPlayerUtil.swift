//
//  ReadingSound.swift
//  muscle_news_iOS_front
//
//  Created by admin on 2019/05/18.
//  Copyright © 2019 admin. All rights reserved.
//

import AVFoundation

struct AVAudioPlayerUtil {
    
    static var audioPlayer:AVAudioPlayer = AVAudioPlayer();
    static var sound_url:String = "";
    
    static func setValue(url:String){
        self.sound_url = url;
        do {
            let sound_data = try Data(contentsOf: URL(string: self.sound_url)!)
            self.audioPlayer = try AVAudioPlayer(data: sound_data);
        } catch {
            return;
        }
        self.audioPlayer.prepareToPlay();
    }
    static func play(){
        self.audioPlayer.play();
    }
    
    static func pause() {
        self.audioPlayer.pause();
    }
    
    static func stop() {
        self.audioPlayer.stop();
    }
}
