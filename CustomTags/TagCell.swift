//
//  TagCell.swift
//  CustomTags
//
//  Created by Wei Ran Wang on 2024/10/15.
//

import UIKit
///TODO: Need injection varibles
///Font, TextColor, Border Color, Border Width, Padding
///Each tag right Margin and Top Margin and Kerning

internal class TagCell: UICollectionViewCell {
    var tagLabel: PaddingLabel = {
        var tagLabel = PaddingLabel()
        tagLabel.padding = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        tagLabel.backgroundColor = UIColor.black
        tagLabel.textColor = .white
        tagLabel.font = UIFont(name: "PingFangTC-Light", size: 12)
        tagLabel.clipsToBounds = true
        return tagLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIs() {
        self.addSubview(tagLabel)
        let margin = contentView.layoutMarginsGuide
        tagLabel.lineBreakMode = .byTruncatingMiddle
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        tagLabel.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -6).isActive = true
        tagLabel.topAnchor.constraint(equalTo: margin.topAnchor, constant: 1).isActive = true
        tagLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        
        layoutIfNeeded()
    }
}
