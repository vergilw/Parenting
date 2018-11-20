//
//  HomeCollectionViewLayout.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/20.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class HomeCollectionViewLayout: UICollectionViewLayout {

    let section0HeaderHeight: CGFloat = 25 + 8 + 18 + 32
    let section0FooterHeight: CGFloat = 64 + 42
    let item0Leading: CGFloat = UIConstants.Margin.leading
    let item0Tailing: CGFloat = UIConstants.Margin.trailing
    let item0InteritemSpaing: CGFloat = 12
    let item0LineSpacing: CGFloat = 32
    lazy var item0Width: CGFloat = (UIScreenWidth-item0Leading-item0Tailing-item0InteritemSpaing)/2
    lazy var item0Height: CGFloat = item0Width/16.0*9 + 12 + 52 + 8 + 20
    
    let section1HeaderHeight: CGFloat = 96
    lazy var item1Width: CGFloat = (UIScreenWidth-item0Leading-item0Tailing-item0InteritemSpaing)/2
    lazy var item1Height: CGFloat = item1Width/16.0*9 + 12 + 52
    
    fileprivate var layoutAttributeds: [UICollectionViewLayoutAttributes]?
    
    override func prepare() {
        layoutAttributeds = [UICollectionViewLayoutAttributes]()
        
        guard let sectionsCount = collectionView?.numberOfSections, sectionsCount > 0 else { return }
        
        for i in 0..<sectionsCount {
            guard let itemsCount = collectionView?.numberOfItems(inSection: i), itemsCount > 0 else { continue }
            
            if let headerLayoutAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: i)) {
                layoutAttributeds?.append(headerLayoutAttributes)
            }
            if let footerLayoutAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: i)) {
                layoutAttributeds?.append(footerLayoutAttributes)
            }
            
            for j in 0..<itemsCount {
                if let itemLayoutAttributes = layoutAttributesForItem(at: IndexPath(item: j, section: i)) {
                    layoutAttributeds?.append(itemLayoutAttributes)
                }
            }
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let kindLayoutAttributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if indexPath.section == 0 {
            if elementKind == UICollectionView.elementKindSectionHeader {
                kindLayoutAttributes.frame = CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: section0HeaderHeight))
                return kindLayoutAttributes
            } else if elementKind == UICollectionView.elementKindSectionFooter {
                kindLayoutAttributes.frame = CGRect(origin: CGPoint(x: 0, y: sectionHeight(0)-section0FooterHeight), size: CGSize(width: UIScreenWidth, height: section0FooterHeight))
                return kindLayoutAttributes
            }
        } else if indexPath.section == 1 {
            if elementKind == UICollectionView.elementKindSectionHeader {
                kindLayoutAttributes.frame = CGRect(origin: CGPoint(x: 0, y: sectionHeight(0)), size: CGSize(width: UIScreenWidth, height: section1HeaderHeight))
                return kindLayoutAttributes
            }
        }
        
        return nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let itemLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if indexPath.section == 0 {
            itemLayoutAttributes.frame = CGRect(origin: CGPoint(x: item0Leading+CGFloat(indexPath.row%2)*(item0Width+item0InteritemSpaing), y: section0HeaderHeight + CGFloat(indexPath.item/2)*(item0Height+item0LineSpacing)), size: CGSize(width: item0Width, height: item0Height))
            return itemLayoutAttributes
            
        } else if indexPath.section == 1 {
            itemLayoutAttributes.frame = CGRect(origin: CGPoint(x: item0Leading+CGFloat(indexPath.row%2)*(item0Width+item0InteritemSpaing), y: sectionHeight(0)+section1HeaderHeight), size: CGSize(width: item1Width, height: item1Height))
            return itemLayoutAttributes
        }
        
        return nil
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        if section == 0 {
            return section0HeaderHeight + item0Height * 2 + item0LineSpacing + section0FooterHeight
            
        } else if section == 1 {
            return section1HeaderHeight + item1Height
        }
        return 0
    }
    
    override var collectionViewContentSize: CGSize {
        
        let collectionHeight: CGFloat = section0HeaderHeight + item0Height * 2 + item0LineSpacing + section0FooterHeight + section1HeaderHeight + item1Height
        
        return CGSize(width: UIScreenWidth, height: collectionHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributeds
    }
}



