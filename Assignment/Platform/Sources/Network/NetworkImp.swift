/**
 @class
 @date 5/20/24
 @writer kimsoomin
 @brief
 - 네트워크 요청 
 @update history
 -
 */

import Foundation
import Combine
import Common

public final class NetworkImp: Network {
    
    private let session: URLSession
    
    public init(
        session: URLSession
    ) {
        self.session = session
    }
    
    public func send<T>(_ request: T) -> AnyPublisher<Response<T.Output>, Error> where T: Request {
        do {
            let urlRequest = try RequestFactory(request: request).getURLRequest()
            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { data, response in
                    
                    let code = (response as? HTTPURLResponse)?.statusCode
                    let errorType = NetworkError.getErrorType(code: code ?? 999)
                    
                    apiLog(url: response.url?.absoluteString, resultCode: code, message: data)
                    
                    if code != 200 {
                        throw errorType
                    }                    
                    let output = try JSONDecoder().decode(T.Output.self, from: data)
                    return Response(output: output, statusCode: code ?? 999)
                }.mapError{
                    printLog($0)
                    if $0.localizedDescription.contains("format") ||
                        $0.localizedDescription.contains("keyNotFound")
                    {
                        return NetworkError.decodingError
                    }
                    return $0
                }
                .eraseToAnyPublisher()
        } catch {
            printLog(error.localizedDescription)
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

private final class RequestFactory<T: Request> {
    
    let request: T
    var urlComponents: URLComponents?
    
    init(request: T) {
        self.request = request
        self.urlComponents = URLComponents(url: request.endpoint, resolvingAgainstBaseURL: true)
    }
    
    func getURLRequest() throws -> URLRequest {
        switch request.method {
        case .get:
            return try makeGetRequest()
        case .post:
            return try makePostRequest()
        case .put:
            return try makePutRequest()
        }
    }
    
    private func makeGetRequest() throws -> URLRequest {
        if request.query.isEmpty == false {
            urlComponents?.queryItems = request.query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        return try makeURLRequest()
    }
    
    private func makePostRequest() throws -> URLRequest {
        if request.isMultiPart {
            return try makeMultiTaskURLRequest()
        }else {
            let body = try JSONSerialization.data(withJSONObject: request.query, options: [])
            return try makeURLRequest(httpBody: body)
        }
    }
    
    private func makePutRequest() throws -> URLRequest {
        if request.query.isEmpty == false {
            let body = try JSONSerialization.data(withJSONObject: request.query, options: [])
            return try makeURLRequest(httpBody: body)
        }
        return try makeURLRequest()
    }
    
    private func makeURLRequest(httpBody: Data? = nil) throws -> URLRequest {
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL(request.endpoint.absoluteString)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = httpBody
        request.header.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        urlRequest.httpMethod = request.method.rawValue
        
        
        return urlRequest
    }
    
    private func makeMultiTaskURLRequest() throws -> URLRequest {
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL(request.endpoint.absoluteString)
        }
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        urlReq.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()

        for (key, value) in request.query {
            if key != "imageFile"{
                body.append("--\(boundary)".data(using: .utf8)!)
                body.append("\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8)!)
                body.append("\r\n\(value)".data(using: .utf8)!)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        printLog("Multipart Body: \(String(decoding: body, as: UTF8.self))")
        
        let imageData = request.query["imageFile"] as! Data
        // 이미지 데이터 추가
        body.append("--\(boundary)".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"imageFile\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        //Body End
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlReq.httpBody = body

        return urlReq
    }

}
