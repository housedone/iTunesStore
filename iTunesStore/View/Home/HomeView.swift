//
//  HomeView.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

import SnapKit
import Then
import UIKit

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

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayoutWithHeaders()
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.register(BigCell.self, forCellWithReuseIdentifier: "BigCell")
        $0.register(LittleCell.self, forCellWithReuseIdentifier: "LittleCell")
        $0.register(HeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HeaderView.reuseIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(collectionView)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func createCompositionalLayoutWithHeaders() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        config.interSectionSpacing = 20

        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = HomeViewController.Section(rawValue: sectionIndex) else {
                return nil
            }

            switch section {
            case .spring:
                return self.makeSpringSection()
            default:
                return self.makeDefaultSection()
            }
        }, configuration: config)
    }

    private func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    private func makeSpringSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(300),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // 페이징 활성화!
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 10)
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [createHeaderItem()]
        section.visibleItemsInvalidationHandler = { _, _, _ in } // 깜빡임 방지
        return section
    }

    private func makeDefaultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(250)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitem: item,
            count: 4
        )
        verticalGroup.interItemSpacing = .fixed(12)

        let outerGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(300),
            heightDimension: .estimated(250)
        )
        let outerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: outerGroupSize,
            subitems: [verticalGroup]
        )

        let section = NSCollectionLayoutSection(group: outerGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [createHeaderItem()]
        return section
    }
}
