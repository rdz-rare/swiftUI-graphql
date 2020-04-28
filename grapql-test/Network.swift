//
//  Network.swift
//  grapql-test
//
//  Created by Angel Rodriguez on 4/24/20.
//  Copyright © 2020 Angel Rodriguez. All rights reserved.
//
import Foundation
import Apollo

class Network {
    static let shared = Network()
    private let grapqlUrl = "https://swiftui-graphql-nexus.herokuapp.com/graphql"
    private(set) lazy var apollo = ApolloClient(url: URL(string: grapqlUrl)!)
}
