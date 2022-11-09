//
//  ContentView.swift
//  Appointments
//
//  Created by Aaron Skulsky on 11/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var showAlertView: Bool = false
    
    @Environment(\.self) var environment
    
    @StateObject var viewModel: ViewModel = .init()
    
    @FetchRequest(entity: Appointment.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.date, ascending: true)])
    var appointments: FetchedResults<Appointment>

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                // Loops over Appointment objects to display with View Modifiers
                
                ForEach(appointments) { appointment in
                    AppointmentItem(appointment: appointment)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }.background(Color(red: 246 / 255, green: 248 / 255, blue: 253 / 255))
            
            .navigationTitle("Appointments")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    // Add Appointment button --> Brings user to AppointmentView to create new Appointment
                    
                    Button(action: {
                        viewModel.isShowingAppointmentInfo.toggle()
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 44.0, height: 44.0)
                    }.sheet(isPresented: $viewModel.isShowingAppointmentInfo) {
                        viewModel.resetAppointmentData()
                    } content: {
                        AppointmentView()
                            .environmentObject(viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // Appointment Item View
    
    @ViewBuilder
    func AppointmentItem(appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: "person.crop.square.fill")
                    .resizable()
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    // Displays Appointment Descriptor (Description)
                    
                    Text(appointment.descriptor!)
                        .font(.headline)
                    HStack {
                        
                        // Displays Appointment Location
                        
                        Text(appointment.location!)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.ultraThinMaterial)
                HStack {
                    Group {
                        HStack {
                            
                            // Displays Date of Appointment
                            
                            Image(systemName: "calendar")
                            Text((appointment.date?.formatted(date: .long, time: .omitted))!).fixedSize()
                        }
                        Spacer()
                        HStack {
                            
                            // Displays Time of Appointment
                            
                            Image(systemName: "clock")
                            Text((appointment.date?.formatted(date: .omitted, time: .shortened))!).fixedSize()
                        }
                    }
                    .padding()
                    .font(.footnote)
                    .fontWeight(.semibold)
                }.frame(height: 50)
            }
            
            HStack(spacing: 20) {
                
                // Delete Appointment button --> Displays Alert View to confirm deletion
                
                Button(role: .destructive, action: {
                    self.showAlertView.toggle()
                }) {
                    Text("Delete")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }.alert(isPresented: $showAlertView, content: {
                    Alert(title: Text("Delete Appointment"),
                          message: Text("Are you sure you'd like to delete this appointment?"),
                          
                          // Checks to delete Appointment info from CoreData, if confirmed --> save
                          
                          primaryButton: .destructive(Text("Delete"), action: {
                        
                        if viewModel.deleteAppointment(appointment: appointment, context: environment.managedObjectContext) {
                            viewModel.resetAppointmentData()
                            self.showAlertView = false
                            
                        }
                    }),
                          
                          // Cancel Appointment deletion, dismiss Alert View
                          
                          secondaryButton: .cancel()
                    )
                })
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Capsule().stroke(.red, style: StrokeStyle(lineWidth: 1)))
                
                // Reschedule Appointment button --> Brings user to AppointmentView to change information
                
                Button(action: {
                    viewModel.isEditedAppointment = appointment
                    viewModel.editedAppointment()
                    viewModel.isEditingAppointmentInfo.toggle()
                }) {
                    Text("Reschedule")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }.sheet(isPresented: $viewModel.isEditingAppointmentInfo, content: {
                    AppointmentView()
                        .environmentObject(viewModel)
                })
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Capsule().fill(.blue))
            }.frame(height: 44)
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
