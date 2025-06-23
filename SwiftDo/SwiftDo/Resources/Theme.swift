import SwiftUI

enum Theme {
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let background = Color("BackgroundColor")
    static let taskBackground = Color("TaskBackgroundColor")
    static let accent = Color("AccentColor")
    
    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .semibold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 16, weight: .regular, design: .rounded)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
        static let footnote = Font.system(size: 13, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 12, weight: .regular, design: .rounded)
    }
    
    enum Metrics {
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let iconSize: CGFloat = 24
        static let largeIconSize: CGFloat = 32
    }
    
    enum Effects {
        static let defaultShadow = Shadow(
            color: .black.opacity(0.1),
            radius: 10,
            x: 0,
            y: 2
        )
        
        static let strongShadow = Shadow(
            color: .black.opacity(0.15),
            radius: 15,
            x: 0,
            y: 5
        )
        
        static let subtleShadow = Shadow(
            color: .black.opacity(0.05),
            radius: 5,
            x: 0,
            y: 2
        )
    }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func cardStyle(shadowStyle: Shadow = Theme.Effects.defaultShadow) -> some View {
        self
            .padding(Theme.Metrics.padding)
            .background(Theme.taskBackground)
            .cornerRadius(Theme.Metrics.cornerRadius)
            .shadow(
                color: shadowStyle.color,
                radius: shadowStyle.radius,
                x: shadowStyle.x,
                y: shadowStyle.y
            )
    }
    
    func materialBackground() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(Theme.Metrics.cornerRadius)
    }
} 