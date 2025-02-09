//
//  BoxText.swift
//  hede
//
//  Created by Kevin Kelly on 9/10/24.
//

import SwiftUI

struct BoxText: View {
    private let text: any StringProtocol
    
    var body: some View {
        Text(text)
            .font(F.boxLarge)
            .lineLimit(2)
    }

    init(
        _ text: any StringProtocol
    ) {
        self.text = text
    }
}

#Preview {
    BoxText("Test")
}

struct BoxImage: View {
    
    private let image: String
    private let initializer: BoxImage.Initializer
    
    var body: some View {
        switch initializer {
        case .blank: Image(image)        .font(F.boxLarge)

        case .systemName: Image(systemName: image)        .font(F.boxLarge)

        }
    }
    
    init(_ image: any StringProtocol) {
        self.image = String(image)
        self.initializer = .blank
    }
    
    init(systemName image: any StringProtocol) {
        self.image = String(image)
        self.initializer = .systemName
    }
    
    enum Initializer: CaseIterable {
        case blank, systemName
    }
}

#Preview {
    BoxText("Test")
}
