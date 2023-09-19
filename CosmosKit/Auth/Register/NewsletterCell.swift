//
//  NewsletterCell.swift
//  CosmosKit
//
//  Created by DK on 25.11.2022.
//  Copyright © 2022 Flat Circle. All rights reserved.
//

import Foundation

class NewsletterCell: UITableViewCell, Themable {
   
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var letterView: UIView!
    @IBOutlet weak var checkbox: CheckboxSwift!
   
    override func awakeFromNib() {
        letterView.layer.cornerRadius = 8
        letterView.clipsToBounds = true
        checkbox.checkmarkStyle = .tick
    }

    func applyTheme(theme: Theme) {
        checkbox.checkedBorderColor = theme.accentColor
        checkbox.uncheckedBorderColor = theme.accentColor
        checkbox.checkmarkColor = theme.accentColor
    }
}
