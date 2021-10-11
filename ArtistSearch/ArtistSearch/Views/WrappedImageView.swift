//
//  WrappedImageView.swift
//  ArtistSearch
//
//  Created by Przemyslaw Cackowski on 07/10/2021.
//

import SwiftUI
import Combine

struct ActivityIndicatorView: UIViewRepresentable {

    private var activityView = UIActivityIndicatorView(style: .medium)
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        activityView.color = UIColor.white
        return activityView
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        uiView.startAnimating()
    }
    
    func stopAnimating() {
        activityView.stopAnimating()
    }
}

struct WrappedImageView: View {
    @Environment(\.injected) var container: DIContainer
    @State private var image: Image?
    @State private var imageViewModel: ImageViewModel?
    
    private let imageURL: String
    private var activityView = ActivityIndicatorView()
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    func initialize() {
        self.imageViewModel = ImageViewModel(imageURL: imageURL, container: container, image: $image)

    }
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea(.all)
            
            if self.image == nil {
                activityView
            } else if let unwrappedImage = self.image {
                unwrappedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        activityView.stopAnimating()
                    }

            }
        }
        .transition(AnyTransition.opacity)
        .animation(.easeIn(duration: 0.2))
        .onAppear {
            self.initialize()
            self.imageViewModel?.loadImage()
        }

    }
    
}

struct WrappedImageView_Previews: PreviewProvider {
    static var previews: some View {
        WrappedImageView(imageURL: "")
    }
}
