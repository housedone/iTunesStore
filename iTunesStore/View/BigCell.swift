//
//  BigCell.swift
//  iTunesStore
//
//  Created by 김우성 on 7/30/25.
//

import UIKit

final class BigCell: UICollectionViewCell {
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .label
        $0.text = "Album Name"
    }
    
    private let subtitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .secondaryLabel
        $0.text = "Artist Name"
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        contentView.addSubview(imageView)
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(music: Music) {
        titleLabel.text = music.albumName
        subtitleLabel.text = music.artistName
//        imageView.image = music.artworkUrl100
    }
}
