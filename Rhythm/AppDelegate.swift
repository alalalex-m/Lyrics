import LyricsUI

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? { get { return mainWindow } set {} }
    
    private lazy var mainWindow = UIWindow()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LyricsNotificationController.shared.openSettingsHandler = { _ in
            application.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        mainWindow.tintColor = .globalTint
        
        let accessSettingsController = SystemAccessSettingsTableViewController()
        
        accessSettingsController.preparationHandler = { [weak accessSettingsController] in
            accessSettingsController?.view.isHidden = false
            accessSettingsController?.title = NSLocalizedString("permissionSettings", comment: "")
            accessSettingsController?.navigationController?.isToolbarHidden = true
            accessSettingsController?.navigationController?.navigationBar.prefersLargeTitles = true
        }
        accessSettingsController.completionHandler = { [weak self] in
            LocationManager.shared.start()
            _ = SystemPlayerLyricsController.shared
            _ = NowPlayingNotificationManager.shared
            self?.updateWindowForLyricsUI()
        }
        
        let navigationController = UINavigationController(rootViewController: accessSettingsController)
        navigationController.isToolbarHidden = false
        navigationController.view.backgroundColor = .kjy_systemBackground
        accessSettingsController.view.isHidden = true
        
        mainWindow.rootViewController = navigationController
        mainWindow.makeKeyAndVisible()
        
        return true
    }
    
    private func updateWindowForLyricsUI() {
        let lyricsController = LyricsContainerViewController()
        let navigationController = UINavigationController(rootViewController: lyricsController)
        navigationController.isToolbarHidden = false
        
        mainWindow.rootViewController = navigationController
        mainWindow.makeKeyAndVisible()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        handleApplicationURL(url)
        return true
    }
    
    private func handleApplicationURL(_ url: URL) {
        if let navigationController = mainWindow.rootViewController as? UINavigationController,
            let lyricsController = navigationController.viewControllers.first as? LyricsContainerViewController,
            lyricsController.view.window != nil
        {
            _ = lyricsController.handleApplicationURL(url)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                dprint("retry")
                self?.handleApplicationURL(url)
            }
        }
    }
}
