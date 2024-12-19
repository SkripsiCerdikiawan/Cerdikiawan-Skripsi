//
//  CerdikiawanReadingView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import SwiftUI

struct CerdikiawanReadingView: View {
    @StateObject private var viewmodel: PageViewModel
    
    init(page: PageEntity) {
        _viewmodel = StateObject(wrappedValue: PageViewModel(page: page))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Baca penggalan dibawah ini sebelum melanjutkan...")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            Image(uiImage: UIImage(named: viewmodel.data.storyImage) ?? UIImage(imageLiteralResourceName: "NOTFOUND_IMAGE"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            ScrollView(content: {
                VStack(spacing: 16, content: {
                    ForEach(viewmodel.data.paragraph, id: \.id, content: { paragraph in
                        CerdikiawanParagraph(
                            content: paragraph.paragraphText,
                            state: viewmodel.determineState(paragraph: paragraph),
                            onVoiceButtonTapped: {
                                viewmodel.handleVoiceOverTap(paragraph: paragraph)
                            }
                        )
                    })
                })
            })
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onDisappear() {
            VoiceOverHelper.shared.stopVoiceOver()
        }
    }
    

}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanReadingView(page: .mock()[0])
        }
        .safeAreaPadding(16)
    }
}
