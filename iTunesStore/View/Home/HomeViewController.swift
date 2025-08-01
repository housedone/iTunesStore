//
//  HomeViewController.swift
//  iTunesStore
//
//  Created by 김우성 on 7/28/25.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let homeViewModel = HomeViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Music>!
    private let disposeBag = DisposeBag()
    
    enum Section: Int, CaseIterable { // CaseIterable: 열거형에 allCases 프로퍼티 만들어 줌
        case spring, summer, autumn, winter
        var title: String {
            switch self {
            case .spring: return "#봄"
            case .summer: return "#여름"
            case .autumn: return "#가을"
            case .winter: return "#겨울"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeDataSource()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        homeView.collectionView.register(LittleCell.self, forCellWithReuseIdentifier: "LittleCell")
        homeView.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        homeView.collectionView.collectionViewLayout = homeView.createCompositionalLayoutWithHeaders()
    }
    
    private func makeDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Music>(
            collectionView: homeView.collectionView
        ) { collectionView, indexPath, music in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .spring:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "BigCell", for: indexPath
                ) as! BigCell
                cell.configure(music: music)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "LittleCell", for: indexPath
                ) as! LittleCell
                cell.configure(music: music)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
            let section = Section(rawValue: indexPath.section)!
            header.setTitle(section.title)
            return header
        }
    }
    
    private func bind() {
        homeViewModel.actionRelay.accept(.fetchData)
        
        homeViewModel.stateDriver
            .drive(onNext: { [weak self] state in
                self?.applySnapshot(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(_ state: HomeViewModel.State) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Music>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(state.springMusics, toSection: .spring)
        snapshot.appendItems(state.summerMusics, toSection: .summer)
        snapshot.appendItems(state.autumnMusics, toSection: .autumn)
        snapshot.appendItems(state.winterMusics, toSection: .winter)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

#Preview {
    HomeViewController()
}
