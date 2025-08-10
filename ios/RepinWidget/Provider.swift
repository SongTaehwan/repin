//
//  Provider.swift
//  RepinWidgetExtension
//
//  Created by 송태환 on 8/10/25.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepositoryEntry {
        RepositoryEntry.preview
    }

    func getSnapshot(in context: Context, completion: @escaping (RepositoryEntry) -> ()) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let repository = loadLatestRepository()

        // 2분 후 다시 갱신 요청 (정책은 필요에 맞게 조정)
        let next = Calendar.current.date(byAdding: .minute, value: 2, to: Date())!

        if repository == nil {
            completion(Timeline(entries: [RepositoryEntry.placeholder], policy: .after(next)))
        } else {
            let entity = repository!.toEntity()
            completion(Timeline(entries: [entity], policy: .after(next)))
        }
    }

    private func loadLatestRepository() -> RepositoryDTO? {
        let defaults = UserDefaults(suiteName: "group.song.repin.shared")

        guard let jsonString = defaults?.string(forKey: "latest_repo") else {
            return nil
        }

        if jsonString.lowercased() == "null" || jsonString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return nil
        }

        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(RepositoryDTO.self, from: data)
    }
}
