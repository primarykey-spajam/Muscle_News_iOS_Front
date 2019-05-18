//
//  TrainingJudgement.swift
//  muscle_news_iOS_front
//
//  Created by 助永悠輝 on 2019/05/18.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit

class TrainingJudgement {
    let myDevice: UIDevice = UIDevice.current
    var muscleMenu: String
    var stateArray: [Bool]
    var startGymVC: StartGymViewController
    //var readingSound: ReadingSound

    init(muscleMenu: String, gymVC: StartGymViewController) {
        //近接センサーを有効にする
        myDevice.isProximityMonitoringEnabled = true
        self.muscleMenu = muscleMenu
        self.stateArray = []
        self.startGymVC = gymVC
        //self.readingSound = ReadingSound()
        // 0.5秒ごとにstartTimer()を呼ぶタイマー
        //var timer: Timer!
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.checkMenuState), userInfo: nil, repeats: true)
        NotificationCenter.default
            .addObserver(
                self,
                selector: Selector(("proximitySensorStateDidChange")),
                name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"),
                object: nil
        )
        //近接センサーを通知する
        NotificationCenter.default
            .post(
                name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"),
                object: nil
        )
    }
    
    //近接センサーの値が変更されたら呼ばれる関数
    // 呼び出されない時間が一定になったら筋トレしていないと扱う
    //schejuledtimer
    func isSameValueArray(array: Array<Bool>) -> Bool {
        let orderedSet: NSOrderedSet = NSOrderedSet(array: self.stateArray)
        // 再度Arrayに戻す
        self.stateArray = orderedSet.array as! [Bool]
        if(self.stateArray.count <= 1) {
            return true
        } else {
            return false
        }
    }
    
    @objc func checkMenuState(){
        print(self.stateArray)
        if(isSameValueArray(array: stateArray)) {
            //音楽とめる
            print("サボり")
            startGymVC.testLabel.text = "サボり"
            //readingSound.stopNews()
            
        } else {
            //音楽止まってたら、1再生
            print("サボってない")
            startGymVC.testLabel.text = "サボってない"
            //readingSound.playNews()
        }
        self.stateArray = []
    }
    @objc func proximitySensorStateDidChange(){
        //timer管理
        if myDevice.proximityState == true {
            //近づいた時
            print("近い")
            
            self.stateArray.append(true)
        }else{
            //離れた時
            print("遠い")
            self.stateArray.append(false)
        }
    }
}
