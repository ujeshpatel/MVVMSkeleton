//
//  UserTableViewCell.swift
//  DemoAPICall
//
//  Created by Ujesh Patel on 16/04/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    func configure(with user: User) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        emailLabel.text = user.email
        
        if let url = URL(string: user.avatar) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        avatarImageView.image = nil
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.avatarImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
}
