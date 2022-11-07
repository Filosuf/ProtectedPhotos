//
//  SettingTableViewCell.swift
//  protectedPhotos
//
//  Created by 1234 on 29.09.2022.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    static let identifier = "SettingTableViewCell"

    var buttonAction: ((Bool) -> Void)?

    private let label: UILabel = {

        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let iconImage: UIImageView = {

        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()

    private let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action:  #selector(buttonPressed), for: .touchUpInside)
        return switchButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonPressed() {
        buttonAction?(switchButton.isOn)
    }

    func configure(with content: SettingCell) {
        label.text = content.label
        iconImage.image = content.icon
        if let isOn = content.switchIsOn {
            switchButton.isHidden = false
            switchButton.isOn = isOn
            selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            switchButton.isHidden = true
            selectionStyle = UITableViewCell.SelectionStyle.gray
        }
    }

    private func layout() {
        let basicSpaceInterval: CGFloat = 12
        [iconImage, label, switchButton].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: basicSpaceInterval),
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: basicSpaceInterval),

            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: basicSpaceInterval),
            label.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: basicSpaceInterval),

            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -basicSpaceInterval),
            switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

