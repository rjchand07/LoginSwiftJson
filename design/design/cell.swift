//
//  cell.swift
//  design
//
//  Created by ekincare on 12/10/21.
//

import UIKit

class cell: UITableViewCell {

    
    @IBOutlet weak var imagecell: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releasedate: UILabel!
    
    static let identifier = "cell"
    static func nib() -> UINib {
        return UINib(nibName: "cell", bundle: nil)
    }
    public func configure(title: String, reldate: String, img: String) {
        movieTitle.text = title
        releasedate.text = reldate
        imagecell.load(urlString: img)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
