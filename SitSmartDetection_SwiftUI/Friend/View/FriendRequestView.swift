//
//  FriendRequestView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/2/5.
//

import SwiftUI
import Combine

class FriendRequestViewModel: ObservableObject {
    
    @Published var friendRequests: [FriendRequestResponse] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchFriendRequests() {
        FriendService.shared.fetchFriendRequests()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching friend requests: \(error)")
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] friendRequests in
                    guard let self = self else { return }
                    self.friendRequests = friendRequests
                }
            )
            .store(in: &cancellables)
    }
    
    func acceptRequest(_ request: FriendRequestResponse, completion: @escaping (Result<Void, Error>) -> Void) {
        FriendService.shared.handleFriendRequest(request: request, action: .Accept, completion: completion)
    }

    func declineRequest(_ request: FriendRequestResponse, completion: @escaping (Result<Void, Error>) -> Void) {
        FriendService.shared.handleFriendRequest(request: request, action: .Decline, completion: completion)
    }
}

struct FriendRequestView: View {
    @StateObject private var viewModel = FriendRequestViewModel()
    var body: some View{
        List {
            ForEach(viewModel.friendRequests, id: \.requestID) { request in
                FriendRequestRow(request: request, viewModel: viewModel)
            }
        }
        .navigationTitle("Friend Requests")
        .onAppear {
            viewModel.fetchFriendRequests()
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SearchView()) {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }
}

enum HandleState {
    case pending
    case accepted
    case declined
}

struct FriendRequestRow: View {
    @State private var handleState: HandleState = .pending
    let request: FriendRequestResponse
    let viewModel: FriendRequestViewModel
    
    var body: some View {
        HStack {
            AvatarView(photoUrl: request.photoUrl)
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipped()
            
            Spacer().frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(request.senderUserName)
                    .foregroundStyle(.textGray)
                    .font(.title)
                    .bold()
                
                HStack {
                    if handleState == .pending {
                        Text("Accept")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .frame(minWidth: 0, maxWidth: 200)
                            .onTapGesture {
                                viewModel.acceptRequest(request) { result in
                                    switch result {
                                    case .success:
                                        self.handleState = .accepted
                                    case .failure(let error):
                                        print("Accept error: \(error)")
                                    }
                                }
                            }
                        Spacer()
                        Text("Decline")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(minWidth: 0, maxWidth: 200)
                            .onTapGesture {
                                viewModel.declineRequest(request) { result in
                                    switch result {
                                    case .success:
                                        self.handleState = .declined
                                    case .failure(let error):
                                        print("Decline error: \(error)")
                                    }
                                }
                            }
                    } else if handleState == .accepted {
                        Text("Request is accepted!")
                    } else {
                        Text("Request is declined!")
                    }
                }
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview{
    NavigationStack{
        FriendRequestView()
    }
}
