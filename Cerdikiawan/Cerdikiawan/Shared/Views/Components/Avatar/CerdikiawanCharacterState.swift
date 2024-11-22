//
//  CerdikiawanCharacterState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanCharacterState {
    case happy
    case normal
    case sad
    
    func displayImage(character: CharacterEntity) -> Image {
        switch self {
        case .happy:
            if let image = UIImage(named: "\(character.name.uppercased())_HAPPY") {
                return Image(uiImage: image)
            }
            return Image(.BUDI_HAPPY)
        case .normal:
            if let image = UIImage(named: "\(character.name.uppercased())_DEFAULT") {
                return Image(uiImage: image)
            }
            return Image(.BUDI_DEFAULT)
        case .sad:
            if let image = UIImage(named: "\(character.name.uppercased())_SAD") {
                return Image(uiImage: image)
            }
            return Image(.BUDI_SAD)
        }
    }
    
}
