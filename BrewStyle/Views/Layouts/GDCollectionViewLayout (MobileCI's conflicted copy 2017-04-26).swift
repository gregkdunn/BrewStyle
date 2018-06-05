//
//  GDCollectionViewLayout.swift
//  BrewStyle
//
//  Created by Greg Dunn on 5/29/15.
//  Copyright (c) 2015 Greg K Dunn. All rights reserved.
//

class GDCollectionViewLayout : UICollectionViewFlowLayout {
	
	override init() {
		super.init()
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		print("coder.init()")
		commonInit()
	}
	
	func commonInit () {
		self.scrollDirection = .Vertical
		self.minimumInteritemSpacing = 0
		self.minimumLineSpacing = 0
		self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
	}
/*
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let superAttributes = super.layoutAttributesForElementsInRect(rect)
		var newAttributes : Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
		if let attributes = superAttributes {
			for attribute : UICollectionViewLayoutAttributes in attributes {
				print("\(attribute.indexPath.section)/\(attribute.indexPath.item) total >>> \(attribute.frame.origin.x + attribute.frame.size.width) of \(self.collectionViewContentSize().width -  (self.sectionInset.left + self.sectionInset.right))")
				
				if (attribute.frame.origin.x + attribute.frame.size.width) <= (self.collectionViewContentSize().width -  (self.sectionInset.left + self.sectionInset.right))  {
					newAttributes.append(attribute)
				}
			}
			//print("layouts newish")
			//print(newAttributes)
			return newAttributes
		}
		print("old busted layouts")
		return superAttributes
	}

	
	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
		
		print("layoutFor \(indexPath.row)")
		print(attributes)
		print("----------------------")
		
		return attributes
	}
		
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		let superBool = super.shouldInvalidateLayoutForBoundsChange(newBounds)
		
		let oldBounds = self.collectionView!.bounds
		if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
			return superBool
		}
		return false
	}
*/
}