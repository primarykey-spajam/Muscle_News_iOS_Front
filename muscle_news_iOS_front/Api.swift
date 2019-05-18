//
//  Api.swift
//  FabNavi
//
//  Created by 会津慎弥 on 2018/03/11.
//  Copyright © 2018年 会津慎弥. All rights reserved.
//

import Alamofire
import ObjectMapper

enum Api: API {
    
    case getNews(category: String)
    
    var buildURL: URL {
        return URL(string: "\(baseURL)\(path)")!
    }
    
    var baseURL: String {
        return BaseURL().getBaseURL()
    }
    
    var path: String {
        switch self {
        case .getNews(category: let category): return "/users/\(category)/projects.json"
        }
    }
    
    var parameters: Parameters {
        let params  = [String: Any]()
        switch self {
        case .getNews:
            return params
        }
    }
    
    var data: Data? {
        return nil
    }
}

protocol API {
    var buildURL: URL { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var data: Data? { get }
}
