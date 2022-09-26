//
//  AddBookView.swift
//  Bookworm
//
//  Created by Derya Antonelli on 01/09/2022.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    @State private var showingFormActionAlert = false;
    @State private var requiredField = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if formIsValid() {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = Date.now
                            
                            try? moc.save()
                            dismiss()
                        } else {
                            showingFormActionAlert = true;
                        }
                        
                    }
                }
            }
            .navigationTitle("Add Book")
        }
        .alert("Invalid form", isPresented: $showingFormActionAlert) {
            Button("OK") {}
        } message: {
            Text("Please enter \(requiredField)")
        }
    }
    
    func formIsValid() -> Bool {
        if(title.isEmpty) {
            requiredField = "name of book"
            return false
        }
        else if(author.isEmpty) {
            requiredField = "author's name"
            return false
        }
        else if(review.isEmpty) {
            requiredField = "a review"
            return false
        }
        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
