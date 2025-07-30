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

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
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
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func bind() {
        
    }
    
    private func networkTest() {
        NetworkService.shared
            .fetchMedia(term: "봄", mediaType: "music")
            .subscribe(
                onNext: { (results: [Music]) in
                    print("성공: \(results)")
                },
                onError: { error in
                    print("에러 발생: \(error)")
                },
                onCompleted: {
                    print("스트림 완료")
                },
                onDisposed: {
                    print("스트림 Disposed")
                }
            )
            .disposed(by: disposeBag)
    }
}

#Preview {
    HomeViewController()
}
