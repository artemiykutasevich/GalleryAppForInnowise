//
//  WebService.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

import Foundation

// MARK: - WebServiceProtocol

protocol WebServiceProtocol {
    var connectionIsAvailable: Bool { get }
    func perform<T: Decodable>(requestData: RequestData, completion: @escaping (Result<T, InternalError>) -> Void)
}

// MARK: - WebService

final class WebService {
    var connectionIsAvailable: Bool {
        return Reachability.isConnectedToNetwork()
    }
}

extension WebService: WebServiceProtocol {
    func perform<T: Decodable>(requestData: RequestData, completion: @escaping (Result<T, InternalError>) -> Void) {
        guard connectionIsAvailable else {
            completion(.failure(.noInternetConnection))
            return
        }
        guard let request = URLRequest.createRequest(from: requestData) else {
            completion(.failure(.incorectURL))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            self.handleResponse(data: data, response: response, error: error, responseHandler: completion)
        }
        task.resume()
    }
}

extension WebService {
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, responseHandler: @escaping (Result<T, InternalError>) -> Void) {
        guard let data, let response else {
            responseHandler(.failure(.emptyData))
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            responseHandler(.failure(.incorectResponse))
            return
        }
        DispatchQueue.main.async {
            switch statusCode {
            case 200:
                if let resultData = try? JSONDecoder().decode(T.self, from: data) {
                    responseHandler(.success(resultData))
                } else {
                    responseHandler(.failure(.incorectJSON))
                }
            case 400:
                responseHandler(.failure(.incorectRequest))
            case 401:
                responseHandler(.failure(.notAuthorizedException))
            case 500, 503:
                responseHandler(.failure(.serverError))
            default:
                responseHandler(.failure(.unknown))
            }
        }
    }
}
