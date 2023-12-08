//
//  UIViewController.swift
//  ToDoApp
//
//  Created by Мявкo on 8.12.23.
//

import UIKit

extension UIViewController {
    
    // MARK: - Method to make background blur on SuperView
    
    func backgroundBlur() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.01)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        return blurView
    }
    
    // MARK: - Method to close Popup with animation
    
    func closePopupWithAnimation(with duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.view.alpha = 0
        }, completion: { finished in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Method to remove blur background from superview
    
    func removeBackgroundBlur(_ blurView: UIVisualEffectView?, duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            blurView?.alpha = 0
        }, completion: { finished in
            blurView?.removeFromSuperview()
        })
    }
    
    // MARK: - Method to open Popup with blur background on superview

    func openingPopup(_ superviewController: CategoriesViewController) -> UIVisualEffectView {
        view.center = superviewController.view.center

        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        
        view.alpha = 0.0
        superviewController.present(self, animated: false) {
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 1.0
            }
        }
        
        return superviewController.backgroundBlur()
    }
}
