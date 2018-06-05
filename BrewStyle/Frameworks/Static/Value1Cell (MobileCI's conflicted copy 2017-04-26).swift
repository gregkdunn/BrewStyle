import UIKit

public class Value1Cell: UITableViewCell, CellType {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
		backgroundColor = AppColor.Beige.alpha(0.8)
		textLabel?.font = UIFont(name: "Futura-CondensedMedium", size: 17)
		textLabel?.textColor = AppColor.DarkGray.color
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
