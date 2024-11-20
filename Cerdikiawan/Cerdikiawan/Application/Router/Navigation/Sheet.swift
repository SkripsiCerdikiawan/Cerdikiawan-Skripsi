//
//  Sheet.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

enum Sheet {
    case page
}

extension Sheet: Identifiable {
    var id: Self { return self }
}

extension Sheet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}

extension Sheet: Equatable {
    static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        switch (lhs, rhs) {
        case (.page, .page):
            return true
        }
    }
}
