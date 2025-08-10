//
//  RepinWidget.swift
//  RepinWidget
//
//  Created by 송태환 on 8/10/25.
//

import WidgetKit
import SwiftUI

struct RepinWidget: Widget {
    let kind: String = "RepinWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RepinWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RepinWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("GitHub 저장소")
        .description("최근 북마크한 저장소를 보여줍니다.")
    }
}

#Preview(as: .systemSmall) {
    RepinWidget()
} timeline: {
    RepositoryEntry.placeholder
}
