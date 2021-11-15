//
//  UIViewController+ShowAlert.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import UIKit

/// Протоколом подписываем сущность (UIViewController),
/// чтобы получить возможность показывать системные всплывающие окна.
protocol IAlertIndicatable { }

extension IAlertIndicatable where Self: UIViewController {

    /// Показ системного всплывающего окна.
    /// - Parameter title: Заголовок для всплывающего окна.
    /// - Parameter message: Тело сообщения для всплывающего окна.
    /// - Parameter actions: Кастомные действия-кнопки для всплывающего окна.
    /// - Parameter completion: Замыкание с кодом, который необходимо выполнить после показа окна.
    func showAlert(title: String? = "", message: String, actions: [UIAlertAction] = [], completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Если никаких действий не пришло, то добавим одно по умолчанию.
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            actions.forEach { alert.addAction($0) }
        }
        self.present(alert, animated: true, completion: completion)
    }
}
