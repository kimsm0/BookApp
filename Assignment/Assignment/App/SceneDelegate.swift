/**
 @class SceneDelegate
 @date 5/20/2
 @writer kimsoomin
 @brief
 - Root리블렛을 attach하여 앱의 시작점을 연결한다. 
 @update history
 -
 */
import UIKit
import ArchitectureModule
import BookTestSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchRouter: Routing?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        #if UITESTING
        BookTestDouble.testMode = .search
        let rootRouter = AppRootTestBuilder(dependency: AppComponent()).build()
        self.launchRouter = rootRouter
        window?.rootViewController = rootRouter.viewController.uiviewController
        window?.makeKeyAndVisible()
        #else
        let rootRouter = AppRootBuilder(dependency: AppComponent()).build()
        self.launchRouter = rootRouter
        window?.rootViewController = rootRouter.viewController.uiviewController
        window?.makeKeyAndVisible()
        #endif
        
        

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

