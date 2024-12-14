//
//  Extensions.swift
//  CustomTags
//
//  Created by Wei Ran Wang on 2024/10/15.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return Int(ceil(boundingBox.height))
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> Int {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return Int(ceil(boundingBox.width))
    }
}
