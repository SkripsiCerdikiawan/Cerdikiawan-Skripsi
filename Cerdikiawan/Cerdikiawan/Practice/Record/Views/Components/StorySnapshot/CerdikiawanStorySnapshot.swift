//
//  CerdikiawanStorySnapshot.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

struct CerdikiawanStorySnapshot: View {
    var imageName: String
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: imageName) ?? UIImage(imageLiteralResourceName: "NOTFOUND_IMAGE"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 320)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    CerdikiawanStorySnapshot(
        imageName: "DEBUG_IMAGE"
    )
}
