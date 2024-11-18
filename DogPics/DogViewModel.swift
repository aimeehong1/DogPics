//
//  DogViewModel.swift
//  DogPics
//
//  Created by Aimee Hong on 11/18/24.
//

import Foundation

@Observable
class DogViewModel {
    struct Result: Codable {
        var message: String
    }
    var imageURL: String = ""
    var urlString = "https://dog.ceo/api/breeds/image/random"
    
    func getData() async {
        print("🕸️ Accessing the url: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a URL from \(urlString)")
            return  }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Result.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                return }
            print("😎 JSON returned! \(returned)")
            Task { @MainActor in
                imageURL = returned.message
            }
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)") }
    }
}

