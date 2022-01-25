//
//  NetworkService.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation

class NetworkService {
    public static var sharedobj = NetworkService()
    private let url = "https://type.fit/api/quotes"
    private let session = URLSession(configuration: .default)
   
    func getQuotes(onSuccess: @escaping(Quote) -> Void) {
        let qurl = URL(string: url)!
        
        let task = session.dataTask(with: qurl) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let quotes = try JSONDecoder().decode(Quote.self, from: data!)
                    onSuccess(quotes)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
