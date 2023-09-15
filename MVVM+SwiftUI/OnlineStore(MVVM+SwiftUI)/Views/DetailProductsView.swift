//
//  DetailProductsView.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import SwiftUI

struct DetailProductsView: View {
    
    @ObservedObject var detailProductsViewModel : DetailProductsViewModel
    @Binding var tabbBarHidden: Bool
    @State var isQuantityStackHidden: Bool = true
    @State private var isShowingAlert = false
    @State var alertMessage: String = ""
    var parentViewName: String
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                AsyncImage(url: URL(string: detailProductsViewModel.product.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                } placeholder: {
                    Image("default")
                        .frame(width: 300, height: 300)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(detailProductsViewModel.product.title)
                        .font(.system(size: 20, weight: .regular))
                    Text(String(detailProductsViewModel.product.price)+"$")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.indigo)
                    Text(detailProductsViewModel.product.description)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.gray)
                }
            }.padding(.top, -40)
            .padding(15)
              .padding([.leading, .trailing], 8)
        }.padding(.bottom, parentViewName == "ProductsView" ? 10 : 0)
            .safeAreaInset(edge: .bottom, content: {
                if parentViewName == "ProductsView" {
                    ZStack {
                        HStack {
                            Button {
                                detailProductsViewModel.addToCart()
                                handleQuantity()
                            } label: {
                                Text("Add to cart")
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gradientBackgroundColor)
                                    .cornerRadius(16)
                                    .foregroundColor(Color.white)
                                    .frame(alignment: .trailing)
                            }
                            // quantity stack
                            HStack {
                                Button {
                                    decreaseQuantity()
                                } label: {
                                    Image(systemName: "minus")
                                }
                                Text(String("\(detailProductsViewModel.product.quantity ?? 0)"))
                                    .onAppear {
                                        print(detailProductsViewModel.product.quantity ?? 0)
                                    }
                                    .foregroundColor(.indigo)
                                Button {
                                    increaseQuantity()
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }.frame(width: 80, height: 50)
                                .isHidden(isQuantityStackHidden ? true : false, remove: true)
                        }.frame(alignment: .leading)
                            .padding(.bottom, 15)
                    }.frame(width: 270)
                }
            })
            .toolbar(tabbBarHidden ? .hidden : .visible, for: .tabBar)
            .onAppear {
                getCartProductQuantity()
                handleQuantity()
              tabbBarHidden = true
            }
            .onReceive(detailProductsViewModel.$error) { newError in
                if let error = newError {
                    if error != .cartProductNotFound {
                        self.isShowingAlert = true
                    }
                } else {
                    self.isShowingAlert = false
                }
            }
            .alert(detailProductsViewModel.errorMessage(for: detailProductsViewModel.error ?? .coreDataError), isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) {
                    isShowingAlert = false
                }
            }
    }
    
    func increaseQuantity() {
        if let quantity = detailProductsViewModel.product.quantity {
            detailProductsViewModel.editCartProductQuantity(newQuantity: quantity + 1)
        } else {
            isShowingAlert = true
            alertMessage = detailProductsViewModel.errorMessage(for: .quantityEditingError)
        }
        
        handleQuantity()
    }
    
    func decreaseQuantity() {
        detailProductsViewModel.getCartProductQuantity()
        
        if let quantity = detailProductsViewModel.product.quantity {
            detailProductsViewModel.editCartProductQuantity(newQuantity: quantity - 1)
        } else {
            isShowingAlert = true
            alertMessage = detailProductsViewModel.errorMessage(for: .quantityEditingError)
        }
        
        handleQuantity()
    }
    
    func handleQuantity() {
        if detailProductsViewModel.product.quantity == nil || detailProductsViewModel.product.quantity == 0 {
            isQuantityStackHidden = true
        } else {
            isQuantityStackHidden = false
        }
    }
    func getCartProductQuantity() {
        detailProductsViewModel.getCartProductQuantity()
    }
}

//struct DetailProductsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailProductsView(detailProductsViewModel: DetailProductsViewModel(product: Product.sampleProduct), parentViewName: "ProductsView")
//   }
//}
