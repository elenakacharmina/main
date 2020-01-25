import UIKit
import DataProvider

class FeedCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    var feed: [Post] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = feedCollectionView.dequeueCell(of: FeedCollectionViewCell.self, for: indexPath)
        cell.configure(with: feed[indexPath.item])
        cell.likeButtonOutlet.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        cell.delegate = self
        cell.selectedAtIndex = indexPath
        
        view.layoutIfNeeded()
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = feedCollectionView?.collectionViewLayout as? CustomFlowLayout {
            layout.delegate = self
        }
        feed = DataProviders.shared.postsDataProvider.feed()
        
        feedCollectionView.register(cellType: FeedCollectionViewCell.self)
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedCollectionView.frame = view.frame
    }
    
    
    @objc func likeButtonTap(sender: UIButton){
        //        print("likeButton")
        if let indexPath = feedCollectionView?.indexPath(for: ((sender.superview?.superview) as! FeedCollectionViewCell)) {
            if !feed[indexPath.item].currentUserLikesThisPost {
                feed[indexPath.item].likedByCount += 1
                feed[indexPath.item].currentUserLikesThisPost = true
            } else {
                feed[indexPath.item].likedByCount -= 1
                feed[indexPath.item].currentUserLikesThisPost = false
            }
            feedCollectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16,
                            left: 0,
                            bottom: 0,
                            right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 32)
    }
    
}


extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type,
                                              nib: Bool = true) {
        
        let reuseIdentifier = String(describing: cellType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func register<View: UICollectionReusableView>(viewType: View.Type,
                                                  kind: String,
                                                  nib: Bool = true) {
        
        let reuseIdentifier = String(describing: viewType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib,
                     forSupplementaryViewOfKind: kind,
                     withReuseIdentifier: reuseIdentifier)
        } else {
            register(viewType,
                     forSupplementaryViewOfKind: kind,
                     withReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueCell<Cell: UICollectionViewCell>(of cellType: Cell.Type,
                                                 for indexPath: IndexPath) -> Cell {
        
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType),
                                   for: indexPath) as! Cell
    }
    
    func dequeueSupplementaryView<View: UICollectionReusableView>(of viewType: View.Type, kind: String, for indexPath: IndexPath) -> View {
        
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: String(describing: viewType),
                                                for: indexPath) as! View
    }
}

extension FeedCollectionViewController: CustomFlowLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let r = feed[indexPath.item].description.heightWithConstrainedWidth(width: 290, font: UIFont.systemFont(ofSize: 14))
        
        return 415 + r
    }
}

extension FeedCollectionViewController: FeedCollectionViewCellDelegate {
    func changeLikes(id: Post.Identifier) {
        var item = feed.first {element in
            if element.id == id {
                return true
            } else {
                return false
            }
            
        }
        item?.likedByCount += 1
    }
    
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
extension FeedCollectionViewController: PostImageViewTappedDelegate{
    func postTapped(at indexPath: IndexPath) {
        if !feed[indexPath.item].currentUserLikesThisPost {
            feed[indexPath.item].likedByCount += 1
            feed[indexPath.item].currentUserLikesThisPost = true
            feedCollectionView.reloadData()
        }
    }
}
