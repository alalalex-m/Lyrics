import AVFoundation

class AlbumArtworkView : UIView {

    private let button = AlbumArtworkButton()
    var artworkButton: UIButton { return button }
    
    init() {
        super.init(frame: .zero)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = button.artwork {
            button.frame = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
        } else {
            button.frame = bounds
        }
    }
    
    var artwork: UIImage? {
        get { return button.artwork }
        set { button.artwork = newValue }
    }
}

private class AlbumArtworkButton : UIButton {
    
    private let placeholderImage = img("PlaceholderAlbumArtwork")
    
    var artwork: UIImage? {
        didSet {
            setImage(artwork ?? placeholderImage, for: .normal)
            setNeedsLayout()
        }
    }
    
    override var buttonType: ButtonType {
        return .system
    }
    
    init() {
        super.init(frame: .zero)
        
        clipsToBounds = true
        if #available(iOS 13, *) {
            layer.cornerCurve = .continuous
        } else {
            layer.setValue(true, forKey: "continuousCorners")
        }
        setImage(artwork ?? placeholderImage, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = round(min(bounds.width, bounds.height) / 30)
        imageView?.frame = bounds
    }
}
