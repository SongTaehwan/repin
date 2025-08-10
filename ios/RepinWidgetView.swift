//
//  RepinWidgetView.swift
//  
//
//  Created by 송태환 on 8/10/25.
//

import SwiftUI
import WidgetKit

struct RepinWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Text("최근 북마크한 저장소")
                .font(.caption2)

            VStack {
                Text(entry.name)
                    .font(.headline)

                Text("created by: \(entry.ownerName)")
                    .font(.caption)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 14, height: 14)

                    Text("\(entry.starGazerCount)")
                        .font(.caption)

                    Image(systemName: "arrow.triangle.branch")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 12, height: 12)

                    Text("\(entry.forkCount)")
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
