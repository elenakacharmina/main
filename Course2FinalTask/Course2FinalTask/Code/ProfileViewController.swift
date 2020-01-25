

import UIKit
import DataProvider

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    let currentUser = DataProviders.shared.usersDataProvider.currentUser()
    
    var followers: [User]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followers = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: self.currentUser.id)
        
        avatarImageView.image =  currentUser.avatar
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        nameLabel.text = currentUser.fullName
        followersButton.setTitle("Followers: " + String(currentUser.followedByCount), for: .normal)
        followingButton.setTitle("Following: " + String(currentUser.followsCount), for: .normal)
        self.navigationItem.title = currentUser.username
    }
}


//extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//
//    // --MARK: CollectionViewDelegate Methods
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return currentUser
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
