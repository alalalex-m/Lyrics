public extension UIViewController {
    
    private static var cachedViewSizeToken = 0
    
    private var cachedViewSizesByTaskNames: [String : CGSize] {
        get {
            return objc_getAssociatedObject(self, &UIViewController.cachedViewSizeToken) as? [String : CGSize] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.cachedViewSizeToken, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func performIfViewSizeChanged(file: String = #file, line: Int = #line, handler: () -> Void) {
        let taskName = file.components(separatedBy: "/").last! + "\(line)"
        guard cachedViewSizesByTaskNames[taskName] != view.bounds.size else { return }
        cachedViewSizesByTaskNames[taskName] = view.bounds.size
        handler()
    }
}
