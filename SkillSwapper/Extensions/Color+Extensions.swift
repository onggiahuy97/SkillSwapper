//
//  Color+Extensions.swift
//  SkillSwapper
//
//  Created by Huy Ong on 8/8/23.
//

import SwiftUI

extension Color {
    static func systemColor(_ uiColor: UIColor) -> Color {
        Color(uiColor: uiColor)
    }
    
    static var bgLinearView: some View {
        LinearGradient(
            colors: [.blue, .pink, .orange, .white, .green],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(0.5)
    }
}
