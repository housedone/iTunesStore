//
//  SearchResultViewModel.swift
//  iTunesStore
//
//  Created by 김우성 on 8/1/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum MediaTab { case all, movie, podcast }

final class SearchResultViewModel {
    
    // MARK: - State
    struct State {
        var queryText: String = ""
        var mediaItems: [MediaItemWrapper] = []
    }
    
    // MARK: - Action
    enum Action {
        case search(query: String, selectedTab: MediaTab)
    }
    
    // MARK: - Relays
    private let disposeBag = DisposeBag()
    
    let actionRelay = PublishRelay<Action>()
    let stateRelay = BehaviorRelay<State>(value: State())
    
    // MARK: - Output for View
    var stateDriver: Driver<State> {
        stateRelay.asDriver()
    }
    
    init() {
        actionRelay
            .flatMapLatest { [weak self] action -> Observable<State> in
                guard let self = self else { return .empty() }
                switch action {
                case let .search(query, tab):
                    let movieObservable = NetworkService.shared
                        .fetchMedia(term: query, mediaType: "movie", limit: 10, to: Movie.self)
                        .map { $0.map { MediaItemWrapper(item: $0, mediaType: "영화") } }
                        .catchAndReturn([])

                    let podcastObservable = NetworkService.shared
                        .fetchMedia(term: query, mediaType: "podcast", limit: 10, to: Podcast.self)
                        .map { $0.map { MediaItemWrapper(item: $0, mediaType: "팟캐스트") } }
                        .catchAndReturn([])

                    return Observable.zip(movieObservable, podcastObservable)
                        .map { movieItems, podcastItems -> State in
                            let combined: [MediaItemWrapper]
                            switch tab {
                            case .all: combined = podcastItems + movieItems
                            case .movie: combined = movieItems
                            case .podcast: combined = podcastItems
                            }
                            return State(queryText: query, mediaItems: combined)
                        }
                }
            }
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
    }
}
