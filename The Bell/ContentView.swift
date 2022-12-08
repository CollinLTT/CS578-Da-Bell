//
//  ContentView.swift
//  The Bell
//
//  Created by Collin on 12/1/22.
//
//  || PLEASE NOTE ---------------------------------------------
//  || This is formatted for the iPhone 8 ONLY (due to time constraints).
//  || All other devices will have distorted views.
//  || For Custom format: change .frame, .offset, and .font
//  || - Collin
//  ||----------------------------------------------------------
//


import SwiftUI
import WebKit
import FirebaseDatabase
import FirebaseStorage
import Foundation
import PhotosUI
import SafariServices

var safariLink = "https://www.picsum.photos"
let storage = Storage.storage()

// Create a storage reference from our storage service
let storageRef = storage.reference()

//The home page view
struct ContentView: View {
  
  //Reference to ReadViewModel.swift
  @StateObject var viewModel = ReadViewModel()

  //Default URL if cannot retrieve from firebase database
  @State private var showWebView = false
  private let urlString: String = "https://www.picsum.photos"
  
  //sets the camera display name
  var camViewName = "Front Door Cam"
  
  var body: some View {
    
    //NavigationView allows use to switch to other struct views (photoView etc)
    NavigationView{
      
      //Zstack is used to format things in layers, each object will layer on top of the previous
      ZStack(){
        
        //Sets the background color and ignores format safe zones
        //Color(.sRGB, red: 0.674, green: 0.946, blue: 0.953)
        Color(.white)
          .ignoresSafeArea()
        
        //Webview background lookalike
        Image(systemName: "")
          .foregroundColor(Color(hue: 0.0, saturation: 0.0, brightness: 0.9))
          .font(.largeTitle)
          .frame(width: 300, height: 270)
          //.background(Color(hue: 0.0, saturation: 0.0, brightness: 0.9))
          .background(Gradient(colors: [.blue,.orange]))
          .cornerRadius(15)
          .shadow(color: .black.opacity(0.25),radius: 2.0, x: 0, y: 6)
          .offset(x: 0, y: 0)
        
        //loads background image for buttons to sit on and repositions it
        Image("IMG_0910").renderingMode(.original).resizable(resizingMode: .stretch).frame(width: 385, height: 395).offset(x: 0, y: -460)
        
        //loads background image for buttons to sit on and repositions it
        Image("IMG_0908").renderingMode(.original).resizable(resizingMode: .stretch).frame(width: 385, height: 395).offset(x: 0, y: 130)
        
        //loads the camera name with customizable system image
        Label(camViewName, systemImage: "video")
          .foregroundColor(.black)
          .padding(.horizontal)
          /* Adds low opacity white background with rounded corners (a bubble) around the label
          .background(Color(hue: 0.6, saturation: 0.505, brightness: 1.80))
          .foregroundColor(.white)
          .cornerRadius(20)*/
          .offset(y: 160)
          .font(.title3)
          .bold()
        
        //formats "The Bell" title at the top of the phone
        Label("The Bell", systemImage: "lock.icloud.fill")
          .foregroundColor(.white)
          .padding(.all)
          .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.3))
          .foregroundColor(.white)
          .cornerRadius(20)
          .offset(y: -285)
          .font(.title)
          .bold()
        
        //formats the "Your Camera" text
        Text("Your Camera")
          .foregroundColor(.black)
          .padding(.horizontal)
          /* Adds white background with rounded corners (a bubble) around the text
          .background(Color(hue: 0.5, saturation: 0.005, brightness: 1.0))
          .foregroundColor(.white)
          .cornerRadius(20)*/
          .offset(x: -50, y: -160)
          .font(.largeTitle)
          .bold()
        
        
        //Group of navigation buttons
        Group {
          
          //checks if a string was grabbed from the firebase database
          if viewModel.value != nil {
            
            //loads the webview with database weblink and formats its position, size, and shadow
            /*WebView(url: URL(string: viewModel.value!)!).frame(width: 300, height: 260.0).cornerRadius(20).shadow(color: .black.opacity(0.25),radius: 4.0, x: 0, y: 8)*/
            
            /*NavigationLink(destination: safariView()) {
              Button{ viewModel.readValue()} label: {Image (systemName: "play.circle")}
                .font(.largeTitle)
                .tint(.white)
            }*/
            
            NavigationLink(destination: safariView()) {
              Label("", systemImage: "play.circle")
                .font(.largeTitle)
                .tint(.white)
              
            }

          }
          else {
            
            //loads the webview using default link and formats its position, size, and shadow
            /*WebView(url: URL(string: urlString)!).frame(width: 300, height: 260.0).cornerRadius(20).shadow(color: .black.opacity(0.35),radius: 6.0, x: 0, y: 5)*/
            
            NavigationLink(destination: safariView()) {
              Label("", systemImage: "play.circle")
                .font(.largeTitle)
                .tint(.gray)
              
            }
            
          }
          
          //Decorative home button that just prints to console when pressed
          Button {
            //Refreshes the link from Firebase
            viewModel.readValue()
            safariLink = viewModel.value!
            print("Pressed Home")
            
          }
            label: {Image (systemName: "house.fill")}
            .offset(y: 290)
            .font(.largeTitle)
            .bold()
            .tint(.white)
          
          //Clips/recordings button that links to the clipsView
          NavigationLink(destination: clipsView()) {
            Label("", systemImage: "film.stack")
              .font(.largeTitle)
              .bold()
              .tint(.white)
          }.offset(x: 140, y: 285)
          
          //Photos button that links to the photoView
          NavigationLink(destination: photoView()) {
            Label("", systemImage: "photo.on.rectangle")
              .font(.largeTitle)
              .bold()
              .tint(.white)
          }.offset(x: -140, y: 285)
          
        }
        
      }
      
