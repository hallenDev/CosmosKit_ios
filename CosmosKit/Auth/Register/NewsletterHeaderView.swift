//
//  NewsletterHeaderView.swift
//  CosmosKit
//
//  Created by DK on 25.11.2022.
//  Copyright © 2022 Flat Circle. All rights reserved.
//

import Foundation

class NewsletterHeaderView: UITableViewHeaderFooterView, Themable {
    
    @IBOutlet weak var newsletterLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    func applyTheme(theme: Theme) {
        dividerView.backgroundColor = theme.accentColor
    }
}

