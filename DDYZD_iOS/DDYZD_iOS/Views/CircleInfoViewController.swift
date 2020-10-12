//
//  CircleInfoViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/09.
//

import UIKit
import MarkdownView

class CircleInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var circleName : String = ""
    
    @IBOutlet weak var circleLogo: UIImageView!
    @IBOutlet weak var circleNameLable: UILabel!
    @IBOutlet weak var infoTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarLogo()
        circleLogo.layer.cornerRadius = circleLogo.frame.size.width/2.0
        
        circleNameLable.text = circleName
        
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.allowsSelection = false
    }
    
    @IBAction func goBackBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    func setNavigationBarLogo(){
        let imageView = UIImageView(image: UIImage(named: "icon"))
            imageView.contentMode = .scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)

            self.navigationItem.titleView = titleView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mdViewer

        return cell
    }
}
    


class mdViewer: UITableViewCell {
    @IBOutlet weak var mdView: MarkdownView!
}
