//
//  OnBoardingViewController.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 23/1/22.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnBoardingSlide] = []
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
            OnBoardingSlide(title: "Mood of the Day", description: "Choose a mood every day to fill up your calendar with the colors of the sunset.", image: UIImage(named: "feature-1.svg")!),
            OnBoardingSlide(title: "Snaps of Memories", description: "Save a glimpse of those fond and precious moments.", image: UIImage(named: "feature-2.svg")!),
            OnBoardingSlide(title: "What a Day", description: "Keep in a reccord of the activities that you have taken part of.", image: UIImage(named: "feature-3.svg")!)
        ]
    }

    @IBAction func nextBtnTap(_ sender: Any) {
        if (currentPage == slides.count - 1) {
            let controller = storyboard?.instantiateViewController(identifier: "Login") as! UIViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}


extension UIFont {
    static func BalsamiqSansRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "BalsamiqSans-Regular", size: size)
    }
}
