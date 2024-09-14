//
//  SceneDelegate.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 1.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let authVM = AuthVM()
    var authStateListener: NSObjectProtocol?
    
    var viewController: UIViewController? {
        didSet {
            self.window?.rootViewController = viewController
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        
        authStateListener = authVM.auth.addStateDidChangeListener { auth, user in
            if user != nil {
                self.authVM.getUserDocAndSync(user!.uid) {
                    self.viewController = board.instantiateViewController(identifier: "DashboardTBC") as UITabBarController
                }
                
            } else {
                self.viewController = board.instantiateViewController(identifier: "LoginVC") as UIViewController
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("SceneDidDisconnect method: \(scene)")
        print("")
        
        if authStateListener != nil {
            authVM.auth.removeStateDidChangeListener(authStateListener!)
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("SceneDidBecomeActive method: \(scene)")
        print("")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("SceneWillResignActive method: \(scene)")
        print("")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("SceneWillEnterForeground method: \(scene)")
        print("")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        
        print("SceneDidEnterBackround method: \(scene)")
        print("")
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

