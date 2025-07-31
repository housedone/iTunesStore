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
        
        homeViewModel.stateRelay
            .map { $0.springMusics }
            .bind(to: homeView.collectionView.rx.items(
                cellIdentifier: "BigCell",
                cellType: BigCell.self
            )) { row, music, cell in
                cell.configure(music: music)
            }
        //            .subscribe(onNext: { state in print(state) })
            .disposed(by: disposeBag)
        
        //        // 더미
        //        let dummy = [
        //            Music(trackName: "What Did I Miss?", artistName: "Drake", albumName: "What Did I Miss? - Single", artworkUrl100: nil),
        //            Music(trackName: "로보트", artistName: "서태지", albumName: "7th Issue", artworkUrl100: nil),
        //            Music(trackName: "MUD", artistName: "GIVĒON", albumName: "BELOVED", artworkUrl100: nil)
        //        ]
        //
        //        Observable.just(dummy)
        //            .bind(to: homeView.collectionView.rx.items(
        //                cellIdentifier: "BigCell",
        //                cellType: BigCell.self
        //            )) { row, music, cell in
        //                cell.configure(music: music)
        //            }
        //            .disposed(by: disposeBag)
    }
}

#Preview {
    HomeViewController()
}
