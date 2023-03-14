//
//  VideoThumbnail.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/12.
//

/*
import Foundation
import UIKit
import AVFoundation

func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage {
    var asset :AVAsset = AVAsset.assetWithURL(url) as! AVAsset
    var assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    assetImgGenerate.requestedTimeToleranceAfter = kCMTimeZero;
    assetImgGenerate.requestedTimeToleranceBefore = kCMTimeZero;
    var error       : NSError? = nil
    var time        : CMTime = CMTimeMakeWithSeconds(fromTime, 600)
    var img         : CGImageRef = assetImgGenerate.copyCGImageAtTime(time, actualTime: nil, error: &error)
    var frameImg    : UIImage = UIImage(CGImage: img)!
    return frameImg
}
 
 
*/
