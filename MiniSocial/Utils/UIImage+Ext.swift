//
//  UIImage+Ext.swift
//  MiniSocial
//
//  Created by Thao Truong on 03/12/2022.
//

import Foundation
import UIKit


extension UIImage {
    func compressImage(expectedSizeInMb: Double = 1) -> UIImage? {
        let sizeInBytes = Int(expectedSizeInMb * 1024 * 1024)
        var needCompress = true
        var imgData: Data?
        var compressingValue:CGFloat = 1.0

        while needCompress && compressingValue > 0 {
            if let data = jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }

        if let data = imgData, data.count <= sizeInBytes {
            return UIImage(data: data)
        }

        return nil
    }
}
