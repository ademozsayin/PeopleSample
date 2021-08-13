//
//  PeopleTableViewCell.swift
//  PeopleDemo
//
//  Created by Adem Özsayın on 13.08.2021.
//

import UIKit

class PeopleTableViewCell:UITableViewCell {
 
    var personName = UILabel()
    var personId = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func commonInit() {
        self.backgroundColor = .white
        
        personName = UILabel()
        personName.translatesAutoresizingMaskIntoConstraints = false
//        personName.text = "aaa"
        self.addSubview(personName)
        
        personId = UILabel()
        personId.translatesAutoresizingMaskIntoConstraints = false
//        personId.text = "(13)"
        self.addSubview(personId)
        
        personName.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        personName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        personId.leadingAnchor.constraint(equalTo: personName.trailingAnchor,constant: 8).isActive = true
        personId.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setData(person: Person) {
        self.personName.text = person.fullName
        self.personId.text = "(\(person.id))"
    }
    
}

extension PeopleTableViewCell {
    static let identifier = "PeopleTableViewCell"
}
