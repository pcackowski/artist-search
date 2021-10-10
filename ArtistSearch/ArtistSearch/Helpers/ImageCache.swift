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
    let cache = NSCache<NSString, UIImage>()

    func image(url: String) -> UIImage? {
        if let image = cache.object(forKey: url as NSString) {
            return image
        }
        return nil
    }
    
    func store(image: UIImage, url: String) {
         self.cache.setObject(image, forKey: url as NSString)
    }
    
    func clearAll() {
        cache.removeAllObjects()
    }    
    
}
