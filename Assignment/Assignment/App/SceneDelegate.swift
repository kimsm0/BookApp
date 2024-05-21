//
//  SceneDelegate.swift
//  Assignment
//
//  Created by kimsoomin_mac2022 on 5/20/24.
//

import UIKit
import ArchitectureModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchRouter: Routing?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        let rootRouter = AppRootBuilder(dependency: AppComponent()).build()
        
        self.launchRouter = rootRouter
        window?.rootViewController = rootRouter.viewController.
        window?.makeKeyAndVisible()

        rootRouter.interactor.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

