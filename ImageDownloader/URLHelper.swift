//
//  URLHelper.swift
//  ImageDownloader
//
//  Created by Tak Liu on 2022-06-16.
//

import Foundation
import UIKit

class URLHelper {
    
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}
