//
//  SearchViewModel.swift
//  Found & Valued
//
//  Created by Zhi Yong Huang on 12/28/23.
//

import FirebaseFirestore

class SearchViewModel: ObservableObject {
    @Published var users: [FVUser] = []
    
    private let service = SearchService()
    
    func fetchUser(withUsername username: String) async {
        do {
            let users = try await service.searchUser(withUsername: username)
            // Use the fetched users here, for instance, print their names:
            DispatchQueue.main.async {
                self.users = users
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
}
