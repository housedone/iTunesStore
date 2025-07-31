//
//  HomeViewModel.swift
//  iTunesStore
//
//  Created by 김우성 on 7/29/25.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel {
    struct State {
        var springMusics: [Music] = []
        var summerMusics: [Music] = []
        var autumnMusics: [Music] = []
        var winterMusics: [Music] = []
    }
    
    enum Action {
        case fetchData
    }
    let disposeBag = DisposeBag()
    
    let actionRelay = PublishRelay<Action>() // 얘가 뷰에서의 액션 신호를 받고, State에 보낸다?
    
    let stateRelay = BehaviorRelay<State>(value: State())
    
    init() {
        actionRelay
            .flatMap { action in
                switch action {
                case .fetchData:
                    let fetchSpring = NetworkService.shared.fetchMedia(term: "봄", mediaType: "music", to: Music.self)
                    let fetchSummer = NetworkService.shared.fetchMedia(term: "여름", mediaType: "music", to: Music.self)
                    let fetchAutumn = NetworkService.shared.fetchMedia(term: "가을", mediaType: "music", to: Music.self)
                    let fetchWinter = NetworkService.shared.fetchMedia(term: "겨울", mediaType: "music", to: Music.self)
                    return Observable.zip(fetchSpring, fetchSummer, fetchAutumn, fetchWinter)
                        .map { spring, summer, autumn, winter in
                            State(springMusics: spring, summerMusics: summer, autumnMusics: autumn, winterMusics: winter)
                        }
                }
            }
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
    }
}
