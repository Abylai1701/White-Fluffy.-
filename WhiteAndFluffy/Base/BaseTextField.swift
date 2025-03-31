//
//  BaseTextField.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 30.03.2025.
//

import Foundation
import UIKit

class BaseTextField: UITextField {
    
    // MARK: - Properties
    lazy var imageProfile: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var rightImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        text = ""
        textColor = .black
        font = .systemFont(ofSize: 16)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
        autocorrectionType = .no
        
        // Left padding
        let space = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 0))
        leftView = space
        leftViewMode = .always
        
        // Add subviews
        addSubview(imageProfile)
        addSubview(rightImage)
        addSubview(actionButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Profile image constraints
            imageProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            imageProfile.widthAnchor.constraint(equalToConstant: 20),
            imageProfile.heightAnchor.constraint(equalToConstant: 20),
            
            // Right image constraints
            rightImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            rightImage.widthAnchor.constraint(equalToConstant: 20),
            rightImage.heightAnchor.constraint(equalToConstant: 20),
            
            // Action button constraints
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
