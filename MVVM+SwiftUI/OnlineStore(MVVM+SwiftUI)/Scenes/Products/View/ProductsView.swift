//
//  ContentView.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import SwiftUI

struct ProductsView: View {
    
    // MARK: Properties
    
    @StateObject var productsViewModel = ProductsViewModel()
    @State var selectedIndex = 0
    @State var showDetailView: Bool = false
    @State private var selectedProductForBottomSheet: Product? = nil
    @State private var selectedProductForSubview: Product? = nil
    @State var isPressed = false
    @State private var isShowingAlert = false
    @State var selectedCategory: String = "Select category"
    @State var tabbBarHidden: Bool = false
    
    // MARK: Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Menu {
                    Picker("Select category", selection: $selectedIndex) {
                        ForEach(0..<self.productsViewModel.categories.count, id: \.self) {
                            Text(productsViewModel.categories[$0])
                        }
                    }
                    .onChange(of: selectedIndex) { index in
                        let string = self.productsViewModel.categories[index].lowercased() == "all" ? nil : self.productsViewModel.categories[index].lowercased()
                        if let stringCategory = string {
                            productsViewModel.fetchProductsByCategoryCombine(category: stringCategory)
                        } else {
                            productsViewModel.fetchProductsCombine()
                        }
                        selectedCategory = productsViewModel.categories[index]
                    }.labelsHidden()
                        .pickerStyle(InlinePickerStyle())
                } label: {
                    HStack {
                        Text(selectedCategory)
                        Image(systemName: "chevron.right")
                            .renderingMode(.template)
                            .foregroundColor(Color(uiColor: UIColor.lightGray))
                            .frame(width: 10, height: 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .foregroundColor(Color.init(uiColor: UIColor.lightGray))
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding([.leading, .trailing, .bottom], 30)
                .frame(maxHeight: 80)
                .background(Color(uiColor: UIColor.secondarySystemBackground))
                
                List(productsViewModel.products) {
                    product in
                    HStack {
                        ZStack {
                            ProductListRow(product: product)
                                .padding([.leading, .trailing], 30)
                                .padding(.top, 10)
                                .padding(.bottom, 30)
                            NavigationLink(destination:   DetailProductsView(detailProductsViewModel: .init(product: product), tabbBarHidden: $tabbBarHidden, parentViewName: "ProductsView"))     {
                                EmptyView()
                            }.opacity(0)
                        }
                    }.listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                        .listRowInsets(EdgeInsets())
                        .background(Color.init(uiColor: UIColor.secondarySystemBackground))
               }.listStyle(PlainListStyle())
                .frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                .scrollContentBackground(.hidden)
                .background(Color.init(uiColor: UIColor.secondarySystemBackground))
                .blur(radius: isPressed ? 20 : 0)
                .overlay {
                    if productsViewModel.isLoading {
                        ProgressView("Loading")
                    }
                }
                .navigationBarTitle("Products", displayMode: .automatic)
                .onAppear {
                    productsViewModel.fetchProductsCombine()
                    tabbBarHidden = false
                }
            }
            .frame(maxWidth: .infinity)
            .onReceive(productsViewModel.$error) { newError in
                if newError != nil {
                    self.isShowingAlert = true
                }
                else {
                    self.isShowingAlert = false
                }
            }
            .alert(productsViewModel.errorMessage(for: productsViewModel.error ?? .networkError), isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) {
                    isShowingAlert = false
                }
            }
        }.background(Color.init(uiColor: UIColor.secondarySystemBackground))
    }
    
    // MARK: Methods
    
    func handleTap(product: Product) {
        self.showDetailView = true
        self.selectedProductForBottomSheet = product
    }
}

// MARK: Products List Row

struct ProductListRow: View {
    var product: Product
    var body: some View {
        ZStack {
            VStack {
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                }
            placeholder: {
                Image("default")
                    .frame(width: 220, height: 220)
            }
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.top, 10)
                    Text(String("Price: \(product.price)$"))
                        .padding(.top, 1)
                        .foregroundColor(.indigo)
                        .font(.system(size: 16, weight: .regular))
                }.padding([.leading, .trailing], 21 )
            }
        }.padding(.vertical, 20)
         .frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all)
         .background(Color.white)
         .cornerRadius(10)
    }
}

struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

// MARK: Products Previews

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
