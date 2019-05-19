//
//  SquatViewController.swift
//  muscle_news_iOS_front
//
//  Created by 助永悠輝 on 2019/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreMotion

class SquatViewController: UIViewController {
    // MotionManager
    var acceleX: Double = 0
    var acceleY: Double = 0
    var acceleZ: Double = 0
    var total:Double = 0
    let Alpha = 0.4
    var flg: Bool = false
    let motionManager = CMMotionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        if motionManager.isAccelerometerAvailable {
            // intervalの設定 [sec]
            motionManager.accelerometerUpdateInterval = 0.2
            
            // センサー値の取得開始
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
            
        }
        // Do any additional setup after loading the view.
    }
    func outputAccelData(acceleration: CMAcceleration){
        // 加速度センサー [G]
        print(String(format: "%06f", acceleration.x))
        print(String(format: "%06f", acceleration.y))
        print(String(format: "%06f", acceleration.z))
    }
    
    // センサー取得を止める場合
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func highpassFilter(acceleration: CMAcceleration){
        
        acceleX = Alpha * acceleration.x + acceleX * (1.0 - Alpha);
        acceleY = Alpha * acceleration.y + acceleY * (1.0 - Alpha);
        acceleZ = Alpha * acceleration.z + acceleZ * (1.0 - Alpha);
        
        let xh = acceleration.x - acceleX
        let yh = acceleration.y - acceleY
        let zh = acceleration.z - acceleZ
        
        print(String(format: "%06f", xh))
        print(String(format: "%06f", yh))
        print(String(format: "%06f", zh))
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
