//
//  Logger.swift
//  DoggoFact
//
//  Created by Иван Букшев on 15.11.2021.
//

import Foundation

/// Сущность, через которую в проекте можно логировать события.
/// Исключительно для общего формата и более красивого вывода.
enum Log {
    /// Уровень логирования.
    private enum Level: String {
        case debug = "⚙️"
        case info = "✅"
        case warning = "⚠️"
        case error = "⛔️"
    }

    /// Уровень для источника лог-сообщения.
    enum ProjectLayer {
        case coreNetwork
        case dataSource
        case gateway
        case domain
    }

    /// Залогировать сообщение debug-уровня.
    static func d(_ layer: ProjectLayer, _ message: String) {
        log(.debug, on: layer, message: message)
    }

    /// Залогировать сообщение info-уровня.
    static func i(_ layer: ProjectLayer, _ message: String) {
        log(.info, on: layer, message: message)
    }

    /// Залогировать сообщение warning-уровня.
    static func w(_ layer: ProjectLayer, _ message: String) {
        log(.warning, on: layer, message: message)
    }

    /// Залогировать сообщение error-уровня.
    static func e(_ layer: ProjectLayer, _ message: String) {
        log(.error, on: layer, message: message)
    }
}

extension Log {
    /// Непосредственный вывод сообщения в консоль.
    private static func log(_ level: Level, on layer: ProjectLayer, message: String) {
        print("\(layer.emoji) \(level.rawValue) \(layer.tag) : \(message)")
    }
}

/// Исключительно для визуального представления.
private extension Log.ProjectLayer {

    var emoji: String {
        switch self {
        case .coreNetwork:
            return "🌐"
        case .dataSource:
            return "📤"
        case .gateway:
            return "🚪"
        case .domain:
            return "💼"
        }
    }

    var tag: String {
        switch self {
        case .coreNetwork:
            return "[NETWORK]"
        case .dataSource:
            return "[DATA_SOURCE]"
        case .gateway:
            return "[GATEWAY]"
        case .domain:
            return "[DOMAIN]"
        }
    }
}
