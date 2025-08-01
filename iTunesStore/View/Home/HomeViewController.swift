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

    private let searchResultVC = SearchResultViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultVC)

    enum Section: Int, CaseIterable {
        case spring, summer, autumn, winter
        var title: String {
            switch self {
            case .spring: return "#봄 #Top5"
            case .summer: return "#여름"
            case .autumn: return "#가을"
            case .winter: return "#겨울"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupSearchController()
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

    private func setupSearchController() {
        navigationItem.title = "음악"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "영화, 팟캐스트 검색"

        navigationItem.searchController = searchController
        definesPresentationContext = true

        // 검색바 탭 시 SearchResultViewController 전환
        searchController.searchBar.rx.textDidBeginEditing
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.present(self.searchController, animated: true)
            })
            .disposed(by: disposeBag)
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
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as! HeaderView
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

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        searchResultVC.performSearch(query: query)
    }
}


#Preview {
    HomeViewController()
}
