//
//  SceneDelegate.swift
//  DoggoFact
//
//  Created by Иван Букшев on 11.11.2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = .init(windowScene: windowScene)

        let viewController: FactListViewController = .fromStoryboard()
        let viewModel: FactListViewModel = .init(loadFactsUseCase: .init())
        viewController.inject(viewModel: viewModel)
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
