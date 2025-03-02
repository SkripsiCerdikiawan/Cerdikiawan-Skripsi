//
//  CerdikiawanAttemptCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanAttemptCard: View {
    var date: Date
    var kosakataPercentage: Int
    var idePokokPercentage: Int
    var implisitPercentage: Int
    
    var buttonStyle: CerdikiawanButtonType
    var onTapButtonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "calendar")
                    .imageScale(.medium)
                    .foregroundStyle(Color(.gray))
                
                VStack(alignment: .leading) {
                    Text("Tanggal pengerjaan")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                    Text(DateUtils.getDate(from: date))
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(DateUtils.getTime(from: date))
                        .font(.headline)
                }
            }
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle")
                    .imageScale(.medium)
                    .foregroundStyle(Color(.gray))
                
                VStack(alignment: .leading) {
                    Text("Status pengerjaan")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Kosakata")
                            Spacer()
                            Text(kosakataPercentage == -1 ? "-" : "\(kosakataPercentage)%")
                        }
                        HStack {
                            Text("Ide Pokok")
                            Spacer()
                            Text(idePokokPercentage == -1 ? "-" : "\(idePokokPercentage)%")
                        }
                        HStack {
                            Text("Implisit")
                            Spacer()
                            Text(implisitPercentage == -1 ? "-" : "\(implisitPercentage)%")
                        }
                    }
                    .padding(.trailing, 8)
                }
            }
            
            CerdikiawanButton(
                type: buttonStyle,
                label: buttonStyle == .primary ? "Putar Rekaman" : "Hentikan",
                action: {
                    onTapButtonAction()
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.cWhite))
        )
    }
}

#Preview {
    @Previewable
    @State var isPlaying: Bool = false
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        CerdikiawanAttemptCard(
            date: Date.now,
            kosakataPercentage: 100,
            idePokokPercentage: 90,
            implisitPercentage: 95,
            buttonStyle: isPlaying ? .secondary : .primary,
            onTapButtonAction: {
                isPlaying.toggle()
            }
        )
        .padding(.horizontal, 16)
    }
}
