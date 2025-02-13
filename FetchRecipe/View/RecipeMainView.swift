
// This view loads
// Title, App Store Rating, App Share
// Serach Bar
// Sorting, Filter
// Recipe List

import SwiftUI
import Lottie

// MAIN view
struct RecipeMainView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @StateObject private var filterViewModel = RecipeFilterViewModel()
    @State private var isCuisineFilterPresented = false
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                SearchAndFilterView(
                    searchText: $filterViewModel.searchText,
                    selectedSortOption: $filterViewModel.selectedSortOption,
                    selectedCuisines: $filterViewModel.selectedCuisines,
                    isCuisineFilterPresented: $isCuisineFilterPresented
                )
                
                RecipeContentView(
                    viewModel: viewModel,
                    filteredRecipes: filterViewModel.filteredRecipes
                )
            }
            .toolbar {
                ToolbarView(showShareSheet: $showShareSheet)
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: ["Check out this awesome app!", URL(string: "https://apps.apple.com/app/id6741867800")!])
            }
            .task {
                await viewModel.fetchRecipes()
                filterViewModel.updateRecipes(viewModel.recipes)
            }
            .sheet(isPresented: $isCuisineFilterPresented) {
                CuisineMultiSelectView(
                    availableCuisines: filterViewModel.availableCuisines,
                    selectedCuisines: $filterViewModel.selectedCuisines
                )
            }
            .onChange(of: viewModel.recipes) { oldValue, newValue in
                filterViewModel.updateRecipes(newValue)
            }
        }
    }
}

// Toolbar View
struct ToolbarView: ToolbarContent {
    @Binding var showShareSheet: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                if let url = URL(string: "https://apps.apple.com/app/id6741867800?action=write-review") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Image(systemName: "star")
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showShareSheet = true }) {
                Image(systemName: "square.and.arrow.up")
            }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            Text("FetchRecipes")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.accentColor, .accentColor.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 2)
        }
    }
}


// Supporting Types
enum RecipeSortOption: String, CaseIterable {
    case nameAZ = "Name (A-Z)"
    case nameZA = "Name (Z-A)"
    case cuisineAZ = "Cuisine (A-Z)"
    case cuisineZA = "Cuisine (Z-A)"
}


// Search and Filter View
struct SearchAndFilterView: View {
    @Binding var searchText: String
    @Binding var selectedSortOption: RecipeSortOption
    @Binding var selectedCuisines: Set<String>
    @Binding var isCuisineFilterPresented: Bool
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $searchText)
            
            FilterOptionsView(
                selectedSortOption: $selectedSortOption,
                selectedCuisines: $selectedCuisines,
                isCuisineFilterPresented: $isCuisineFilterPresented
            )
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

// Search Bar View
struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("Search recipes...", text: $searchText)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Spacer()
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
            )
    }
}

// Sorting and Filter by Cuisine View
struct FilterOptionsView: View {
    @Binding var selectedSortOption: RecipeSortOption
    @Binding var selectedCuisines: Set<String>
    @Binding var isCuisineFilterPresented: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            // Sorting
            Menu {
                ForEach(RecipeSortOption.allCases, id: \.self) { option in
                    Button(action: { selectedSortOption = option }) {
                        Text(option.rawValue)
                    }
                }
            } label: {
                HStack {
                    Text(selectedSortOption.rawValue)
                    Image(systemName: "chevron.down")
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .bold()
            }
            
            // Filter By Cuisine
            Button(action: { isCuisineFilterPresented = true }) {
                HStack {
                    Text(selectedCuisines.isEmpty ? "All Cuisines" : "\(selectedCuisines.count) Selected")
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

// Cuisine Multi-Select View
struct CuisineMultiSelectView: View {
    let availableCuisines: [String]
    @Binding var selectedCuisines: Set<String>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(availableCuisines, id: \.self) { cuisine in
                    HStack {
                        Text(cuisine)
                        Spacer()
                        if selectedCuisines.contains(cuisine) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedCuisines.contains(cuisine) {
                            selectedCuisines.remove(cuisine)
                        } else {
                            selectedCuisines.insert(cuisine)
                        }
                    }
                }
            }
            .navigationTitle("Filter by Cuisine")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedCuisines.removeAll()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


// Recipe Content View
struct RecipeContentView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    let filteredRecipes: [Recipe]
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Recipes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                ErrorView(error: error) {
                    Task {
                        await viewModel.fetchRecipes()
                    }
                }
            } else if filteredRecipes.isEmpty {
                LottieView(animation: .named("EmptyAnimation"))
                    .playing(loopMode: .loop)
            } else {
                RecipeListView(recipes: filteredRecipes)
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
            }
        }
    }
}

// Error View
struct ErrorView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(error)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Recipe List View
struct RecipeListView: View {
    let recipes: [Recipe]

    var body: some View {
        List(recipes) { recipe in
            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                HStack {
                    AsyncImage(url: recipe.photoUrlSmall) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(12)
                                .clipped()
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .frame(width: 80, height: 80)
                        } else {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
