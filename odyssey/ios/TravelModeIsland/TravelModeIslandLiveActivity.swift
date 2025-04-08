//
//  TravelModeIslandLiveActivity.swift
//  TravelModeIsland
//
//  Created by Patrick Wei on 2025-04-08.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TravelModeIslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TravelModeIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TravelModeIslandAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TravelModeIslandAttributes {
    fileprivate static var preview: TravelModeIslandAttributes {
        TravelModeIslandAttributes(name: "World")
    }
}

extension TravelModeIslandAttributes.ContentState {
    fileprivate static var smiley: TravelModeIslandAttributes.ContentState {
        TravelModeIslandAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TravelModeIslandAttributes.ContentState {
         TravelModeIslandAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TravelModeIslandAttributes.preview) {
   TravelModeIslandLiveActivity()
} contentStates: {
    TravelModeIslandAttributes.ContentState.smiley
    TravelModeIslandAttributes.ContentState.starEyes
}
