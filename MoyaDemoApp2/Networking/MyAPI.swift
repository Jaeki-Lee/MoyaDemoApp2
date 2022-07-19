//
//  MyAPI.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//

import Moya

enum MyAPI {
    case getPhotos(PhotoRequest)
}

/*
 API endpoint 케이스 정의 "MyAPI.swift"
 getBaseURL(), getPath(), getMethod(), getTask()는 별도의 파일에서 정의
 별도의 파일에서 task, request, path, method, baseURL을 정의하여 get-으로 사용하는 이유는, case가 많아지면 복잡해지므로 역할의 분리를 위함
 */

extension MyAPI: Moya.TargetType {
    var baseURL: URL {
        self.getBaseURL()
    }
    
    var path: String {
        self.getPath()
    }
    
    var method: Method {
        self.getMethod()
    }
    
    var task: Task {
        self.getTask()
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
