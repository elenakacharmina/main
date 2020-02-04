import UIKit
import DataProvider

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var currentUser: User!
    
    var followers: [User]? = []
    
    var posts: [Post]? = []
    
    var imageViews: [UIImageView]? = []
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: stackViewVertical)
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    lazy var stackViewVertical: [UIStackView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUser == nil {
            currentUser = DataProviders.shared.usersDataProvider.currentUser()
        }
        followers = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: self.currentUser.id)
        posts = DataProviders.shared.postsDataProvider.findPosts(by: currentUser.id)
        // var counter = 0
        var row = 0
        for counter in 0..<posts!.count {
            row = Int(counter / 3)
            
            if counter % 3 == 0 {
                stackViewVertical.append(UIStackView(arrangedSubviews: [UIImageView(image: posts![row * 3].image)]))
                stackViewVertical[row].axis = .horizontal
                stackViewVertical[row].translatesAutoresizingMaskIntoConstraints = false
                stackViewVertical[row].alignment = .fill
                stackViewVertical[row].distribution = .fillEqually
                stackViewVertical[row].widthAnchor.constraint(equalToConstant: 320).isActive = true
                stackViewVertical[row].heightAnchor.constraint(equalToConstant: 320/3).isActive = true
            } else {
                stackViewVertical[row].insertArrangedSubview(UIImageView(image: posts![counter].image), at: counter % 3)
            }
        }
        
        if posts!.count % 3 != 0 {
            stackViewVertical[row].insertArrangedSubview(UIImageView(), at: 2)
            if posts!.count % 3 == 1 {
                stackViewVertical[row].insertArrangedSubview(UIImageView(), at: 1)
            }
        }
        avatarImageView.image =  currentUser.avatar
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        nameLabel.text = currentUser.fullName
        followersButton.setTitle("Followers: " + String(currentUser.followedByCount), for: .normal)
        followingButton.setTitle("Following: " + String(currentUser.followsCount), for: .normal)
        self.navigationItem.title = currentUser.username
        
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let del = ceil(Double(posts!.count) / Double(3))
        var h = ((view.bounds.width) / 3) * CGFloat(del) + 86
        if h < view.bounds.height {
            h = view.bounds.height + 10
        }
        scrollView.scrollsToTop = true
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: h)
        scrollView.frame = view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followersSegue"
        {
            let vc = segue.destination as? FollowViewController
            vc?.userId = currentUser.id
            vc?.vcId = "Followers"
        } else {
            let vc = segue.destination as? FollowViewController
            vc?.userId = currentUser.id
            vc?.vcId = "Following"
        }
    }
}
