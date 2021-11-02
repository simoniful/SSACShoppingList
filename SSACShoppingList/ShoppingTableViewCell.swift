//
//  ShoppingTableViewCell.swift
//  SSACShoppingList
//
//  Created by Sang hun Lee on 2021/11/02.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var checkboxAction : (() -> ())?
    var favoriteBtnAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkbox.addTarget(self, action: #selector(checkboxClicked), for: .touchUpInside)
        self.favoriteBtn.addTarget(self, action: #selector(favoriteBtnClicked), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkboxClicked(_ sender: UIButton) {
        checkboxAction?()
    }
    
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        favoriteBtnAction?()
    }
}
