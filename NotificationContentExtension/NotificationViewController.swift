import LyricsUI
import UserNotificationsUI

class NotificationViewController : UIViewController, UNNotificationContentExtension {
    
    private lazy var lyricsContainer = LyricsContainerViewController()
    private lazy var lyricsNavigationController = UINavigationController(rootViewController: lyricsContainer)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = .globalTint
        
        addChild(lyricsNavigationController)
        defer {
            lyricsNavigationController.didMove(toParent: self)
        }
        do {
            let controller = lyricsNavigationController
            controller.navigationBar.isTranslucent = false
            controller.toolbar.isTranslucent = false
            controller.isToolbarHidden = false
            
            if #available(iOS 13, *) {
                setOverrideTraitCollection(UITraitCollection(userInterfaceLevel: .elevated), forChild: controller)
                controller.navigationBar.barTintColor = .systemBackground
                controller.toolbar.barTintColor = .systemBackground
            }
        }
        view.addSubview(lyricsNavigationController.view)
        lyricsNavigationController.view.addConstraintsToFitSuperview()
        
        let tableView = lyricsContainer.tableViewController.tableView!
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        
        var screenBounds = UIScreen.main.bounds
        updateContentSize(with: screenBounds)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            if let self = self {
                let newBounds = UIScreen.main.bounds
                if screenBounds != newBounds {
                    screenBounds = newBounds
                    self.updateContentSize(with: screenBounds)
                }
            } else {
                timer.invalidate()
            }
        }
    }
    
    func didReceive(_ notification: UNNotification) {
        updateContentSize(with: UIScreen.main.bounds)
    }
    
    private func updateContentSize(with screenBounds: CGRect) {
        var contentSize = CGSize(width: 9999, height: screenBounds.height - 100)
        contentSize.height -= UIDevice.current.userInterfaceIdiom == .pad ? 16 : 8
        if UITraitCollection.kjy_displayNotched {
            contentSize.height -= 40 // align bottom edge with screen safe area
        }
        preferredContentSize = contentSize
    }
}

