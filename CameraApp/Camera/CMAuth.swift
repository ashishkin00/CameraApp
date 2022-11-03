import Photos

extension CameraManager {
    func requestCaptureAccess(_ completionHandler: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func requestLibraryAccess(_ completionHandler: @escaping (Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { granted in
            if granted == .authorized {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func requestAudioAccess(_ completionHandler: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
}
