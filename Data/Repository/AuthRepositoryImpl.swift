//
//  AuthRepositoryImpl.swift
//  Data
//
//  Created by Dino Catalinac on 15/04/2020.
//  Copyright © 2020 github.com/dinocata. All rights reserved.
//

import RxSwift
import Domain

public class AuthRepositoryImpl: AuthRepository {
  
    private let authService: AuthService
    private var keychainAccess: KeychainAccessManager
    
    public init(authService: AuthService, keychainAccess: KeychainAccessManager) {
        self.authService = authService
        self.keychainAccess = keychainAccess
    }
    
    public func login(using credentials: LoginRequestData) -> Single<NetworkResult<LoginResponseData>> {
        return authService.login(using: credentials)
    }
    
    public func setAuthToken(_ token: String?) {
        keychainAccess.authToken = token
    }
    
    public func logout() -> Completable {
        return .create { [weak self] completable in
            self?.keychainAccess.authToken = nil
            completable(.completed)
            return Disposables.create()
        }
    }
}
