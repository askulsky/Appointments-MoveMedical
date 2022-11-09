//
//  AppointmentView.swift
//  Appointments
//
//  Created by Aaron Skulsky on 11/5/22.
//

import SwiftUI

struct AppointmentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.self) var environment
    
    @EnvironmentObject var viewModel: ViewModel
    
    let locations: [String] = ["San Diego", "St. George", "Park City", "Dallas", "Memphis", "Orlando"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    
                    // Menu that displays Location options
                    
                    Section(header: Text("City")) {
                        Menu() {
                            ForEach(self.locations, id: \.self) { city in
                                Button(action: {
                                    viewModel.location = city
                                }) {
                                    Text(city)
                                }
                            }
                        } label: {
                            MenuLabel(location: viewModel.location, placeHolder: "Location" )
                        }
                    }
                    
                    // Date and Time selection
                    
                    Section(header: Text("Date and Time")) {
                        Button(action: {
                            viewModel.showDatePicker.toggle()
                        }) {
                            HStack {
                                Text(viewModel.date.formatted(date: .abbreviated, time: .omitted) + " at " + viewModel.date.formatted(date: .omitted, time: .shortened))
                                Spacer()
                                Image(systemName: "calendar")
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    // Description of Appointment
                    
                    Section(header: Text("Description")) {
                        TextField("Type something...", text: $viewModel.description, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                VStack {
                    Spacer()
                    
                    // Checks to save Appointment into CoreData, if cofirmed --> save
                    
                    Button(action: {
                        if viewModel.updateAppointment(context: environment.managedObjectContext) {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.resetAppointmentData()
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .frame(height: 44)
                                .foregroundColor((viewModel.location == "Location" || viewModel.description == "") ? .secondary : .green)
                            Text("Confirm Appointment")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled((viewModel.location == "Location" || viewModel.description == "") ? true : false)
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Appointment Info")
                
                if viewModel.showDatePicker == true {
                    ZStack {
                        
                        // Opens DatePicker View to select Data and Time for Appointment
                        
                        Button(action: {
                            viewModel.showDatePicker.toggle()
                        }) {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                        .overlay {
                            DatePicker.init("", selection: $viewModel.date, in: Date.now...Date.distantFuture)
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .padding()
                        }
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    // Dismisses sheet presentation
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .frame(width: 44.0, height: 44.0)
                    }
                    .disabled(viewModel.showDatePicker ? true : false)
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView().environmentObject(ViewModel())
    }
}
