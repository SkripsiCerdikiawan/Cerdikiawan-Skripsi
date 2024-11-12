//
//  CerdikiawanLevelSelectionCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanLevelSelectionCard: View {
    var image: Image
    var title: String
    var description: String
    var availableBalanceToGain: Int
    var onTapGesture: () -> Void
    
    var body: some View {
        VStack {
            // Image
            image.resizable().frame(height: 112)
            
            VStack() {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                HStack {
                    HStack {
                        Text("Bisa dapat")
                        HStack(spacing: 0) {
                            Image(systemName: "dollarsign.square")
                                .imageScale(.small)
                            Text("\(availableBalanceToGain)")
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .imageScale(.small)
                }
                .foregroundStyle(Color(.cDarkBlue))
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(height: 148, alignment: .topLeading)
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
        .frame(width: 224, height: 292)
        .onTapGesture {
            onTapGesture()
        }
    }
}

#Preview {
    ZStack {
        Color(ColorResource.cGray).ignoresSafeArea()
        CerdikiawanLevelSelectionCard(
            image: Image(.DEBUG),
            title: "Perjalanan Budi Ke Pasar",
            description: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
            availableBalanceToGain: 10,
            onTapGesture: {
                
            }
        )
        
    }
}
