//
//  EndofSingupViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/09.
//

import UIKit

class EndofSingupViewController: UIViewController {

    @IBOutlet weak var ProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.ProgressView.setProgress(1, animated: true)
        }
    }
    
    @IBAction func goLoginBtn(_ sender: Any) {
        guard let vcName = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") else {
            return
        }
        vcName.modalTransitionStyle = .coverVertical
        vcName.modalPresentationStyle = .fullScreen
        self.present(vcName, animated: true, completion: nil)
    }
    
}
