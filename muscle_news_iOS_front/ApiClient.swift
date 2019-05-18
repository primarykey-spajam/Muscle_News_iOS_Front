//
//  ApiClient.swift
//  FabNavi
//
//  Created by 会津慎弥 on 2018/03/11.
//  Copyright © 2018年 会津慎弥. All rights reserved.
//

import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

struct ApiClient {
    static let manager = Alamofire.SessionManager.default
    
    private static func json(method: HTTPMethod = .get, api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<Any> {
        if api.data == nil {
            return dataRequest(method: method, api: api, encoding: encoding, headers: headers)
                .flatMap { (dataRequest) -> Observable<Any> in
                    return manager.rx.json(request: dataRequest)
            }
        } else {
            return uploadRequest(api: api, headers: headers)
                .flatMap { (request) -> Observable<Any> in
                    return manager.rx.json(request: request)
            }
        }
    }
    
    private static func dataRequest(method: HTTPMethod = .get, api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<DataRequest> {
        return Observable<DataRequest>
            .create { (observer) -> Disposable in
                let url = api.buildURL
                let request = manager.request(url, method: method, parameters: api.parameters, encoding: encoding, headers: headers)
                observer.onNext(request)
                observer.onCompleted()
                return Disposables.create()
        }
    }
    
    static func uploadRequest(
        method: HTTPMethod = .post,
        api: API,
        headers: [String: String]? = nil) -> Observable<UploadRequest> {
        
        return Observable<UploadRequest>
            .create { (observer) -> Disposable in
                let url = api.buildURL
                if let data = api.data {
                    manager.upload(multipartFormData: { (formData) in
                        if let filename = api.parameters["filename"] as? String {
                            formData.append(data, withName: "attachment[file]", fileName: filename, mimeType: api.parameters["figureType"] as! String)
                        }
                        for param in api.parameters {
                            if let value = param.value as? String, let data = value.data(using: .utf8) {
                                formData.append(data, withName: param.key)
                            }
                        }
                    }, to: url, headers: headers, encodingCompletion: { (result) in
                        switch result {
                        case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                            observer.onNext(request)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    })
                } else {
                    observer.onError(RxCocoaURLError.unknown)
                }
                return Disposables.create()
        }
    }
    
    static func get<T: Mappable>(api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<T> {
        return ApiClient.json(method: .get, api: api, encoding: encoding, headers: headers).map(mapping())
    }
    
    static func get<T: Mappable>(api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<[T]> {
        return ApiClient.json(method: .get, api: api, encoding: encoding, headers: headers).map(mappingToArray())
    }
    
    static func post<T: Mappable>(api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<T> {
        return ApiClient.json(method: .post, api: api, encoding: encoding, headers: headers).map(mapping())
    }
    
    static func patch<T: Mappable>(api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<T> {
        return ApiClient.json(method: .patch, api: api, encoding: encoding, headers: headers).map(mapping())
    }
    
    static func delete<T: Mappable>(api: API, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<[T]> {
        return ApiClient.json(method: .delete, api: api, encoding: encoding, headers: headers).map(mappingToArray())
    }
    
    static func mapping<T: Mappable>() -> ((Any) -> T) {
        return { (json) -> T in
            let item: T = Mapper<T>().map(JSONObject: json)!
            return item
        }
    }    
    
    static func mappingToArray<T: Mappable>() -> ((Any) -> [T]) {
        return { (json) -> [T] in
            let item: [T] = Mapper<T>().mapArray(JSONObject: json) ?? []
            return item
        }
    }
}

extension Alamofire.SessionManager: ReactiveCompatible {}

extension Reactive where Base: SessionManager {
    
    func json(request: DataRequest) -> Observable<Any> {
        return Observable<Any>.create { (observer) -> Disposable in
            let req = request.responseJSON(completionHandler: { (response) in
                guard let res = response.response, let json = response.result.value else {
                    if let error = response.result.error {
                        observer.onError(error)
                    } else {
                        observer.onError(RxCocoaURLError.unknown)
                    }
                    return
                }
                if 200 ..< 300 ~= res.statusCode {
                    observer.onNext(json)
                    observer.onCompleted()
                } else {
                    let error = RxCocoaURLError.httpRequestFailed(response: res, data: response.data)
                    observer.onError(error)
                }
            })
            return Disposables.create {
                req.cancel()
            }
        }
    }
}
