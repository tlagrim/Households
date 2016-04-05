//
//  NewLogin.swift
//  Households
//
//  Created by TJ Lagrimas on 3/15/16.
//
//

import Foundation
class NewLogin: UIViewController {
    
    @IBOutlet var imageLoginBackground: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageTheLoginBackground: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("studylapse", ofType: "gif")!))
        self.imageLoginBackground.animatedImage = imageTheLoginBackground
        self.imageLoginBackground.contentMode = UIViewContentMode.ScaleAspectFill
        [self.view .addSubview(self.imageLoginBackground)]
    }
    
}