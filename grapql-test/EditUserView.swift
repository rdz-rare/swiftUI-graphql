//
//  EditUserView.swift
//  grapql-test
//
//  Created by Angel Rodriguez on 4/26/20.
//  Copyright © 2020 Angel Rodriguez. All rights reserved.
//

import SwiftUI

struct EditUserView: View {
    @State private var name: String
    var usersData: UsersListData
    private var user: AllUsersQuery.Data.User
    @State private var saving = false
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nombre", text: $name)
                }
            }
            .navigationBarTitle("Editar usuario", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                
                trailing:
                    Button(self.saving ? "Saving..." : "Save") {
                        self.saveUserData()
                    }
                    .disabled(self.saving)
            )
        }
    }
    
    init(usersData: UsersListData, userId: Int) {
        self.usersData = usersData
        if let user = self.usersData.users.first(where: { $0.id == userId}) {
            self.user = user
            _name =  State(initialValue: user.name)
        } else {
            fatalError("No se encontraron coincidencias")
        }
    }
    
    
    func saveUserData() {
        self.saving = true

        Network.shared.apollo.perform(mutation: UpdateUserMutation(user: UserUpdateCustomInput(id: self.user.id, name: self.name))) { result in
            switch result {
                case .success(let GQLResult):
                    self.presentationMode.wrappedValue.dismiss()
                    if let currentUserIndex = self.usersData.users.firstIndex(where: {$0.id == self.user.id}) {
                        if let user = GQLResult.data?.updateUser {
                            self.usersData.users[currentUserIndex] = AllUsersQuery.Data.User.init(id: user.id, name: user.name)
                        }
                            
                    }
                
                case .failure(let error):
                    print(error)
                
            }
        }
    }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserView(usersData: UsersListData(), userId: 1)
    }
}
