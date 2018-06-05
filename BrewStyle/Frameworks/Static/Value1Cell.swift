import UIKit

public class Value1Cell: UITableViewCell, CellType {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
		backgroundColor = AppColor.White.alpha(0.2)
		textLabel?.font = AppFonts.header.styled
		textLabel?.textColor = AppColor.DarkGray.color
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
