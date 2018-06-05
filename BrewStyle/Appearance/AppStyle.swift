//
//  AppStyle.swift
//  SwiftTabs
//
//  Created by Greg Dunn on 9/11/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//
enum ElementProperty {
	case BarTintColor
	case TintColor
	case BackgroundColor
	case HeaderColor
	case SubHeaderColor
	case ContainerColor
	case ContainerGradient
	case IdColor
	case IdDisabledColor
	case IdText
	case TitleColor
	case TitleCopy
	case HeaderCopy
	case SubHeaderCopy
	case BodyCopy
	case DomainColor
	case PrimaryRangeColor
	case SecondaryRangeColor
	case ValueColor
	case TickColor
	case TickValueColor
	
}

typealias ElementColor = [ElementProperty : UIColor]


enum AppColor : Int {

	case Black = 0x1F1F1F
	case Blue = 0x6A8E61//0xa7c5bd
		case BrightBlue = 0x23C9FF
		case DarkBlue = 0x55868c
		case LightBlue = 0xE1F0F2//0xADDBEA
		case OldBlue = 0x5AB7D5
		case NewBlue = 0x87BCDE
		case Slate = 0x61868E//0x93A29E//
		case LightSlate = 0xC1CAC7//0x94A39E
	case Brown = 0x816c5b//0xB8A888
	case Beige = 0xB8B8AB
		case LightBeige = 0xDADAD3
		case Brownish = 0xBDBBB0
		case LightBrown = 0xF8F8F7
		case Mud = 0xB5C2B7
	case Gray = 0x878787
		case DarkGray = 0x605B5B
		case LightGray = 0xD3D3D3
	case Green = 0x83A47A
	case BrightGreen = 0x6CAE75
	case Orange = 0xde733e
		case BrightOrange = 0xffb347
	case Purple = 0x785964//0x655f68
	case Red = 0xD55437//0xcf4647
	case White = 0xFFFFFF
	case Yellow = 0xdec692
		case BrightYellow = 0xFCD757
		case Gold = 0xB1740F
		case LightYellow = 0xF3EEBF
	
	case TagRed = 0x8f3b1b
	case TagOrange = 0xd57500
	case TagYellow = 0xdbca60
	case TagGreen = 0x404f24
	case TagTeal = 0xbdd09f
	case TagBlue = 0x4e6172
	case TagPurple = 0xa3adb8
	case TagBrown = 0x493829


	
	var color : UIColor {
		let red = CGFloat((rawValue & 0xFF0000) >> 16)
		let green = CGFloat((rawValue & 0x00FF00) >> 8)
		let blue = CGFloat(rawValue & 0x0000FF)
		return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
	}
	
	var cgColor : CGColor {
		return self.color.CGColor
	}
	
	func alpha(alpha: CGFloat) -> UIColor {
		return self.color.colorWithAlphaComponent(alpha)
	}
	

}

enum AppMargins : CGFloat {
	case small = 4
	case medium = 8
	case large = 16
	case xl = 24
	
	var margin : CGFloat {
		return rawValue
	}
	
	var negative : CGFloat {
		return -self.margin
	}
	
	var double : CGFloat {
		return self.margin * 2
	}
	
	var doubleNegative : CGFloat {
		return -self.double
	}
}


enum AppFonts : CGFloat {
	case pageTitle = 27
	case id = 24
	case title = 21
	case header = 19
	case subheader = 11
	case sectionHeader = 17
	case body = 14
	case val = 13
	
	case tick = 10
	
	var styled : UIFont {
		return UIFont(name: "Futura-CondensedMedium", size: self.rawValue)!
	}
	
	var font : UIFont {
		return UIFont.systemFontOfSize(self.rawValue)
	}

	var bold : UIFont {
		return UIFont.boldSystemFontOfSize(self.rawValue)
	}
	
	var italic : UIFont {
		return UIFont.italicSystemFontOfSize(self.rawValue)
	}
	
}

var AppStyle = AppStyle_BrownTown.self

struct AppStyle_HIG {
	static let NavigationBar : ElementColor = [.BarTintColor : AppColor.White.color,
		.TintColor    : AppColor.Red.color,
		.TitleCopy : AppColor.Black.color]
	static let SettingsMenu : ElementColor = [.BackgroundColor : AppColor.White.color,
		.HeaderColor:      UIColor.clearColor()]
	
