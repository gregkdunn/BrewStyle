import UIKit

public class Value2Cell: UITableViewCell, CellType {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
		backgroundColor = AppColor.White.alpha(0.2)
		textLabel?.font = AppFonts.sectionHeader.styled
		textLabel?.textColor = AppColor.DarkBlue.color
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
