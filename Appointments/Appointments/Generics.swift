//
//  Generics.swift
//  Appointments
//
//  Created by Aaron Skulsky on 11/5/22.
//

import SwiftUI

// Modifier for Menu in AppointmentView that displays Appointment Locations

struct MenuLabel: View {
    
    var location: String = "Location"
    var placeHolder: String
    
    var body: some View {
        HStack {
            Text(location)
                .lineLimit(1)
                .foregroundColor(self.location == placeHolder ? .secondary : .primary)
            Spacer()
            Image(systemName: self.location == placeHolder ? "chevron.down" : "checkmark.circle")
                .foregroundColor(self.location == placeHolder ? .secondary : Color.green)
        }
    }
}
