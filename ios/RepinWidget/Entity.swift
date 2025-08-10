//
//  Entity.swift
//  RepinWidgetExtension
//
//  Created by 송태환 on 8/10/25.
//

import WidgetKit

struct RepositoryDTO: Decodable {
    let id: Int
    let name: String
    let ownerName: String
    let ownerId: Int
    let ownerProfileUrl: String?
    let repositoryUrl: String
    let createdAt: String
    let updatedAt: String
    let pushedAt: String
    let forksCount: Int
    let openIssuesCount: Int
    let stargazersCount: Int
    let watchersCount: Int
    let license: String?
    let language: String?
    let description: String

    func toEntity() -> RepositoryEntry {
        RepositoryEntry(
            date: Date.now,
            id: id,
            name: name,
            ownerName: ownerName,
            starGazerCount: stargazersCount,
            forkCount: forksCount,
            type: .data
        )
    }
}

enum EntityType {
    case placeholder
    case preview
    case data
}

struct RepositoryEntry: TimelineEntry {
    let date: Date
    let id: Int
    let name: String
    let ownerName: String
    let starGazerCount: Int
    let forkCount: Int
    let type: EntityType

    static var preview: RepositoryEntry {
        .init(
            date: Date.now,
            id: -1,
            name: "awssome-repin",
            ownerName: "tom",
            starGazerCount: 1923,
            forkCount: 123,
            type: .preview
        )
    }

    static var placeholder: RepositoryEntry {
        .init(
            date: Date.now,
            id: -1,
            name: "awssome-repin",
            ownerName: "tom",
            starGazerCount: 1923,
            forkCount: 123,
            type: .placeholder
        )
    }
}
