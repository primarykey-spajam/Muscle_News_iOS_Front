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

    init(muscleMenu: String) {
        //近接センサーを有効にする
        myDevice.isProximityMonitoringEnabled = true
        self.muscleMenu = muscleMenu
        //近接センサーの通知設定
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
    @objc func proximitySensorStateDidChange() -> Bool{
        if myDevice.proximityState == true {
            //近づいた時
            print("近い")
            return true
        }else{
            //離れた時
            print("遠い")
            return false
        }
    }
}
