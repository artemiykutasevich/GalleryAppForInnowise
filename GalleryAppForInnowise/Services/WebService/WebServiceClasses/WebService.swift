//
//  WebService.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 1.04.24.
//

import UIKit

// MARK: - WebServiceProtocol

protocol WebServiceProtocol {
    var connectionIsAvailable: Bool { get }
    func perform<T: Decodable>(requestData: RequestData, completion: @escaping (Result<T, InternalError>) -> Void)
    func perform(requestData: RequestData, completion: @escaping (Result<UIImage, InternalError>) -> Void)
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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let requestAnswer: RequestAnswer = (data, response, error)
            self.handleResponse(requestAnswer: requestAnswer, responseHandler: completion)
        }
        task.resume()
    }

    func perform(requestData: RequestData, completion: @escaping (Result<UIImage, InternalError>) -> Void) {
        guard connectionIsAvailable else {
            completion(.failure(.noInternetConnection))
            return
        }
        guard let request = URLRequest.createRequest(from: requestData) else {
            completion(.failure(.incorectURL))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let requestAnswer: RequestAnswer = (data, response, error)
            self.handleResponse(requestAnswer: requestAnswer, responseHandler: completion)
        }
        task.resume()
    }
}

extension WebService {
    private func handleResponse<T: Decodable>(requestAnswer: RequestAnswer, responseHandler: @escaping (Result<T, InternalError>) -> Void) {
        guard let data = requestAnswer.data, let response = requestAnswer.response else {
            responseHandler(.failure(.emptyData))
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            responseHandler(.failure(.incorectResponse))
            return
        }
        DispatchQueue.main.async {
            switch statusCode {
            case 200...299:
                if let resultData = try? JSONDecoder().decode(T.self, from: data) {
                    responseHandler(.success(resultData))
                } else {
                    responseHandler(.failure(.incorectJSON))
                }
            case 400:
                responseHandler(.failure(.incorectRequest))
            case 401:
                responseHandler(.failure(.notAuthorizedException))
            case 402...499:
                responseHandler(.failure(.clientError))
            case 500...599:
                responseHandler(.failure(.serverError))
            default:
                responseHandler(.failure(.unknown))
            }
        }
    }

    private func handleResponse(requestAnswer: RequestAnswer, responseHandler: @escaping (Result<UIImage, InternalError>) -> Void) {
        guard let data = requestAnswer.data, let response = requestAnswer.response else {
            responseHandler(.failure(.emptyData))
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            responseHandler(.failure(.incorectResponse))
            return
        }
        DispatchQueue.main.async {
            switch statusCode {
            case 200...299:
                if let image = UIImage(data: data) {
                    responseHandler(.success(image))
                } else {
                    responseHandler(.failure(.incorectData))
                }
            case 400:
                responseHandler(.failure(.incorectRequest))
            case 401:
                responseHandler(.failure(.notAuthorizedException))
            case 402...499:
                responseHandler(.failure(.clientError))
            case 500...599:
                responseHandler(.failure(.serverError))
            default:
                responseHandler(.failure(.unknown))
            }
        }
    }
}
