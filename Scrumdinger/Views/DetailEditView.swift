import SwiftUI


struct DetailEditView: View {
    @Binding var scrum: DailyScrum
    @State private var newAttendeeName = ""
    
    var body: some View {
        Form {
            Section(header: Text("Meeting Info")){
                TextField("title", text: $scrum.title)
            
            
                HStack{
                    Slider(value:$scrum.lengthInMinutesAsDouble, in: 5...30, step: 1){
                        Text("Length")
                    }.accessibilityValue("\(scrum.lengthInMinutes) minutes")
                    
                    Spacer()
                    
                    Text("\(scrum.lengthInMinutes) minutes")
                        .accessibilityHidden(true)
                }
                ThemePicker(selection: $scrum.theme)
            }
            Section(header: Text("Attendees Info")){
                HStack{
                    TextField("New Attendee", text: $newAttendeeName)
                    Button(action: {
                        withAnimation {
                            let attendee = DailyScrum.Attendee(name: newAttendeeName)
                            scrum.attendees.insert(attendee, at:0)
                            newAttendeeName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newAttendeeName.isEmpty)
                }
                ForEach(scrum.attendees) { attendee in
                    Text(attendee.name)
                }
                .onDelete{ indexSet in
                    scrum.attendees.remove(atOffsets: indexSet)
                }
               
            }
        }
    }
}


#Preview {
    DetailEditView(scrum: .constant(DailyScrum.sampleData[0]))
}
