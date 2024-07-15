#if canImport(CoreGraphics)

    import CoreGraphics

    @available(OSX 10.10, iOS 8, tvOS 2, *)
    private extension LyricsProviderSource {
        
        var drawingMethod: ((CGRect) -> Void)? {
            switch self {
            case .netease:
                return LyricsSourceIconDrawing.drawNetEaseMusic
            case .gecimi:
                return LyricsSourceIconDrawing.drawGecimi
            case .kugou:
                return LyricsSourceIconDrawing.drawKugou
            case .qq:
                return LyricsSourceIconDrawing.drawQQMusic
            case .xiami:
                return LyricsSourceIconDrawing.drawXiami
            default:
                return nil
            }
        }
        
    }
    
#endif

#if canImport(Cocoa)
    
    import Cocoa
    
    extension LyricsSourceIconDrawing {
        
        public static let defaultSize = CGSize(width: 48, height: 48)
        
        public static func icon(of source: LyricsProviderSource, size: CGSize = defaultSize) -> NSImage {
            return NSImage(size: size, flipped: false) { (NSRect) -> Bool in
                source.drawingMethod?(CGRect(origin: .zero, size: size))
                return true
            }
        }
    }
    
#elseif canImport(UIKit)
    
    import UIKit
    
    extension LyricsSourceIconDrawing {
        
        public static let defaultSize = CGSize(width: 48, height: 48)
        
        public static func icon(of source: LyricsProviderSource, size: CGSize = defaultSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            source.drawingMethod?(CGRect(origin: .zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }
    }

#endif
