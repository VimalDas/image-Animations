//
//  ViewController.swift
//  VDSImageViewAnimation
//
//  Created by Admin on 10/10/17.
//  Copyright © 2017 VimalDas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        img1.layer.cornerRadius = 60
        img1.layer.masksToBounds = true
        
        VDSAnimation.shared.setupAnimation(in: self.view, imageView: img1)
        VDSAnimation.shared.setupAnimation(in: self.view, imageView: img2)
        VDSAnimation.shared.setupAnimation(in: self.view, imageView: img3)
        VDSAnimation.shared.setupAnimation(in: self.view, imageView: img4)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


