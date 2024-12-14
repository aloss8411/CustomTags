//
//  View.swift
//  CustomTags
//
//  Created by Wei Ran Wang on 2024/10/15.
//

import UIKit

public protocol TagDelegate: AnyObject {
    
    var tags: [String] { get set }
    
    var textFont: UIFont { get set }
    
    var viewWidth: CGFloat { get set }
    
    var tagHeight: CGFloat { get set }
    
    var isTapEnable: Bool { get set }
    
    var tagtextColor: UIColor { get set }
    
    var tagBackgroundColor: UIColor { get set }
    
    var tagBorderColor: CGColor { get set }
    
    var tagBorderWidth: CGFloat { get set }
    
    var tagSelectBackgroundColor: UIColor { get set }
    
    var tagSelectBorderColor: CGColor { get set }
    
}

public class TagsUIView: UIView, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: TagDelegate?
    
    private var lastIndexPath: IndexPath?
    
    private var collectionView: UICollectionView!
    
    public var tags: [String] = []
    
    var isGestureActive: Bool = false
    
    private lazy var collectionH = collectionView.heightAnchor.constraint(equalToConstant: 0)
    
    var viewWidth: CGFloat = UIScreen.main.bounds.width - 48
    
    var font: UIFont = UIFont(name: "PingFangTC-Light", size: 12)!
    
    var cellHeight: CGFloat = 25
    
    var textColor: UIColor = .white
    
    var textBackgroundColor: UIColor = .black
    
    var selectTextColor: UIColor = .white
    
    var selectTextBackgroundColor: UIColor = .black
    
    var borderColor: UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView() {
        let layout = TagCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionH.isActive = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: NSStringFromClass(TagCell.self))
        
        self.layoutIfNeeded()
    }
    
    func update(onComplete: @escaping(CGFloat) -> Void) {
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            if !self.tags.isEmpty {
                self.collectionView.reloadData()
                onComplete(self.collectionView.contentSize.height)
            } else {
                onComplete(0)
            }
        }
    }
}

extension TagsUIView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TagCell.self), for: indexPath) as? TagCell else {
            fatalError()
        }
        cell.backgroundColor = .clear
        cell.tagLabel.text = tags[indexPath.row]
        cell.tagLabel.layer.borderColor = delegate?.tagBorderColor ?? UIColor.clear.cgColor
        cell.tagLabel.layer.borderWidth = delegate?.tagBorderWidth ?? 1
        cell.tagLabel.font = delegate?.textFont ?? .systemFont(ofSize: 12)
        cell.tagLabel.textColor = delegate?.tagtextColor ?? .white
        cell.tagLabel.backgroundColor = delegate?.tagBackgroundColor ?? .clear
        cell.tagLabel.sizeToFit()
        cell.tagLabel.layer.cornerRadius = (cell.tagLabel.frame.height + 8) / 2
        
        cell.layoutIfNeeded()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = tags[indexPath.row].width(withConstrainedHeight: delegate?.tagHeight ?? UIScreen.main.bounds.width, font: font)
        
        if (Int(self.delegate?.viewWidth ?? UIScreen.main.bounds.width) - width - 20 - 6) > 0 {
            self.delegate?.viewWidth -= (CGFloat(width) + 20 + 6)
            return CGSize(width: CGFloat(width) + 20 + 6,
                          height: delegate?.tagHeight ?? UIScreen.main.bounds.width)
            
        } else if Int(self.delegate?.viewWidth ?? UIScreen.main.bounds.width) - width - 20 > 0 {
            self.delegate?.viewWidth = UIScreen.main.bounds.width - 48
            return CGSize(width: CGFloat(width) + 20, height: delegate?.tagHeight ?? 20)
            
        } else {
            return CGSize(width: CGFloat(width) + 20 + 6, height: delegate?.tagHeight ?? 20)
            
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isGestureActive {
            if let lastIndexPath = lastIndexPath {
                guard let cell = collectionView.cellForItem(at: lastIndexPath) as? TagCell else { return }
                cell.tagLabel.textColor = delegate?.tagtextColor ?? .white
                cell.tagLabel.backgroundColor = delegate?.tagSelectBackgroundColor ?? .clear
                self.lastIndexPath = nil
            }
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? TagCell else { return }
            cell.tagLabel.textColor = delegate?.tagtextColor ?? .white
            cell.tagLabel.backgroundColor = delegate?.tagBackgroundColor ?? .clear
            self.lastIndexPath = indexPath
        }
    }
}
