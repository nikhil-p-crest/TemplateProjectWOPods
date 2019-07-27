//
//  NPMediaManager.swift
//  circles
//
//  Created by Mac22 on 17/04/19.
//  Copyright © 2019 NP. All rights reserved.
//

import UIKit
import Photos
import MediaPlayer
import AVKit

class NPMediaManager: NSObject {
    
    static let shared: NPMediaManager = {
        let instance = NPMediaManager.init()
        return instance
    }()
    
    fileprivate var arrayAssets: [PHAsset]?
    fileprivate var arrayMPMediaItems: [MPMediaItem]?
    
    var selectedAsset: PHAsset? {
        if self.selectedImageIndex < self.arrayAssets?.count ?? 0 {
            return self.arrayAssets?[self.selectedImageIndex]
        }
        return nil
    }
    var selectedMPMediaItem: MPMediaItem? {
        if self.selectedMPMediaItemIndex < self.arrayMPMediaItems?.count ?? 0 {
            return self.arrayMPMediaItems![self.selectedMPMediaItemIndex]
        }
        return nil
    }
    
    var selectedImageIndex: Int = 0
    var selectedMPMediaItemIndex: Int = 0 {
        didSet {
            if let mpMediaItem = self.selectedMPMediaItem {
                self.saveMPMediaItem(mpMediaItem) { (status, response) in
                    if status == true {
                        self.audioPath = response
                    }
                }
            }
        }
    }
    var audioPath: String = ""

}

extension NPMediaManager {
    
    func fetchAllAssets(_ completion: ((Bool, String, [PHAsset]) -> ())? = nil) {
        
        if self.arrayAssets?.count ?? 0 > 0 {
            completion?(true, "", self.arrayAssets!)
            return
        }
        
        self.arrayAssets = [PHAsset].init()
        
        PHPhotoLibrary.requestAuthorization { (phAuthorizationStatus) in
            
            if phAuthorizationStatus == .authorized {
                
                let fetchOptions = PHFetchOptions.init()
                let allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                print("\(allPhotos.count) Images found.")
                
                allPhotos.enumerateObjects({ (asset, count, stop) in
                    self.arrayAssets!.append(asset)
                })
                completion?(true, "", self.arrayAssets ?? [])
                
            } else {
                
                completion?(false, "Permission not available.", [])
                
            }
            
        }
        
    }
    
    func fetchAllAudios(_ completion: ((Bool, String, [MPMediaItem])->())? = nil) {
        
        if self.arrayMPMediaItems != nil {
            completion?(true, "" ,self.arrayMPMediaItems!)
            return
        }
        
        MPMediaLibrary.requestAuthorization { (mpMediaLibraryAuthorizationStatus) in
            if mpMediaLibraryAuthorizationStatus == .authorized {
                let mediaQuery = MPMediaQuery.songs()
                let array = mediaQuery.items ?? []
                self.arrayMPMediaItems = Array.init(array)
                completion?(true, "" ,array)
            } else {
                completion?(false, "Permission not available.", [])
            }
        }
        
    }
    
    func saveMPMediaItems(_ arrayMPMediaItems: [MPMediaItem], _ completion: @escaping ((Bool, String, [String])->())) {
        var arrayPaths: [String] = []
        arrayMPMediaItems.forEach { (mpMediaItem) in
            self.saveMPMediaItem(mpMediaItem) { (status, response) in
                if status == true {
                    arrayPaths.append(response)
                    if arrayPaths.count == arrayMPMediaItems.count {
                        completion(true, "", arrayPaths)
                        return
                    }
                } else {
                    completion(false, response, arrayPaths)
                    return
                }
            }
        }
    }
    
    func saveMPMediaItem(_ mpMediaItem: MPMediaItem, _ completion: @escaping ((Bool, String)->())) {
        
        if mpMediaItem.assetURL == nil {
            completion(false, "Asset URL not found.")
            return
        }
        
        var fileName = mpMediaItem.title ?? "audio"
        fileName = fileName.replacingOccurrences(of: " ", with: "_")
        let avURLAsset = AVURLAsset.init(url: mpMediaItem.assetURL!)
        
        let exportSession = AVAssetExportSession.init(asset: avURLAsset, presetName: AVAssetExportPresetPassthrough)
        
        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.shouldOptimizeForNetworkUse = true
        
        let fileExtension = ".m4a"
        let path = UtilityManager.shared.documentDirectoryPath().appending("/\(fileName)\(fileExtension)")
        
        exportSession?.outputURL = URL.init(fileURLWithPath: path)
        
        exportSession?.exportAsynchronously(completionHandler: {
            if exportSession?.status == .completed {
                print(path)
                completion(true, path)
            } else {
                print(exportSession?.error?.localizedDescription ?? "")
                completion(false, exportSession?.error?.localizedDescription ?? "")
            }
        })
        
    }
    
}
