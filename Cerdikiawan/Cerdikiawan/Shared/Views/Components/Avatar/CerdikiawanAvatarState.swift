//
//  CerdikiawanAvatarState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanAvatarState {
    case happy
    case normal
    case sad
    
    func displayImage(avatar: AvatarEntity) -> Image {
        switch self {
        case .happy:
            if let image = UIImage(named: "\(avatar.name.uppercased())_HAPPY") {
                return Image(uiImage: image)
            }
            return Image(.BUDI_HAPPY)
        case .normal:
            if let image = UIImage(named: "\(avatar.name.uppercased())_DEFAULT") {
                return Image(uiImage: image)
            }
            return Image(.BUDI_DEFAULT)
        case .sad:
            if let image = UIImage(named: "\(avatar.name.uppercased())_SAD") {
                return Image(uiImage: image)
            }
            return Image(.BUDI_SAD)
        }
    }
    
}
