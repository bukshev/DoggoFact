//
//  Observable.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import Foundation

/// Сущность, которая служит механизмом
final class Observable<Value> {

    /// Обёртка для хранения слабой ссылки на слушателя — дабы избежать неприятных утечек памяти.
    struct WeakWrapper<Value> {
        /// Слабая ссылка на самого слушателя.
        weak var entity: AnyObject?
        /// Действие, которое необходимо выполнить при изменении свойства, на которое подпишемся.
        /// - Parameter Value: Актуальное значение `value` для слушателя.
        let action: (Value) -> Void
    }

    /// Список слушателей, которым интересно изменение значения `value`.
    private var observers: [WeakWrapper<Value>] = []

    /// Текущее значение "наблюдаемого" свойства. Другими словами — это и есть само свойство.
    var value: Value {
        /// Если кто-то меняет значение, то уведомляем всех слушателей (подписчиков).
        didSet { notifyObservers() }
    }

    // MARK: Initialization

    init(_ value: Value) {
        self.value = value
    }

    // MARK: Interface

    /// Добавить нового слушателя-подписчика, которому интересно знать, когда изменится `value`.
    /// - Parameter observer: Ссылка на объект, который хочет подписаться на изменения `value`.
    /// - Parameter observer: Замыкание с кодом, который нужно выполнить, когда `value` изменится.
    func subscribe(on observer: AnyObject, actionBlock: @escaping (Value) -> Void) {
        observers.append(.init(entity: observer, action: actionBlock))
        actionBlock(value)
    }

    /// Удалить слушателя-подписчика и больше не получать уведомлений об изменении `value`.
    /// - Parameter observer: Ссылка на объект, которого нужно отписать от изменений `value`.
    func unsubscribe(from observer: AnyObject) {
        observers = observers.filter { $0.entity !== observer }
    }
}

// MARK: - Private helpers

private extension Observable {

    /// Пробежать по всем слушателям и уведомить, что `value` изменилось.
    func notifyObservers() {
        observers.forEach { observer in
            DispatchQueue.main.async { observer.action(self.value) }
        }
    }
}