	static let FilterMenu : ElementColor = [.BackgroundColor : AppColor.White.color,
		.HeaderColor:      UIColor.clearColor()]
	
	static let CollectionView : ElementColor = [.BackgroundColor : AppColor.White.color]
	
	static let Id : ElementColor = [.IdColor: AppColor.LightGray.alpha(1.0),
		.IdDisabledColor: AppColor.LightGray.alpha(1.0),
		.IdText: AppColor.Black.color]
	
	static let Range : ElementColor = [.DomainColor: AppColor.LightGray.alpha(0.3),
		.PrimaryRangeColor:AppColor.Red.color,
		.SecondaryRangeColor: AppColor.DarkBlue.color,
		.TitleColor: AppColor.Black.color,
		.ValueColor: AppColor.Black.color,
		.TickColor: AppColor.Gray.alpha(0.3),
		.TickValueColor: AppColor.Gray.alpha(0.6)]
	
	static let CategoryListCell : ElementColor = [.BackgroundColor:   AppColor.White.color,
		.ContainerColor:    AppColor.White.color,
		.ContainerGradient: AppColor.White.color]
	static let SubCategoryListCell : ElementColor = [.BackgroundColor:   AppColor.White.color,
		.ContainerColor:    AppColor.White.color,
		.ContainerGradient: AppColor.White.color]
	static let SubCategoryDetailHeader : ElementColor = [.BackgroundColor:   AppColor.White.color,
		.ContainerGradient: AppColor.White.color,
		.TitleColor :       AppColor.Red.color,
		.SubHeaderColor :   AppColor.DarkBlue.color]
	static let Text : ElementColor = [.HeaderCopy: AppColor.Black.color,
		.SubHeaderCopy: AppColor.DarkGray.color,
		.BodyCopy: AppColor.Black.color]
	
	
}

struct AppStyle_BrownTown {
	static let NavigationBar : ElementColor = [.BarTintColor : AppColor.LightBrown.color,
		.TintColor    : AppColor.Red.color,
		.TitleCopy : AppColor.Black.color]
	static let SettingsMenu : ElementColor = [.BackgroundColor : AppColor.White.color,
		.HeaderColor:      UIColor.clearColor()]
	
	static let FilterMenu : ElementColor = [.BackgroundColor : AppColor.Beige.color,
		.HeaderColor:      AppColor.LightBrown.color]
	
	static let CollectionView : ElementColor = [.BackgroundColor : AppColor.Beige.color]
	
	static let Id : ElementColor = [.IdColor: AppColor.TagBlue.color,
		.IdDisabledColor: AppColor.LightGray.alpha(1.0),
		.IdText: AppColor.Black.color]
	
	static let Range : ElementColor = [.DomainColor: AppColor.LightGray.alpha(0.3),
		.PrimaryRangeColor:AppColor.Orange.alpha(0.7),
		.SecondaryRangeColor: AppColor.Green.alpha(0.7),
		.TitleColor: AppColor.Black.color,
		.ValueColor: AppColor.Black.color,
		.TickColor: AppColor.Gray.alpha(0.3),
		.TickValueColor: AppColor.Gray.alpha(0.6)]
	
	static let CategoryListCell : ElementColor = [.BackgroundColor:   AppColor.LightGray.color,
		.ContainerColor:    AppColor.White.color,
		.ContainerGradient: AppColor.Beige.color]
	static let SubCategoryListCell : ElementColor = [.BackgroundColor:   AppColor.LightGray.color,
		.ContainerColor:    AppColor.White.color,
		.ContainerGradient: AppColor.Beige.color]
	static let SubCategoryDetailHeader : ElementColor = [.BackgroundColor:   AppColor.Beige.color,
		.ContainerGradient: AppColor.White.color,
		.TitleColor :       AppColor.Red.color,
		.SubHeaderColor :   AppColor.DarkBlue.color]
	static let Text : ElementColor = [.HeaderCopy: AppColor.Black.color,
		.SubHeaderCopy: AppColor.DarkGray.color,
		.BodyCopy: AppColor.Black.color]
	
	
}