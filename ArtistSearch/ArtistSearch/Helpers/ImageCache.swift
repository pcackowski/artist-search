//
//  ImageCache.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 06/10/2021.
//

import UIKit
import Combine
import SwiftUI

class ImageCache: NSObject {
    static let shared = ImageCache()
    let cache = NSCache<NSURL, UIImage>()

    func image(url: URL) -> UIImage? {
        if let image = cache.object(forKey: url as NSURL) {
            return image
        }
        fetch(url: url, completion: nil)
        return nil
    }
    
    func store(image: UIImage, url: URL) {
         self.cache.setObject(image, forKey: url as NSURL)

    }

    func fetch(url: URL, completion: ((UIImage?) -> Void)?) {
        if let image = cache.object(forKey: url as NSURL) {
            completion?(image)
            return
        }
//        (NetworkService.shared.networkOperation(url: url) as ImageNetworkOperation).start() { operation in
//            if let image = operation.image {
//                self.cache.setObject(image, forKey: url as NSURL)
//                completion?(image)
//                return
//            }
//            completion?(nil)
//        }
    }
}
