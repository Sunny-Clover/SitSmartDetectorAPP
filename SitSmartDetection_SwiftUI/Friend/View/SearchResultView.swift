//
//  SearchResultView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/2/6.
//

import SwiftUI
import Combine


class SearchViewModel: ObservableObject {
    // 搜尋結果，這邊假設結果是一組字串
    @Published var results: [UserSearchResponse] = []
    private var cancellables = Set<AnyCancellable>()
    /// 模擬資料庫搜尋
    func search(query: String) {
        // query 要trim，或是檢查長度，但UserName我也不確定有多長
        FriendService.shared.searchUser(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching leaderboard: \(error)")
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.results = response
                }
            )
            .store(in: &cancellables)
    }
    
    func sendRequest(userID: Int, completion: @escaping (Result<Void, Error>) -> Void){
        FriendService.shared.sendFriendRequest(userID: userID, completion: completion)
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            // 顯示搜尋結果的清單
            if viewModel.results.isEmpty {
                Text("尚無搜尋結果")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.results, id: \.self.userID) { result in
                    SearchResultRowView(searchResult: result, viewModel: viewModel)
                }
                .listStyle(PlainListStyle())
            }
        }
        .toolbar {
            // 將輸入框放在導覽列中間的位置（principal）
            ToolbarItem(placement: .principal) {
                TextField("Search...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .padding(.horizontal)  // 加上左右間距
                    // 當使用者按下 return 時，觸發搜尋
                    .onSubmit {
                        viewModel.search(query: searchText)
                    }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

struct SearchResultRowView: View {
    @State var searchResult:UserSearchResponse
    let viewModel: SearchViewModel
    
    var body: some View {
        HStack {
            AvatarView(photoUrl: searchResult.photoUrl)
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipped()
            
            Spacer().frame(width: 20)
            
            HStack {
                Text(searchResult.userName)
                    .foregroundStyle(.textGray)
                    .font(.title)
                    .bold()
                Spacer()
                if searchResult.userID == UserService.shared.userInfo?.userID{
                    // user himself or herself
                }else if searchResult.isFriend{
                    // already a friend
                }
                else {
                    switch searchResult.requestState {
                    case nil, "Declined": // Able to send
                        // should be press only once
                        Text("Send Request")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .frame(minWidth: 0, maxWidth: 200)
                            .onTapGesture {
                                viewModel.sendRequest(userID: searchResult.userID) { result in
                                    switch result {
                                    case .success:
                                        searchResult.requestState = "Pending"
                                    case .failure(let error):
                                        print("SendRequest error: \(error)")
                                    }
                                }
                            }
                    case "Pending":
                        Text("Pending")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(minWidth: 0, maxWidth: 200)
                    case "Accepted":
                        EmptyView()
                    default:
                        EmptyView()
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
