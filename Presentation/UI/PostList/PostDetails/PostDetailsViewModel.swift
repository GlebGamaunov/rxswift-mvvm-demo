//
//  PostDetailsViewModel.swift
//  Application
//
//  Created by Dino Catalinac on 14/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxCocoa
import Domain

// sourcery: injectable
class PostDetailsViewModel {
    private let getPostByIdUseCase: GetPostByIdUseCase
    private let mapper: PostDetailsViewDataMapper
    
    init(getPostByIdUseCase: GetPostByIdUseCase, mapper: PostDetailsViewDataMapper) {
        self.getPostByIdUseCase = getPostByIdUseCase
        self.mapper = mapper
    }
}

// Binding
extension PostDetailsViewModel: ViewModelType {
    struct Input {
        let loadPost: Driver<Int>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let failure: Driver<String>
        let postData: Driver<PostDetailsViewController.Data>
    }
    
    func transform(input: Input) -> Output {
        let postData = input.loadPost
            .asObservable()
            .flatMapLatest(getPostByIdUseCase.execute)
            .share()
        
        let success = postData
            .compactMap { $0.value }
            .map(mapper.mapPostData)
            .asDriverOnErrorJustComplete()
        
        let failure = postData
            .compactMap { $0.error }
            .map(mapper.mapPostError)
            .asDriverOnErrorJustComplete()
        
        let loading = Driver.merge(
            input.loadPost.map { _ in true },
            postData.map { _ in false }.asDriver(onErrorJustReturn: false)
        )
        
        return Output(
            loading: loading,
            failure: failure,
            postData: success
        )
    }
}
