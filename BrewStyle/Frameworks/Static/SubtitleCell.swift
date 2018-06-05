import UIKit

public class SubtitleCell: UITableViewCell, CellType {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
		backgroundColor = UIColor.clearColor()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
