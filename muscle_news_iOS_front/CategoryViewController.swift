//
//  CategoryViewController.swift
//  muscle_news_iOS_front
//
//  Created by 助永悠輝 on 2019/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBAction func pushDisaster(_ sender: UIButton) {
        var image: UIImage
        if(sender.isSelected) {
            image = UIImage(named: "off")!
        } else {
            image = UIImage(named: "on")!
        }
            sender.setBackgroundImage(image, for: .normal)
            sender.isSelected = !sender.isSelected
            CurrentCategor.category[sender.tag] = sender.isSelected
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
