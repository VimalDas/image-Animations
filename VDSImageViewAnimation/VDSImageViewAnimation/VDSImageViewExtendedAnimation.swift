//
//  ImageViewExtendedAnimation.swift
//  ExtendedAnimation
//
//  Created by Admin on 10/5/17.
//  Copyright © 2017 VimalDas. All rights reserved.
//

import UIKit
 
class VDSAnimation: NSObject {
    
    private var screenHeight = UIScreen.main.bounds.height
    private var screenWidth = UIScreen.main.bounds.width
    private var screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    private var parentView: UIView?
    private var parentImageView: UIImageView?
    private var parentCenter = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    private var parentImageViewCenter = CGPoint(x: 0, y: 0)
    private var parentImageViewSize = CGSize(width: 0, height: 0)
    private var storeSize: CGFloat = 0.0
    private var scroll: UIScrollView?
    private var panRange: CGFloat = 0.00
    
    private var imageViewZoomed: Bool = false
    private var sizeChanged: Bool = false
    private var scrollEnabled: Bool = false
    
    static let shared = VDSAnimation()
    
    private override init() {
        
    }
    
    fileprivate let animatedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    func setupAnimation(in mainView: UIView, imageView: UIImageView) {
            parentView = mainView
            setupScroll()
            addSingleTapGesture(imageView)
            addDoubleTapGesture()
            addpanGesture()
    }
    
    private func setupScroll() {
        scroll = UIScrollView(frame: CGRect(origin: .zero, size: screenSize))
        scroll?.delegate = self
        scroll?.bounces = true
        scroll?.contentSize = screenSize
        scroll?.backgroundColor = UIColor.black
        scroll?.isUserInteractionEnabled = true
        scroll?.minimumZoomScale = 1
        scroll?.zoomScale = 1
        scroll?.maximumZoomScale = 1
        scroll?.alpha = 0
    }
    
    private func animatedbackToNormal() {
        self.scroll?.removeFromSuperview()
        self.animatedImageView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            self.parentImageView?.frame.size = self.parentImageViewSize
            self.parentImageView?.center = self.parentImageViewCenter
            
        }) { (success) in
        }
        sizeChanged = false
    }
    
    private func forceZoomScrollAction() {
        if scrollEnabled {
            scroll?.minimumZoomScale = 1
            scroll?.maximumZoomScale = 5
            scroll?.setZoomScale(2, animated: true)
        } else {
            scroll?.minimumZoomScale = 1
            scroll?.maximumZoomScale = 1
            scroll?.setZoomScale(1, animated: true)
            UIView.animate(withDuration: 0.3) {
                    self.scroll?.bounds.origin = CGPoint.zero
            }
        }
    }
    
    private func addSingleTapGesture(_ imageView: UIImageView) {
        imageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.zoomAction(sender:)))
        singleTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(singleTap)
    }
    
    private func addDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forceZoomAction(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        animatedImageView.addGestureRecognizer(doubleTapGesture)
    }
    
    private func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToDismiss(sender:)))
        swipeGesture.direction = .down
        animatedImageView.addGestureRecognizer(swipeGesture)
    }
    
    private func addpanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipeDownToDismiss(sender:)))
        //        panGesture.minimumNumberOfTouches = 1
        animatedImageView.addGestureRecognizer(panGesture)
    }
    
    @objc private func swipeDownToDismiss(sender: UIPanGestureRecognizer) {
        if !scrollEnabled {
            if sender.state == .began || sender.state == .changed {
                let pan = sender.translation(in: animatedImageView).y
                animatedImageView.center.y += pan
                parentImageView?.center.y += pan
                sender.setTranslation(CGPoint.zero, in: animatedImageView)
                if animatedImageView.center.y > parentCenter.y + 10 || animatedImageView.center.y < parentCenter.y - 10 {
                    if !sizeChanged {
                        storeSize = animatedImageView.center.y
                        UIView.animate(withDuration: 0.3){
                            self.animatedImageView.frame.size = CGSize(width: (self.parentImageView!.image?.size.width)!/2, height: (self.parentImageView?.image?.size.height)!/2)
                            self.parentImageView?.frame.size = CGSize(width: (self.parentImageView?.image?.size.width)!/2, height: (self.parentImageView?.image?.size.height)!/2)
                            self.animatedImageView.center.x = self.parentCenter.x
                            self.parentImageView?.center.x = self.parentCenter.x
                            self.parentImageView?.center.y = self.storeSize
                            self.animatedImageView.center.y = self.storeSize
                        }
                        sizeChanged = true
                    }
                }
                panRange += pan
            } else {
                if animatedImageView.center.y > parentCenter.y + 100 || animatedImageView.center.y < parentCenter.y - 100 {
                    animatedbackToNormal()
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.animatedImageView.frame.size = CGSize(width: (self.parentImageView?.image?.size.width)!, height: (self.parentImageView?.image?.size.height)!)
                        self.parentImageView?.frame.size = CGSize(width: (self.parentImageView?.image?.size.width)!, height: (self.parentImageView?.image?.size.height)!)
                        self.parentImageView?.center = self.parentCenter
                        self.animatedImageView.center = self.parentCenter
                    }
                }
                sizeChanged = false
            }
        }
    }
    
    @objc private func swipeToDismiss(sender: UISwipeGestureRecognizer) {
        animatedbackToNormal()
    }
    
    @objc private func forceZoomAction(sender: UITapGestureRecognizer) {
        print("double tap")
        scrollEnabled = !scrollEnabled
        forceZoomScrollAction()

    }
    
    @objc private func zoomAction(sender: UITapGestureRecognizer) {
        if let imgView = sender.view as? UIImageView {
            if let image = imgView.image {
                animatedImageView.image = image
                animatedImageView.contentMode = imgView.contentMode
                parentImageView = imgView
                parentImageViewSize = imgView.frame.size
                parentImageViewCenter = imgView.center
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.parentImageView?.frame.size = (self.animatedImageView.image?.size)!
                    self.parentImageView?.center = self.parentCenter
                }) { (true) in
                    if let view = self.parentView {
                        self.scroll?.alpha = 0
                        view.addSubview(self.scroll!)
                        UIView.animate(withDuration: 0.3, animations: {
                            self.scroll?.alpha = 1
                        })
                        self.scroll?.addSubview(self.animatedImageView)
                        self.animatedImageView.centerXAnchor.constraint(equalTo: (self.scroll?.centerXAnchor)!).isActive = true
                        self.animatedImageView.centerYAnchor.constraint(equalTo: (self.scroll?.centerYAnchor)!).isActive = true
                    }
                }
            }
        }
    }
        
}
extension VDSAnimation : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return animatedImageView
    }
}
