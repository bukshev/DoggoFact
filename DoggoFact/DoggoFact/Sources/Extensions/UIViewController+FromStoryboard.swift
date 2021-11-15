//
//  UIViewController+FromStoryboard.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import UIKit

/// Протоколом подписываем сущность (UIViewController),
/// чтобы получить возможность получать проинициализированную сущность из Storyboard.
protocol IStoryboardInstantiatable { }

extension IStoryboardInstantiatable where Self: UIViewController {

    static func fromStoryboard<Type: UIViewController>() -> Type {
        let name = "\(Type.self)"

        // Storyboard должен иметь такое же имя, что и целевой ViewController.
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()

        // Если initialViewController является целевым, то его и возвращаем после кастинга типов.
        if let viewController = initialViewController as? Type {
            return viewController
        }
        // Если initialViewController является UINavigationController, а его top-VC — как раз-таки наш, то
        // его и возвращаем после кастинга типов
        else if let navigationController = initialViewController as? UINavigationController,
            let viewController = navigationController.topViewController as? Type {
            return viewController
        }

        // Если мы во всём приложении пользуемся данным механизмом по получению ViewController'ов,
        // то данный fatalError() не является опасным местом, а наоборот — звоночек, что мы сделали что-то не так.
        fatalError("Failed to create viewController from storyboard \(name)")
    }
}
