import UIKit

public class Value2Cell: UITableViewCell, CellType {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
		backgroundColor = AppColor.Beige.alpha(0.8)
		textLabel?.font = UIFont(name: "Futura-CondensedMedium", size: 15)
		textLabel?.textColor = AppColor.DarkBlue.color
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
