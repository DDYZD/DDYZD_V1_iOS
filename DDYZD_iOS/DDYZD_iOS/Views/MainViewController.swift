//
//  MainViewController.swift
//  DDYZD_iOS
//
//  Created by 김수완 on 2020/10/07.
//

import UIKit

let imageArray : [String] = ["pangAD","pangLogo","pangBack","icon","NextBtn"]

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavigationBarLogo()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    var circleNum : Int = 17
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("전체")
            circleNum = 17
            collectionView.reloadData()
        case 1:
            print("웹")
            circleNum = 10
            collectionView.reloadData()
        case 2:
            print("앱")
            circleNum = 4
            collectionView.reloadData()
        case 3:
            print("임베")
            circleNum = 3
            collectionView.reloadData()
        case 4:
            print("기타")
            circleNum = 4
            collectionView.reloadData()
        default:
            print("ERROR")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return circleNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "circleCell", for: indexPath) as! circleCell
        
        cell.circleLogo.image = UIImage(named: "pangLogo")
        cell.circleName.text = "PANG"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableView", for: indexPath) as? reusableView
            headerView?.adPageView.numberOfPages = 5
            headerView?.adImageView.image = UIImage(named: imageArray[headerView!.adPageView.currentPage])
            return headerView!
        default:
            assert(false, "ERROR")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        performSegue(withIdentifier: "goCircleInfoVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCircleInfoVC" {
            if let destinationVC = segue.destination as? UINavigationController,
               let ChildVC = destinationVC.viewControllers.first as? CircleInfoViewController{
                ChildVC.circleName = "PANG"
            }
        }
    }
    
    func setNavigationBarLogo(){
        let imageView = UIImageView(image: UIImage(named: "icon"))
            imageView.contentMode = .scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)

            self.navigationItem.titleView = titleView
    }
    
    // 여백
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets{
        let inset = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
        return inset
    }
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellWithd = collectionView.frame.width / 3 - 30
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
    }

    //위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

}

class reusableView : UICollectionReusableView {
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var adPageView: UIPageControl!
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        self.adImageView.image = UIImage(named: imageArray[adPageView.currentPage])
        }
}

class circleCell : UICollectionViewCell {
    @IBOutlet weak var circleLogo: UIImageView!
    @IBOutlet weak var circleName: UILabel!
}
