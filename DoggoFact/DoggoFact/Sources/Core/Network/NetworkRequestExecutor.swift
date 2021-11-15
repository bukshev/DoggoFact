//
//  NetworkRequestExecutor.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

// MARK: - Contract

/// Возможные ошибки, которые могут возникнуть на данном сетевом уровне.
private enum NetworkError {
    /// Собран невалидный URL.
    case badURL
    /// Пришла ошибка от сервера в ответе.
    case responseError
    /// От сервера пришёл статус "не хороший" статус-код.
    case invalidStatusCode
    /// От сервера не пришло информации для "успешного" статус-кода.
    case noResponseData
    /// Произошла ошибка декодирования информации от сервера в локальный DTO.
    case decodingError
}

protocol INetworkRequestExecutor {
    /// Выполнить сетевой запрос с заданным completion-блоком.
    func execute<T: Decodable>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void)
}

// MARK: - NetworkRequestExecutor

final class NetworkRequestExecutor {

    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
}

// MARK: - NetworkRequestExecutor + INetworkRequestExecutor

extension NetworkRequestExecutor: INetworkRequestExecutor {

    func execute<T: Decodable>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: request.endpoint.urlString) else {
            let error = NetworkError.badURL.value(details: " URL: \(request.endpoint.urlString)")
            Log.e(.coreNetwork, error.localizedDescription)
            completion(.failure(error))
            return
        }

        urlComponents.queryItems = request.queryItems

        guard let url = urlComponents.url else {
            let error = NetworkError.badURL.value(details: " URL: \(request.endpoint.urlString)")
            Log.e(.coreNetwork, error.localizedDescription)
            completion(.failure(error))
            return
        }

        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                let totalError = NetworkError.responseError.value(with: error.localizedDescription)
                Log.e(.coreNetwork, totalError.localizedDescription)
                completion(.failure(totalError))
                return
            }

            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                let statusCode = String(describing: (response as? HTTPURLResponse)?.statusCode)
                let error = NetworkError.invalidStatusCode.value(details: " Status code: \(statusCode)")
                Log.e(.coreNetwork, error.localizedDescription)
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NetworkError.noResponseData.value()
                Log.e(.coreNetwork, error.localizedDescription)
                completion(.failure(error))
                return
            }

            // Бывают ситуации с ответом 204 — когда data может и не быть.
            // В рамках данного примера мы это не рассматриваем.
            guard let dto = try? self?.decoder.decode(T.self, from: data) else {
                let error = NetworkError.decodingError.value(details: "Target DTO: \(T.self).")
                Log.e(.coreNetwork, error.localizedDescription)
                completion(.failure(error))
                return
            }

            completion(.success(dto))
        }

        Log.i(.coreNetwork, "Start executing: \(url.absoluteString)")
        task.resume()
    }
}

private extension NetworkError {

    /// Доменное имя для нашего сетевого уровня.
    static let domain = "NetworkLayer"

    /// Локальный код ошибки.
    var code: Int {
        switch self {
        case .badURL:
            return -1
        case .responseError:
            return -2
        case .invalidStatusCode:
            return -3
        case .noResponseData:
            return -4
        case .decodingError:
            return -5
        }
    }

    /// Локализованное описание ошибки.
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Failed to build full path to resource."
        case .invalidStatusCode:
            return "Received an invalid status code from the server."
        case .noResponseData:
            return "There was no response from the server."
        case .decodingError:
            return "A decoding error has occurred. Or `self` became nil."
        default:
            return "An error has occurred at the network level. Unfortunately, there are no details."
        }
    }

    /// Получить итоговое значение ошибки для пробрасывания на более верхний уровень.
    func value(with message: String? = nil, details: String? = nil) -> Error {
        let localizedErrorMessage = (message ?? localizedDescription).appending(details ?? "")
        return NSError(domain: NetworkError.domain, code: code, userInfo: [
            NSLocalizedFailureErrorKey: localizedErrorMessage
        ])
    }
}
