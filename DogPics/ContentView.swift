//
//  ContentView.swift
//  DogPics
//
//  Created by Aimee Hong on 11/18/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    enum Breed: String, CaseIterable {
        case boxer, bulldog, chihuahua, corgi, labradoodle, poodle, pug, retriever
    }
    @State private var selectedBreed: Breed = .boxer
    @State private var audioPlayer: AVAudioPlayer!
    @State private var dogVM = DogViewModel()
    
    var body: some View {
        VStack {
            Text("🐶 Dog Pics!")
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .foregroundStyle(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()

            AsyncImage(url: URL(string: dogVM.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 15)
                    .animation(.default, value: image)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }

            Spacer()
            
            Button("Any Random Dog") {
                dogVM.urlString = "https://dog.ceo/api/breeds/image/random"
                Task {
                    await dogVM.getData()
                }
            }
            .buttonStyle(.borderedProminent)
            .bold()
            .tint(.brown)
            .foregroundStyle(.white)
            .padding(.bottom)
            
            HStack {
                Button("Show Breed") {
                    dogVM.urlString = "https://dog.ceo/api/breed/\(selectedBreed.rawValue)/images/random"
                    Task {
                        await dogVM.getData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
                .padding(.bottom)
                
                
                Picker("", selection: $selectedBreed) {
                    ForEach(Breed.allCases, id: \.self) { breed in
                        Text(breed.rawValue.capitalized)
                    }
                }
            }
            .tint(.brown)
            .bold()
        }
        .onAppear() {
            playSound(soundName: "bark")
        }
        .padding()
    }
    
    func playSound(soundName: String) {
        if audioPlayer != nil {
            audioPlayer.stop() }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return  }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioplayer.")
        }
    }
}

#Preview {
    ContentView()
}
