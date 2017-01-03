//
//  BehaviorEventTableViewCell.swift
//  AC3.2-GoodGirlOrBoy
//
//  Created by Ana Ma on 12/28/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class BehaviorEventTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.frame = CGRect(x: 180, y: 20.0, width: 150.0, height: 120.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Stamp"
        label.frame = CGRect(x: 180, y: 20.0, width: 150.0, height: 120.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var observedBehaviorLabel: UILabel = {
        let label = UILabel()
        label.text = "Observed Behavior"
        label.frame = CGRect(x: 180, y: 20.0, width: 150.0, height: 120.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var qualityOfBehaviorLabel: UILabel = {
        let label = UILabel()
        label.text = "Quality Of Behavior"
        label.frame = CGRect(x: 180, y: 20.0, width: 150.0, height: 120.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.nameLabel)
        self.addSubview(self.timeStampLabel)
        self.addSubview(self.qualityOfBehaviorLabel)
        self.addSubview(self.observedBehaviorLabel)
        setupConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.addSubview(self.nameLabel)
        self.addSubview(self.timeStampLabel)
        self.addSubview(self.qualityOfBehaviorLabel)
        self.addSubview(self.observedBehaviorLabel)
        setupConstraint()
    }

    func setupConstraint() {
        let _ = [
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            ].map{$0.isActive = true}
        let _ = [
            timeStampLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8.0),
            timeStampLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            timeStampLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
        ].map{$0.isActive = true}
        let _ = [
            observedBehaviorLabel.topAnchor.constraint(equalTo: self.timeStampLabel.bottomAnchor, constant: 8.0),
            observedBehaviorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            observedBehaviorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
        ].map{$0.isActive = true}
        let _ = [
            qualityOfBehaviorLabel.topAnchor.constraint(equalTo: self.observedBehaviorLabel.bottomAnchor, constant: 8.0),
            qualityOfBehaviorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            qualityOfBehaviorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            qualityOfBehaviorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0)
            ].map{$0.isActive = true}
    }
}
