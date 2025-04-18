//
//  UserViewModel.swift
//  DemoAPICall
//
//  Created by Ujesh Patel on 16/04/25.
//

// -  API - GET

import Foundation

// ViewModel
final class UserViewModel {

    private var users: [User] = []
    private let networkService: NetworkService

    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }

    var numberOfUsers: Int {
        users.count
    }

    func user(at index: Int) -> User {
        users[index]
    }

    func fetchUsers(completion: @escaping (Bool, String?) -> Void) {
        let endpoint = "https://reqres.in/api/users"

        networkService.request(endpoint: endpoint, method: .get, parameters: nil) { [weak self] (result: Result<UserDataResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.users = response.data
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
}
