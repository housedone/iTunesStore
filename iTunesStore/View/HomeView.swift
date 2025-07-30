//
//  HomeView.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

import UIKit
import SnapKit
import Then

final class HomeView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "음악"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .label
        $0.textAlignment = .left
    }
    
    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.showsCancelButton = false
        $0.returnKeyType = .search
        $0.searchTextField.clearButtonMode = .whileEditing
        $0.placeholder = "영화, 팟캐스트 검색"
    }
    
//    private lazy var collectionView = UICollectionView.then {
//
//    }
    
    private let bigImageCell = BigCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(titleLabel)
        addSubview(searchBar)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(bigImageCell)
        bigImageCell.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(bigImageCell.snp.width).multipliedBy(0.8)
        }
    }
}
