//: Playground - noun: a place where people can play

import UIKit

let url = URL(string: "https://api.trakt.tv/users/watchlist/movies")!
var request = URLRequest(url: url)
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("2", forHTTPHeaderField: "trakt-api-version")
request.addValue("", forHTTPHeaderField: "trakt-api-key")
request.addValue("", forHTTPHeaderField: "trakt-api-key")

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let response = response, let data = data {
        print(response)
        print(String(data: data, encoding: .utf8))
    } else {
        print(error)
    }
}