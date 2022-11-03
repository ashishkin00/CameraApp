import UIKit
import AVFoundation
import Photos
import PhotosUI

extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            requestLibraryAccess { granted in
                if granted {
                    do {
                        try PHPhotoLibrary.shared().performChangesAndWait {
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                            print("video has saved in library...")
                        }
                    } catch let error {
                        print("failed to save photo in library: ", error)
                    }
                } else {
                }
            }
        } else {
            print("didFinishRecordingTo \(error))")
        }
    }
    @objc func recordVideo() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mp4")
            try? FileManager.default.removeItem(at: fileUrl)
            videoOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }
    }
}
