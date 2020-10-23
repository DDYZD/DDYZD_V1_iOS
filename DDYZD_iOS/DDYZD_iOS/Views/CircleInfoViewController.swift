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

        setNavigationBar()
        circleLogo.layer.cornerRadius = circleLogo.frame.size.width/2.0
        
        circleNameLable.text = circleName
        
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.allowsSelection = false
    }
    
    @IBAction func goMenu(_ sender: Any) {
        performSegue(withIdentifier: "goMenuVC", sender: nil)
    }
    func setNavigationBar(){
        let imageView = UIImageView(image: UIImage(named: "icon"))
            imageView.contentMode = .scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)

            self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.tintColor = .lightGray
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mdViewer
        
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://raw.githubusercontent.com/matteocrippa/awesome-swift/master/README.md")!
        let task = session.dataTask(with: url) { [weak cell] data, _, _ in
          let str = String(data: data!, encoding: String.Encoding.utf8)
          DispatchQueue.main.async {
            
          }
        }
        task.resume()

        return cell
    }
}
     


class mdViewer: UITableViewCell {
    @IBOutlet weak var mdView: MarkdownView!
    
}
