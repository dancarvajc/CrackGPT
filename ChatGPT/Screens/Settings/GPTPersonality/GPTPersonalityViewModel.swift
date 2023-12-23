//
//  GPTPersonalityViewModel.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 20-08-23.
//

import Factory
import Foundation

final class GPTPersonalityViewModel: ObservableObject {
    @Published private(set) var personalities: [GPTPersonality] = []
    @Injected(\.storageGPTPersonality) private var storage

    func loadGPTPersonalities() {
        personalities = storage.fetchAll()
    }

    func saveGPTPersonality(_ personality: GPTPersonality, isEditing: Bool) {
        if isEditing {
            updateGPTPersonality(personality)
        } else {
            saveGPTPersonalityInStorage(personality)
        }
        loadGPTPersonalities()
    }

    func movePersonalityOrder(fromOffsets source: IndexSet, toOffset destination: Int) {
        personalities.move(fromOffsets: source, toOffset: destination)
        let reversedIndices = personalities.indices.reversed()
        for index in reversedIndices {
            personalities[index].createdAt = Date.now
            updateGPTPersonality(personalities[index])
        }
    }

    func deletePersonality(_ offsets: IndexSet) {
        guard let itemIndex = offsets.first else { return }
        let item = personalities[itemIndex]
        personalities.remove(atOffsets: offsets)
        deleteGPTPersonality(item)
    }

    private func deleteGPTPersonality(_ personality: GPTPersonality) {
        do {
            try storage.delete(personality)
        } catch {
            print("error: \(error)")
        }
    }

    private func saveGPTPersonalityInStorage(_ personality: GPTPersonality) {
        do {
            try storage.save(personality)
        } catch {
            print("error: \(error)")
        }
    }

    private func updateGPTPersonality(_ personality: GPTPersonality) {
        do {
            try storage.update(personality)
        } catch {
            print("error: \(error)")
        }
    }
}
