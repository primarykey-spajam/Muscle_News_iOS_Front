//
//  StartGymViewController.swift
//  muscle_news_iOS_front
//
//  Created by admin on 2019/05/18.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class StartGymViewController: UIViewController {

    var train:TrainingJudgement? = nil
    lazy var indicatorView = createSaveIndicatorView()
    var category = "野球"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //text1に値がはいる
        train = TrainingJudgement(muscleMenu: "pushup", gymVC: self)
        callApi(category: CurrentCategor.getCategory())
        self.view.addSubview(indicatorView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        train?.destroy()
    }
    
    func callApi(category: String) {
        Alamofire.request("https://spajam2019-muscle.herokuapp.com/news", method: .get, parameters: ["category": category]).responseJSON { (response) -> Void in
            //print(response)
            let swiftyJsonVar = JSON(response.result.value!)
            let str = swiftyJsonVar["ResultSet"]
            self.train?.setUpAudio(url: str.string!)
            self.indicatorView.removeFromSuperview()
        }
    }
    
    func createSaveIndicatorView() -> UIView {
        
        let indicatorView = UIView.init(frame: CGRect.init(x: (self.view.bounds.width - 200) / 2, y: (self.view.bounds.height - 200) / 2, width: 200, height: 200))
        indicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.center = CGPoint(x: indicatorView.bounds.width / 2, y: indicatorView.bounds.height / 2 )
        indicator.color = UIColor.white
        indicator.hidesWhenStopped = true
        indicatorView.addSubview(indicator)
        indicatorView.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        let waitLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: indicatorView.bounds.width, height: indicatorView.bounds.height))
        waitLabel.numberOfLines = 2
        waitLabel.font = UIFont.systemFont(ofSize: 14)
        waitLabel.textColor = UIColor.white
        waitLabel.layer.position = CGPoint(x: waitLabel.bounds.width / 2, y: indicatorView.bounds.height - 30)
        waitLabel.textAlignment = NSTextAlignment.center
        indicatorView.addSubview(waitLabel)
        
        return indicatorView
    }
    
    @IBOutlet weak var testLabel: UILabel!
    var text1: String?
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
