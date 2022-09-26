//
//  DetailView.swift
//  Bookworm
//
//  Created by Derya Antonelli on 08/09/2022.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let book: Book
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                getGenreImage()
                    .resizable()
                    .scaledToFit()
                
                getGenreText()
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("Date added: \(formatDate(book.date ?? Date.now))")
                .padding()
            
            Text(book.review ?? "No review")
                .padding()
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
    }
    
    func getGenreImage() -> Image {
        if let genre = book.genre {
            if(genre.isEmpty) {
                return Image("Unknown")
            }
            return Image(genre)
            
        } else {
            return Image("Unkown")
        }
    }
    
    func getGenreText() -> Text {
        if let genre = book.genre {
            if(genre.isEmpty) {
                return Text("UNKNOWN GENRE")
            }
            return Text("\(genre.uppercased())")
        } else {
            return Text("Unknown genre")
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateFormatter.locale = Locale(identifier: "en_UK")
        
        return dateFormatter.string(from: date)
    }
    
    
    func deleteBook() {
        moc.delete(book)
        
        // uncomment this line if you want to make the deletion permanent
        // try? moc.save()
        
        dismiss()
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//        let book = Book(context: moc)
//        book.title = "Test book"
//        book.author = "Test author"
//        book.genre = "Fantasy"
//        book.rating = 4
//        book.review = "This was a great book; I really enjoyed it."
//
//        return NavigationView {
//            DetailView(book: book)
//        }
//    }
//}
