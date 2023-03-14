//
//  Image Resizer.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/25.
//

import Foundation
import UIKit
import AVFoundation

func ImageResizer(image: UIImage, max: Int) -> UIImage {
    
    let maxsize = CGSize(width: max, height: max)
    let avaiableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxsize))
    let targetSize = avaiableRect.size
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
    let resized = renderer.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: targetSize))
    }
    
    return resized
    
}
