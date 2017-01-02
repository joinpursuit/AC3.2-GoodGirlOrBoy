//
//  BehaviorEventTableViewCell.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Tom Seymour on 1/2/17.
//  Copyright © 2017 C4Q-3.2. All rights reserved.
//

import UIKit

class BehaviorEventTableViewCell: UITableViewCell {
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var dateLabel = UILabel()
    var emojiLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
        setConstarints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 20.0)
        titleLabel.numberOfLines = 0
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont(name: emojiLabel.font.fontName, size: 30.0)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: descriptionLabel.font.fontName, size: 16.0)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: dateLabel.font.fontName, size: 14.0)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(emojiLabel)
    }
    
    func setConstarints() {
        _ = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: emojiLabel.leadingAnchor, constant: -8.0),
            titleLabel.bottomAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            emojiLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -8.0),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40.0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            dateLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8.0),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
            ].map { $0.isActive = true }
    }
}
