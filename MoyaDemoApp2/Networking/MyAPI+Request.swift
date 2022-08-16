//
//  MyAPI+Request.swift
//  MoyaDemoApp2
//
//  Created by jaeki lee on 2022/07/19.
//


//MoyaProvider인스턴를 이용하여 request하는 기능 정의 + Error Handleing

import RxSwift
import Moya
import Alamofire
import Then

enum MyAPIError: Error {
    case empty
    case requestTimeout(Error)
    case internetConnection(Error)
    case restError(Error, statusCode: Int? = nil, errorCode: String? = nil)
    
    var statusCode: Int? {
        switch self {
        case .restError(_, let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    
    var errorCodes: [String] {
        switch self {
        case .restError(_, _, let errorCode):
            return [errorCode].compactMap{ $0 }
        default:
            return []
        }
    }
    
    var isNoNetwork: Bool {
        switch self {
        case .requestTimeout(let error):
            fallthrough
        case .restError(let error, _, _):
            return MyAPI.isNotConnection(error: error)
        case .internetConnection:
            return true
        default:
            return false
        }
    }
    
}

/*
 wrapper 정의
 해당 부분에서 PluginType을 삽입
 (주의: Logger Plugin은 따로 넣지 않고, #file, #line, #function을 파라미터로 받아서 해당 위치도 알 수 있게끔 request하는 곳에서 직접 로깅)
 */
extension MyAPI {
    struct Wrapper: TargetType {
        let base: MyAPI
        
        var baseURL: URL { self.base.baseURL }
        var path: String { self.base.path }
        var method: Moya.Method { self.base.method }
        var sampleData: Data { self.base.sampleData }
        var task: Task { self.base.task }
        var headers: [String : String]? { self.base.headers }
    }
    
    private enum MoyaWrapper {
        struct Plugins {
            var plugins: [PluginType]
            
            init(plugins: [PluginType] = []) {
                self.plugins = plugins
            }
            
            func callAsFunction() -> [PluginType] { self.plugins }
        }
        
        static var provider: MoyaProvider<MyAPI.Wrapper> {
            let plugins = Plugins(plugins: [])
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.urlCredentialStorage = nil
            
            let session = Session(configuration: configuration)
            
            return MoyaProvider<MyAPI.Wrapper>(
                endpointClosure: { target in
                    MoyaProvider.defaultEndpointMapping(for: target)
                },
                session: session,
                plugins: plugins()
            )
        }
    }
}

/*
 Error Handling 정의
 인터넷 연결 에러, TimeOut 에러, 일반 에러를 처리하는 메소드 정의
 (request의 응답값에서 해당 에러처리 메소드를 부르도록 설계)
 */
extension MyAPI {
    private func handleInternetConnection<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = Self.convertToURLError(error),
              Self.isNotConnection(error: error) else { throw error }
        throw MyAPIError.internetConnection(urlError)
    }
    
    private func handleTimeOut<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = Self.convertToURLError(error),
              urlError.code == .timedOut else { throw error }
        
        throw MyAPIError.requestTimeout(urlError)
    }
    
    private func handleREST<T: Any>(error: Error) throws -> Single<T> {
        guard error is MyAPIError else {
            throw MyAPIError.restError(
                error,
                statusCode: (error as? MoyaError)?.response?.statusCode,
                errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String
            )
        }
        throw error
    }
}

/*
 request하는 메소드 정의
 인수로 #file, #function, #line을 받기 때문에 별도의 LoggerPlugin을 사용하지 않고 해당 request에서 로그 출력
 log를 해당 부분에서 출력
 */

extension MyAPI {
    static let moya = MoyaWrapper.provider
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    func request(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        
        let endpoint = MyAPI.Wrapper(base: self)
        let requestString = "\(endpoint.method) \(endpoint.baseURL) \(endpoint.path)"
        
        //Self, 클래스, 구조체, enum 등에서 Self 를 사용하면 그 타입을 가리킨다
        return Self.moya.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .catch(self.handleInternetConnection)
            .catch(self.handleTimeOut)
            .catch(self.handleREST)
            .do { response in
                let requestContent = "🛰 SUCCESS: \(requestString) (\(response.statusCode))"
                print(requestContent, file, function, line)
            } onError: { rawError in
                switch rawError {
                case MyAPIError.requestTimeout:
                    print("TODO: alert MyAPIError.requestTimeout")
                case MyAPIError.internetConnection:
                    print("TODO: alert MyAPIError.internetConnection")
                case MyAPIError.restError(let error, _, _):
                    guard let response = (error as? MoyaError)?.response else { break }
                    
                    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                        let errorDictionary = jsonObject as? [String: Any]
                        
                        guard let key = errorDictionary?.first?.key else { return }
                        
                        let message: String
                        
                        if let description = errorDictionary?[key] as? String {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode)\n\(key): \(description)"
                        } else if let description = (errorDictionary?[key] as? [String]) {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(key): \(description)"
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                        } else {
                          message = "🛰 FAILURE: \(requestString) (\(response.statusCode)"
                        }
                        
                        print(message)
                    }
                default:
                    break
                }
            } onSubscribe: {
                let message = "REQUEST: \(requestString)"
                print(message, file, function, line)
            }

                    
        
    }
}

