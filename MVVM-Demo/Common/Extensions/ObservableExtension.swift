//
//  ObservableExtension.swift
//  MVVM-Demo
//
//  Created by UHP Mac 3 on 07/12/2018.
//  Copyright © 2018 UHP. All rights reserved.
//
// https://github.com/sergdort/CleanArchitectureRxSwift/blob/master/CleanArchitectureRxSwift/Utility/Observable%2BExt.swift

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
