//
//  NewUserView.swift
//  grapql-test
//
//  Created by Angel Rodriguez on 4/26/20.
//  Copyright © 2020 Angel Rodriguez. All rights reserved.
//

import SwiftUI

struct NewUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var saving = false
    let usersData: UsersListData
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
            }
            .navigationBarTitle("New User", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button(self.saving ? "Saving..." : "Save") {
                        self.createUser()
                    }
                    .disabled(self.saving)
            )
        }
    }
    
    init(usersData: UsersListData) {
        self.usersData = usersData
    }
    
    func createUser() {
        self.saving = true
        Network.shared.apollo.perform(mutation: CreateUserMutation(user: UserCreateInput(name: self.name))) { result in
            switch result {
                case .success(let GQLResponse):
                    if let user = GQLResponse.data?.createOneUser {
                        self.usersData.users.append(AllUsersQuery.Data.User.init(id: user.id, name: user.name))
                        self.presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(usersData: UsersListData())
    }
}
