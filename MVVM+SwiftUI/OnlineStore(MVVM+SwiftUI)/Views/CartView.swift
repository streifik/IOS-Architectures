//
//  CartView.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import SwiftUI

struct CartView: View {
    
    @ObservedObject var cartViewModel = CartViewModel()
    @State var showDetailView: Bool = false
    @State private var selectedProductForBottomSheet: CartProduct? = nil
    @State private var isShowingAlert = false
    @State var tabbBarHidden: Bool = false
    
    var body: some View {
        ZStack {
        NavigationStack {
            List(cartViewModel.cartProducts) {
                product in
                CartListRow(cartViewModel: cartViewModel, product: product)
                    .navigationDestination(isPresented: $showDetailView) {
                        DetailProductsView(detailProductsViewModel: .init(cartProduct: product), tabbBarHidden: $tabbBarHidden, parentViewName: "CartView")
                    }
                    .onTapGesture {
                        handleTap(product: product)
                    }
            }
            .onAppear {
                cartViewModel.fetchData()
                tabbBarHidden = false
            }
            .onReceive(cartViewModel.$error) { newError in
                if let error = newError {
                    if error != .cartProductNotFound {
                        self.isShowingAlert = true
                    }
                } else {
                    self.isShowingAlert = false
                }
            }
            .alert(cartViewModel.errorMessage(for: cartViewModel.error ?? .coreDataError), isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) {
                    isShowingAlert = false
                }
            }
            .navigationTitle("Cart")
            .overlay(Group {
                if cartViewModel.cartProducts.isEmpty {
                    ZStack {
                        Color.init(uiColor: UIColor.secondarySystemBackground)
                        VStack {
                            ZStack {
                                Color.init(uiColor: UIColor.systemGray3)
                                    .cornerRadius(10)
                                    .frame(width: 170, height: 45, alignment: .center)
                                Text("Cart is empty")
                                    .font(.system(size: 15))                          .foregroundColor(Color.white)
                                    .padding([.top, .bottom, .leading, .trailing])
                            }
                        }
                        .frame(width: 170, height: 45, alignment: .center)
                    }
                }
            })
        }
    }
    }
    
    // MARK: Methods
    
    func handleTap(product: CartProduct) {
        self.showDetailView = true
        self.selectedProductForBottomSheet = product
    }
}

struct CartListRow: View {
    @StateObject var cartViewModel = CartViewModel()
    @State var product = CartProduct()
    
    var body: some View {
        ZStack {
            Color.white.cornerRadius(10)
            HStack {
                HStack(spacing: 20) {
                    if let image = product.image {
                        AsyncImage(url: URL(string: image)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        } placeholder: {
                            Image("default")
                                .frame(width: 0, height: 80)
                                .cornerRadius(100)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(product.title)
                            .font(.system(size: 15, weight: .regular))
                            .padding(.bottom, 10)
                        Text(String(product.price)+"$").foregroundColor(Color.indigo)
                            .font(.system(size: 14, weight: .regular))
                    }
                }
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            let newQuantity = product.quantity + 1
                            cartViewModel.editProductQuantity(product: product, quantity: Int(newQuantity))
                            cartViewModel.fetchData()
                        }) {
                            Label("", systemImage: "plus")
                        }.buttonStyle(BorderlessButtonStyle())

                        Text(String(product.quantity))
                        .padding(.leading, 8)
                    Button(action: {
                        let newQuantity = product.quantity - 1
                        cartViewModel.editProductQuantity(product: product, quantity: Int(newQuantity))
                        cartViewModel.fetchData()
                    }) {
                        Label("", systemImage: "minus")
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }.padding([.top, .bottom, .leading, .trailing], 15)
        }.padding([.top, .bottom], 10)
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all)
            .listRowInsets(EdgeInsets())
            .background(Color.init(uiColor: UIColor.secondarySystemBackground))
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
