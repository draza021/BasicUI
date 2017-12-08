//
//  RatingControl.swift
//  BasicUI
//
//  Created by Drago on 12/8/17.
//  Copyright © 2017 nsiddevelopment. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button : UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button \(button) is not in the Rating buttons array: \(ratingButtons)")
        }
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        if selectedRating == rating {
            // If the selected rating represents the current rating, reset the rating to 0
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
        
        
    }
    
    
    //MARK: Private methods
    private func setupButtons() {
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlitedStar = UIImage(named: "highlitedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        for index in 0..<starCount {
            
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlitedStar, for: .highlighted)
            button.setImage(highlitedStar, for: [.highlighted, .selected])
            
            
            // Add button constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Add accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating."
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add new button to the rating buttons array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for(index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than a rating, that button should be selected
            button.isSelected = index < rating
            
            // Set the hint String for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value String
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) start set."
            }
            
            // Assign the hint String and value String
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
    }
    
    
    
    
}
