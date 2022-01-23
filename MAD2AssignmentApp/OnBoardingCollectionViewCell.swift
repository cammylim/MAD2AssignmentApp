//
//  OnBoardingCollectionViewCell.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 23/1/22.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnBoardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideDescLabel: UILabel!
    
    func setup(_ slide: OnBoardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescLabel.text = slide.description
    }
}
