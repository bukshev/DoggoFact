//
//  API.swift
//  DoggoFact
//
//  Created by Иван Букшев on 14.11.2021.
//

import Foundation

/// Некий Namespace, в котором собрана информация об API, с которым мы планируем взаимодействовать.
enum API {

    /// Базовый URL сервера, на который мы будем совершать запросы.
    private static let baseURLString = "https://dog-facts-api.herokuapp.com/api"

    /// Во многих сервисах у API существует версионирование.
    /// Чтобы было удобнее работать, можно выносить возможные версии в enum.
    enum Version: String {
        case v1
    }

    /// Endpoint (ручка, handle, etc.) на сервере, с которой мы можем взаимодействовать.
    enum Endpoint: String {
        /// Получить список фактов о собаках.
        case getFacts = "resources/dogs"

        /// Для более быстрой сборки URL'а для конкретного Endpoint'а удобно использовать такую computed-property.
        var urlString: String {
            "\(API.baseURLString)/\(API.Version.v1.rawValue)/\(rawValue)"
        }
    }
}