      //runs the readValue function on view launch to retrieve firebase data
    }.onAppear(perform: viewModel.observeDataChange)
      .navigationBarTitle("Home")
    
  }

  
}

struct safariView: UIViewControllerRepresentable {

  func makeUIViewController(context: UIViewControllerRepresentableContext<safariView>) -> SFSafariViewController {

    let controller = SFSafariViewController(url: URL(string: safariLink)!)
    
      return controller

  }
  func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<safariView>) {
    
  }
  
}

//Used for viewing photos from firebase
struct photoView: View {
  
  let ref = storageRef.child("photos")
  
  
  //Reference to ReadViewModel.swift
  @StateObject var viewModel = ReadViewModel()
  
  let posts = ["bed.double.fill", "tram.fill", "house.fill",
               "eraser.fill", "trash.fill", "folder.fill",
               "alarm.fill", "clock.fill", "tv.fill",
               "paperplane.fill", "archivebox.fill", "doc.fill"]
  
  //Adjusts the presentation mode for custom navigation button
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  //View to display customizable back button
      var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                //back arrow
                Image(systemName: "arrowshape.left.fill") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.black)
                
                //text next to back arrow
                  Text("Home")
                  .foregroundColor(.cyan)
                  .font(.title2)
                
                
              }
          }
      }
  
  
  var body: some View{
    
    VStack(alignment: .leading){
      
      //formats the "Photos" text
      Text("Photos")
        .foregroundColor(.black)
        .padding(.horizontal)
        .font(.largeTitle)
        .bold()
      
      //Formats the photos in a 3 image wide grid with a spacing of 40 between each
      GeometryReader { geo in
        ScrollView{
          LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
          ], spacing: 40){
            //For each element in "posts" displays an image with custom sizing
            ForEach(posts, id: \.self){ post in
              Image(systemName: post)
                .frame(width: geo.size.width/3.5, height: geo.size.width/3.5)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.15),radius: 2.0, x: 0, y: 6)
                
            }
          }
        }
      }
        
    }
    //hides the system default back button replaces with custom btnBack
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: btnBack)  }
}

//Used for viewing clips from firebase
struct clipsView: View {
  
  //Reference to ReadViewModel.swift
  @StateObject var viewModel = ReadViewModel()
  
  let posts = ["Dec 06, 2022 | 02:34 PM", "Dec 06, 2022 | 05:16 PM",
               "Dec 06, 2022 | 05:27 PM", "Dec 07, 2022 | 12:08 PM",
               "Dec 07, 2022 | 12:45 PM", "Dec 07, 2022 | 03:31 PM",
               "Dec 07, 2022 | 04:02 PM", "Dec 08, 2022 | 04:23 PM",
               "Dec 08, 2022 | 04:38 PM"]
  
  //Adjusts the presentation mode for custom navigation button
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  //View to display customizable back button
      var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                //back arrow
                Image(systemName: "arrowshape.left.fill") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.black)
                
                //text next to back arrow
                  Text("Home")
                  .foregroundColor(.cyan)
                  .font(.title2)
                
                
              }
          }
      }
  
  var body: some View{
      
    VStack(alignment: .leading){
      
      //formats the "ShortClips" text
      Text("Short Clips")
        .foregroundColor(.black)
        .padding(.horizontal)
        .font(.largeTitle)
        .bold()
      
      GeometryReader { geo in
        ScrollView{
          LazyVGrid(columns: [
            GridItem(.flexible()),
          ], spacing: 20){
            ForEach(posts, id: \.self){ post in
              
              NavigationLink(destination: videoPlayer()) {
                  Text(post)
              }
                .font(.title2)
                .foregroundColor(Color.black)
                .frame(width: geo.size.width/1, height: geo.size.width/5)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.15),radius: 3.0, x: 0, y: 5)
                
            }
          }
        }
      }
        
    }
    //hides the system default back button replaces with custom btnBack
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: btnBack)
  }
  
}

struct videoPlayer: View{
  
  //Reference to ReadViewModel.swift
  @StateObject var viewModel = ReadViewModel()
  
  //Adjusts the presentation mode for custom navigation button
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  //View to display customizable back button
      var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                //back arrow
                Image(systemName: "arrowshape.left.fill") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.black)
                
                //text next to back arrow
                  Text("Short Clips")
                  .foregroundColor(.cyan)
                  .font(.title2)
                
                
              }
          }
      }
  
  var body: some View{
      
    VStack(alignment: .leading){
      
      //formats the "ShortClips" text
      Text("Video Player")
        .foregroundColor(.black)
        .font(.largeTitle)
        .bold()
        .offset(x: -20, y: -80)
      
      Text("Date:")
        .foregroundColor(.black)
        .padding(.horizontal)
        .font(.title)
        .bold()
        .offset(x: -10, y: -40)
      
      Image(systemName: "video.fill")
        .frame(width: 300, height: 300)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.15),radius: 2.0, x: 0, y: 6)
        .offset(x: 0, y: -40)
      
      Button("Play Video") {
        print("pressed play")
        viewModel.readAllPhotos()
    
      }
      .foregroundColor(.black)
        .padding(.horizontal)
        .font(.title)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.98))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.2),radius: 2.0, x: 0, y: 4)
        .offset(x: 70, y: 0)
        
      
        
    }
    //hides the system default back button replaces with custom btnBack
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: btnBack)
  }
}

//structures the webview and updates the UI view
struct WebView: UIViewRepresentable{
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

//Used to preview app in real time within Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
