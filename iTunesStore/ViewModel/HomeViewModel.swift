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

    let disposeBag = DisposeBag() // 메모리 누수 방지용 쓰레기통
    
    let actionRelay = PublishRelay<Action>() // 뷰에서 전달하는 액션이 들어오는 통로
    
    let stateRelay = BehaviorRelay<State>(value: State()) // 상태 데이터를 갖고 있으며 구독자한테 전달하는데, 아래의 Driver를 사용하기로 했다.
    
    var stateDriver: Driver<State> { // 뷰에서 얘를 구독해서 UI를 업데이트한다. Driver는 메인 스레드에서 동작하고, 에러를 방출하지 않아서 UI 바인딩에 적합한 RxCocoa 타입이다.
        stateRelay.asDriver()
    }
    
    init() {
        actionRelay // 뷰에서 .accept(case)가 호출되면 이 스트림에 이벤트가 들어간다.
            .flatMap { action in // 들어온 action 값을 바탕으로 새로운 Observable을 생성하고 다음 스트림에게 전달한다.
                switch action {
                case .fetchData:
                    let fetchSpring = NetworkService.shared.fetchMedia(term: "봄", mediaType: "music", limit: 5, to: Music.self)
                    let fetchSummer = NetworkService.shared.fetchMedia(term: "여름", mediaType: "music", limit: 50, to: Music.self)
                    let fetchAutumn = NetworkService.shared.fetchMedia(term: "가을", mediaType: "music", limit: 50, to: Music.self)
                    let fetchWinter = NetworkService.shared.fetchMedia(term: "겨울", mediaType: "music", limit: 50, to: Music.self)
                    return Observable.zip(fetchSpring, fetchSummer, fetchAutumn, fetchWinter) // 생성하는 옵저버블들을 모두 완료될 때까지 기다려서 결과를 하나의 튜플로 묶고,
                        .map { spring, summer, autumn, winter in
                            State(springMusics: spring, summerMusics: summer, autumnMusics: autumn, winterMusics: winter)
                        } // 결과로 받은 [Music] 4개로 새 State 객체를 생성해서 Observable<State>로 반환하게 됨
                }
            }
            .bind(to: stateRelay) // 위에서 만든 걸 ViewModel의 stateRelay에 바인딩. 즉 여기까지, 새로운 상태가 들어오면 stateRelay가 값을 변경하고, stateDriver를 통해 뷰에 전달됨.
            .disposed(by: disposeBag) // 메모리 누수 방지를 위해 두는 코드
    }
    /// 뷰에서 .accept(.fetchData) 호출
    /// → actionRelay가 그 이벤트 방출
    /// → flatMap에서 네트워크 요청 4개 진행
    /// → zip으로 결과 병합
    /// → State 생성
    /// → bind로 stateRelay에 전달
    /// → stateDriver를 통해 뷰에서 상태 감지 & UI 업데이트
}
