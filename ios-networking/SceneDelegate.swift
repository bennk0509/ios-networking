//
//  SceneDelegate.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // MARK: - Composition Root

        // SessionManager — 1 instance duy nhất, dùng chung cho interceptor lẫn repository
        let sessionManager = SessionManager()

        // publicPerformer — không có interceptor, dùng cho login (chưa có token)
        let publicPerformer = AsyncRequestPerformer()

        // authenticatedPerformer — có interceptor, dùng cho mọi request cần auth
        let authenticatedPerformer = AsyncRequestPerformer(
            interceptors: [AuthenticationInterceptor(tokenProvider: sessionManager)]
        )
        _ = authenticatedPerformer // sẽ dùng khi inject vào PostService sau

        // Auth stack
        let authNetworkService = AuthNetworkServiceImpl(
            requestFactory: RequestFactoryImpl(),
            performer: publicPerformer
        )
        let authRepository = AuthRepository(
            authService: authNetworkService,
            sessionManager: sessionManager
        )
        let loginViewModel = LoginViewModel(repository: authRepository)

        // MARK: - Root ViewController

        let rootVC = ViewController(viewModel: loginViewModel)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
