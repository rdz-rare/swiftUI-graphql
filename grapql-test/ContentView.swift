//
//  ContentView.swift
//  grapql-test
//
//  Created by Angel Rodriguez on 4/24/20.
//  Copyright © 2020 Angel Rodriguez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var usersData: UsersListData = UsersListData()
    @State private var showingEditUser = false
    @State private var showingCreateUser =  false
    @State private var selectedUserId: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if usersData.users.count == 0 {
                    VStack(alignment: .center) {
                        Spacer()
                        
                        Text("There are no users.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            self.showingCreateUser = true
                            print("add new user: \(self.showingCreateUser)")
                        }) {
                            HStack(alignment: .center) {
                                Image(systemName: "plus")
                                    .padding()
                                Text("Add new user")
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.trailing)
                        .background(Color.green)
                        .cornerRadius(CGFloat(10))
                        .clipped()
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(usersData.users, id: \.id) { user in
                            Button(action: {
                                self.selectUserToEdit(user.id)
                                
                            }) {
                                HStack(alignment: .center) {
                                    Text(user.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("ID: \(user.id)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: removeUsers)
                        .sheet(isPresented: self.$showingEditUser) {
                            EditUserView(usersData: self.usersData, userId: self.selectedUserId)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreateUser) {
                NewUserView(usersData: self.usersData)
            }
            .navigationBarTitle("Users (\(usersData.users.count))")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingCreateUser = true
                }) {
                    Image(systemName: "person.badge.plus.fill")
                        .accentColor(.green)
                }
            )
        }
        
    }
    
    func removeUsers(at offsets: IndexSet) {
        for index in offsets {
            
            Network.shared.apollo.perform(mutation: DeleteUserMutation(userId: usersData.users[index].id)) { result in
                switch result {
                    case .success:
                        self.usersData.users.remove(at: index)
                    case .failure(let error):
                        print(error)
                }
            }
        }
        
    }
    
    func selectUserToEdit(_ userId: Int) -> Void {
        self.showingEditUser = true
        self.selectedUserId = userId
    }
}

class UsersListData: ObservableObject {
    @Published var users: [AllUsersQuery.Data.User]
    
    init() {
        self.users = [AllUsersQuery.Data.User]()
        loadData()
    }
    
    func loadData() {
        Network.shared.apollo.fetch(query: AllUsersQuery()) { result in
            switch result {
                case .success(let GQLResult):
                    if let users = GQLResult.data?.users {
                        self.users = users
                    }
                case .failure(let error):
                    print("There was an error: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var usersx = UsersListData()
    
    static var previews: some View {
        ContentView(usersData: usersx)
    }
}
