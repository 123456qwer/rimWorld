//
//  String+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import UIKit
import Foundation

extension String {
    
    func width(usingFont font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: 10000, height: 10000)
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = (self as NSString).boundingRect(with: maxSize,
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: attributes,
                                                           context: nil)
        return ceil(boundingRect.width)
    }
}
