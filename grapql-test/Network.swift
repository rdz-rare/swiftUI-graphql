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
    private let grapqlUrl = ProcessInfo.processInfo.environment["GRAPHQL_URL"] ?? "http://192.168.86.47:4000/graphql"
    private(set) lazy var apollo = ApolloClient(url: URL(string: grapqlUrl)!)
}
