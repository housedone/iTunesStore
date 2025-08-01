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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        homeViewModel.actionRelay
            .accept(.fetchData)
        
        homeViewModel.musicsDriver
            .map { $0.springMusics }
            .drive(homeView.collectionView.rx.items(
                cellIdentifier: "BigCell",
                cellType: BigCell.self
            )) { row, music, cell in
                cell.configure(music: music)
            }
            .disposed(by: disposeBag)
    }
}

#Preview {
    HomeViewController()
}
