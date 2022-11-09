//
//  ViewModel.swift
//  Appointments
//
//  Created by Aaron Skulsky on 11/5/22.
//

import Foundation
import CoreData

class ViewModel: ObservableObject {
    
    @Published var isShowingAppointmentInfo: Bool = false
    @Published var isEditingAppointmentInfo: Bool = false
    
    @Published var isEditedAppointment: Appointment?
    
    @Published var showDatePicker: Bool = false
    
    @Published var location: String = "Location"
    @Published var date: Date = Date()
    @Published var description: String = ""
    
    // Multi-functional func that both updates and creates new Appointment objects
    
    func updateAppointment(context: NSManagedObjectContext) -> Bool {
        
        var appointment: Appointment!
        if isEditingAppointmentInfo {
            if let isEditedAppointment = isEditedAppointment {
                appointment = isEditedAppointment
                isEditingAppointmentInfo = false
            }
        } else {
            appointment = Appointment(context: context)
        }
        
        appointment.location = location
        appointment.date = date
        appointment.descriptor = description
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // Func that deletes an Appointment
    
    func deleteAppointment(appointment: Appointment, context: NSManagedObjectContext) -> Bool {
        context.delete(appointment)
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // Func that sets an Appointment as an Edited Appointment upon rescheduling an Appointment
    
    func editedAppointment() {
        if let isEditedAppointment = isEditedAppointment {
            location = isEditedAppointment.location!
            date = isEditedAppointment.date!
            description = isEditedAppointment.descriptor!
        }
    }
    
    // Func that resets the Appointment data back to default values
    
    func resetAppointmentData() {
        location = "Location"
        date = Date()
        description = ""
    }
}
