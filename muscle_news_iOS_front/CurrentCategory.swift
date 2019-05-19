//
//  CurrentCategory.swift
//  muscle_news_iOS_front
//
//  Created by 会津慎弥 on 2019/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct CurrentCategor {
    static var category = [true, true, true, true, true, true, true, true, true]
    static var str = ["災害", "エンタメ", "オリンピック", "経済", "テクノロジー", "医療", "グルメ", "スポーツ", "天気"]
    
    static func getCategory() -> String {
        for i in 0..<9 {
            if category[i] {
                return str[i]
            }
    }
        return "災害"
}
}
