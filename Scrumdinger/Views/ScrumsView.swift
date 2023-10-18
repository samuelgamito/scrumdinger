import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State var newScrumDaily: DailyScrum = DailyScrum.emptyScrum
    @State var isPresentingEditView = false
    
    let saveAction: ()->Void
    
    var body: some View {
        NavigationStack{
            List($scrums, id: \.id){ $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)){
                    CardView(scrum: scrum)
                }
            }
            .navigationTitle("Daily Scrums")
            .toolbar{
                Button(action: {
                    isPresentingEditView = true
                    newScrumDaily = DailyScrum.emptyScrum
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new scrum team")
            }
        }
        .sheet(isPresented: $isPresentingEditView){
            NavigationStack {
                DetailEditView(scrum: $newScrumDaily)
                    .navigationTitle("New Scrum Team")
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                scrums.append(newScrumDaily)
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase){ _, phase in
            if phase == .inactive { saveAction() }
        }
    }
    
}

#Preview {
    ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
}
