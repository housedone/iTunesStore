//
//  LittleCell.swift
//  iTunesStore
//
//  Created by 김우성 on 7/30/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

final class LittleCell: UICollectionViewCell {
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .label
        $0.numberOfLines = 1
    }
    
    private let artistLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 1
    }
    
    private lazy var textStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel]).then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(textStackView)
        
        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.leading.centerY.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    func configure(music: Music) {
        titleLabel.text = music.title
        artistLabel.text = music.subtitle
        if let urlString = music.imageUrl, let url = URL(string: urlString) {
            thumbnailImageView.kf.setImage(with: url)
        } else {
            thumbnailImageView.image = UIImage(systemName: "music.note")
        }
    }
}

extension LittleCell {
    func configure(mediaItem: MediaItem, showMediaType: Bool = false) {
        titleLabel.text = mediaItem.title
        artistLabel.text = showMediaType ? "[\(mediaItem is Movie ? "영화" : "팟캐스트")] \(mediaItem.subtitle)" : mediaItem.subtitle

        if let urlString = mediaItem.imageUrl, let url = URL(string: urlString) {
            thumbnailImageView.kf.setImage(with: url)
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
        }
    }
}
