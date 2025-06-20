import SwiftUI
import Combine

@MainActor
final class DeviceOrientationObserver: ObservableObject {
    @Published private(set) var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    private var notificationCancellable: AnyCancellable?
    
    func start() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        notificationCancellable = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let current = UIDevice.current.orientation
                // Filter out unknown, faceUp, faceDown, and keep only meaningful orientation
                if current.isValidInterfaceOrientation {
                    self.orientation = current
                }
            }
        
        // Initial orientation assignment if valid
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            orientation = UIDevice.current.orientation
        }
    }
    
    func stop() {
        notificationCancellable?.cancel()
        notificationCancellable = nil
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

private extension UIDeviceOrientation {
    var isValidInterfaceOrientation: Bool {
        switch self {
        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
            return true
        default:
            return false
        }
    }
}
