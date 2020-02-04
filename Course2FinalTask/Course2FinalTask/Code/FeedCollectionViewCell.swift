

import UIKit
import DataProvider

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameAndDateLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBAction func likeButtonAction(_ sender: Any) {
        
    }
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var constraintTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    
    weak var delegate : PostImageViewTappedDelegate?
    
    var imageBigLike: UIImageView!
    
    var idCurrent: Post.Identifier?
    
    var selectedAtIndex: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postImageView.contentMode = .scaleAspectFit
        
        imageBigLike = UIImageView(image: UIImage(named: "bigLike"))
        
        postImageView.addSubview(imageBigLike)
        
        
        imageBigLike.translatesAutoresizingMaskIntoConstraints = false
        imageBigLike.centerYAnchor.constraint(equalTo: postImageView.centerYAnchor).isActive = true
        imageBigLike.centerXAnchor.constraint(equalTo: postImageView.centerXAnchor).isActive = true
        imageBigLike.layer.opacity = 0
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: -4.0, bottom: 0.0, right: 0.0)
        
        constraintTextViewHeight.constant = self.descriptionTextView.contentSize.height + 10
    }
    
    func configure(with post: Post) {
        idCurrent = post.id
        avatarImageView.image = post.authorAvatar
        nameAndDateLabel.text = post.authorUsername
        postImageView.image = post.image
        if post.currentUserLikesThisPost {
            likeButtonOutlet.tintColor = .systemBlue
        } else {
            likeButtonOutlet.tintColor = .lightGray
        }
        
        let ratio = post.image.size.width / post.image.size.height
        let newHeight = 320 / ratio
        
        constraintImageHeight.constant = newHeight
        
        likesLabel.text = "Likes: " + String(post.likedByCount)
        dateLabel.text = dateToString(date: post.createdTime)
        descriptionTextView.text = post.description
        descriptionTextView.sizeToFit()
        descriptionTextView.isEditable = false
        
        postImageView.isUserInteractionEnabled = true
        
        let tapDouble = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        tapDouble.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tapDouble)
        
        setNeedsLayout()
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "'Today at' hh:mm:ss a"
        } else {
            formatter.dateFormat = "MMM dd, YYYY 'at' hh:mm:ss a"
        }
        return formatter.string(from: date)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let firstAnimDuration: TimeInterval = 0.1
        UIView.animate(withDuration: firstAnimDuration, delay: 0, options: [.curveLinear], animations: {
            
            self.imageBigLike.layer.opacity = 1
        }) { (completed) in
            
            let secondAnimDuration: TimeInterval = 0.3
            UIView.animate(withDuration: secondAnimDuration, delay: 0.2, options: [.curveEaseOut], animations: {
                
                self.imageBigLike.layer.opacity = 0
            })
            { (completed) in
                self.delegate?.postTapped(at: self.selectedAtIndex!)
            }
        }
    }
}


protocol FeedCollectionViewCellDelegate: AnyObject {
    func changeLikes(id: Post.Identifier)
}

protocol PostImageViewTappedDelegate: class {
    func postTapped(at index: IndexPath)
}
