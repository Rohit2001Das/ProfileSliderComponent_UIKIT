//
//  ViewController.swift
//  ProfileSliderUIkit
//
//  Created by ROHIT DAS on 30/04/24.
    //
import UIKit

class ProfileSliderViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
       
        viewModel.loadProfiles { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
      
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(600))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ProfileSliderViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfProfiles
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath)
        
        // Retrieve the profile for the current index path
        
        if  let profile = viewModel.profile(at: indexPath.item){
            
            let imageView: UIImageView
            
            if let existingImageView = cell.contentView.subviews.compactMap({ $0 as? UIImageView }).first {
                
                // Reuse existing image view
                imageView = existingImageView
                
            } else {
                // Create new image view
                imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 20
                cell.contentView.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                    
                ])
            }
        
            // Load profile image asynchronously from URL
            
            imageView.loadImage(from: profile.profileImageURL, placeholder: UIImage(named: "placeholder"))
            
            // Button Configuration
            
            let buttonWidth: CGFloat = 60
            
            let buttonSpacing: CGFloat = 30
            
            let totalButtonWidth = CGFloat(4) * buttonWidth + CGFloat(3) * buttonSpacing
            
            let buttonX = (cell.contentView.bounds.width - totalButtonWidth) / 2
            
            let buttonY = cell.contentView.bounds.height - buttonWidth - buttonSpacing
            
            let buttonTitles = ["Send Interest", "Shortlist", "Chat", "Ignore"]
            
            let buttonImages = [
                
                UIImage(systemName: "envelope"),
                UIImage(systemName: "star.fill"),
                UIImage(systemName: "message"),
                UIImage(systemName: "x.circle"),
                
            ]
            
            for (index, title) in buttonTitles.enumerated() {
                
                let button = UIButton(type: .system)
                button.frame = CGRect(x: buttonX + CGFloat(index) * (buttonWidth + buttonSpacing), y: buttonY, width: buttonWidth, height: buttonWidth)
                button.setImage(buttonImages[index], for: .normal)
                button.setTitle(title, for: .normal)
    
                
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.titleLabel?.numberOfLines = 0
                button.tintColor = .white
                
                
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: buttonWidth * 0.5, right: 0)
                button.titleEdgeInsets = UIEdgeInsets(top: buttonWidth * 0.5, left: -buttonWidth * 0.5, bottom: 0, right: 0)
                
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                button.tag = index
                
                button.layer.borderColor = UIColor.white.cgColor
                
                cell.contentView.addSubview(button)
                
            }
            // Profile Info Stack View
            
            let infoStackView: UIStackView
            
            if let existingStackView = cell.contentView.subviews.compactMap({ $0 as? UIStackView }).first {
                
                // Reuse existing stackview
                infoStackView = existingStackView
                
            } else {
                
                // Create new stack view
                infoStackView = UIStackView()
                infoStackView.axis = .vertical
                infoStackView.alignment = .leading
                infoStackView.spacing = 10
                infoStackView.backgroundColor = UIColor(white: 0, alpha: 0.8)
                infoStackView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(infoStackView)
            
                NSLayoutConstraint.activate([
                    infoStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                    infoStackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -150)
                ])
            }
        
            // Clear existing arranged subviews in infoStackView
            
            infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Label 1: Name and Age
            
            let nameLabel = UILabel()
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.textColor = .white
            nameLabel.text = "\(profile.name), \(profile.age ?? 0)" 
            infoStackView.addArrangedSubview(nameLabel)
            
            // Label 2: Height
            
            let heightLabel = UILabel()
            heightLabel.font = UIFont.systemFont(ofSize: 16)
            heightLabel.textColor = .white
            heightLabel.text = profile.height
            infoStackView.addArrangedSubview(heightLabel)
            
            // Label 3: Profession
            let professionLogo = UIImageView(image: UIImage(systemName: "briefcase.fill"))
            professionLogo.tintColor = .white
            
            let professionLabel = UILabel()
            professionLabel.font = UIFont.systemFont(ofSize: 16)
            professionLabel.textColor = .white
            professionLabel.text = profile.profession
            
            let professionStackView = UIStackView(arrangedSubviews: [professionLogo, professionLabel])
            professionStackView.axis = .horizontal
            professionStackView.spacing = 6
            infoStackView.addArrangedSubview(professionStackView)
            
            // Label 4: Degree
            let degreeLogo = UIImageView(image: UIImage(systemName: "graduationcap"))
            degreeLogo.tintColor = .white
            
            let degreeLabel = UILabel()
            degreeLabel.font = UIFont.systemFont(ofSize: 16)
            degreeLabel.textColor = .white
            degreeLabel.text = profile.degree
        
            let degreeStackView = UIStackView(arrangedSubviews: [degreeLogo, degreeLabel])
            degreeStackView.axis = .horizontal
            degreeStackView.spacing = 6
            infoStackView.addArrangedSubview(degreeStackView)
        }
        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let buttonTitles = ["Send Interest", "Shortlist", "Chat", "Ignore"]
        let selectedTitle = buttonTitles[sender.tag]
        
        print("Button tapped: \(selectedTitle)")
        
        switch selectedTitle {
        case "Send Interest":
            break
            
        case "Shortlist":
            break
            
        case "Chat":
            break
            
        case "Ignore":
            break
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
