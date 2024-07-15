import CoreLocation

class LocationManager : NSObject {
    
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    private let manager = CLLocationManager()
    
    private(set) var isRunning = false
    
    /// Start the location updates so the app can be constantly running in background.
    func start() {
        guard !isRunning else { return }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            fallthrough
            
        case .authorizedAlways, .authorizedWhenInUse:
            isRunning = true
            
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false
            
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.distanceFilter = CLLocationDistanceMax
            
            manager.stopUpdatingLocation()
            
        default:
            break
        }
    }
    
    /// Stop the location updates to preserve battery life.
    func stop() {
        manager.stopUpdatingLocation()
        isRunning = false
    }
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRunning = false
    }
}
