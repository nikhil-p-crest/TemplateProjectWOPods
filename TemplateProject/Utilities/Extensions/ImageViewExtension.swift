//
//  ImageViewExtension.swift
//  TemplateProject
//
//  Created by Nikhil Patel on 27/05/19.
//  Copyright © 2019 Nikhil Patel. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func downloadImage(fromURL stringURL: String?, placeHolderImage: UIImage? = nil, completion: ((Bool, UIImage?, Error?, URL?)->())? = nil) {
        // Default cache option is memory
        self.sd_setImage(with: URL.init(string: stringURL ?? ""), placeholderImage: placeHolderImage, options: SDWebImageOptions.refreshCached) { (image, error, imageCacheType, url) in
            var status = false
            if image != nil && error == nil {
                status = true
            } else {
                print("Error downloading image:\n\(stringURL ?? "")\nError: \(error?.localizedDescription ?? "")")
            }
            completion?(status, image, error, url)
        }
        
    }
    
}

extension UIImage {
    
    class func createTabSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineHeight), size: CGSize(width: size.width, height: lineHeight)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func downloadImage(fromURL stringURL: String?, progress: ((Int, Int, URL?)->())? = nil, completion:@escaping ((UIImage?, Data?, Error?, Bool)->())) {
        SDWebImageManager.shared.imageLoader.requestImage(with: URL.init(string: stringURL ?? ""), options: SDWebImageOptions.refreshCached, context: nil, progress: { (receivedSize, expectedSize, targetURL) in
            progress?(receivedSize, expectedSize, targetURL)
        }) { (image, data, error, status) in
            completion(image, data, error, status)
        }
    }
    
}
