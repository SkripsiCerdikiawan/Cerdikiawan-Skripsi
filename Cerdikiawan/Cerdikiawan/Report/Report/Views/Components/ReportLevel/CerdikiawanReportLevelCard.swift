//
//  CerdikiawanReportLevelCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanReportLevelCard: View {
    var imageName: String
    var title: String
    var description: String
   
    var style: CerdikiawanReportLevelCardStyle
    
    var onTapGesture: () -> Void
    
    var body: some View {
        VStack {
            // Image
            Image(uiImage: UIImage(named: imageName) ?? UIImage(imageLiteralResourceName: "NOTFOUND_IMAGE"))
                .resizable().frame(height: 112)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    HStack {
                        Text(style.displayedText)
                            .foregroundStyle(style.foregroundColor)
                    }
                    Spacer()
                    if style == .havePlay {
                        Image(systemName: "chevron.forward")
                            .imageScale(.small)
                            .foregroundStyle(style.foregroundColor)
                    }
                }
                .foregroundStyle(Color(.cDarkBlue))
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .background(
            Color(.cWhite)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 8
                    )
                )
        )
        .frame(width: 200)
        .frame(minHeight: 280)
        .onTapGesture {
            onTapGesture()
        }
    }
}

#Preview {
    ZStack {
        Color(ColorResource.cGray).ignoresSafeArea()
        CerdikiawanReportLevelCard(
            imageName: "DEBUG_IMAGE",
            title: "Perjalanan Budi ke Pasar",
            description: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
            style: .neverPlay,
            onTapGesture: {
                print("Level Tapped!")
            }
        )
    }
}
