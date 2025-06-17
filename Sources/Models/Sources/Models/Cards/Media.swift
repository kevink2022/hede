//
//  Media.swift
//  Models
//
//  Created by Kevin Kelly on 6/15/25.
//

import Foundation
import Domain

public struct CardElement: Codable, Equatable {
    public var label: String
    public var media: CardMedia
    
    public init(label: String, media: CardMedia) {
        self.label = label
        self.media = media
    }
}

/// Cards will be made out of one or more elements.
public enum CardMedia: Codable, Equatable {
    case text(String)
    case audio(CardMediaSource)
    case image(CardMediaSource)
    case video(CardMediaSource)
    case page([CardMedia])
}

public enum CardMediaSource: Codable, Equatable {
    case local(URL)
}
