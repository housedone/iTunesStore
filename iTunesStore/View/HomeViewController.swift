//
//  HomeViewController.swift
//  iTunesStore
//
//  Created by 김우성 on 7/28/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

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
            .subscribe(onNext: {state in print(state)}
        )
        
        
        
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
    
//    private func networkTest() {
//        NetworkService.shared
//            .fetchMedia(term: "봄", mediaType: "music")
//            .subscribe(
//                onNext: { (results: [Music]) in
//                    print("성공: \(results)")
//                },
//                onError: { error in
//                    print("에러 발생: \(error)")
//                },
//                onCompleted: {
//                    print("스트림 완료")
//                },
//                onDisposed: {
//                    print("스트림 Disposed")
//                }
//            )
//            .disposed(by: disposeBag)
//    }
}

#Preview {
    HomeViewController()
}
