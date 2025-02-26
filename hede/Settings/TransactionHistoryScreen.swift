//
//  TransactionHistoryScreen.swift
//  hede
//
//  Created by Kevin Kelly on 1/20/25.
//

import SwiftUI
import Storage
import Database

struct TransactionHistoryScreen: View {
    @Environment(\.repository) private var repository
    
    @State private var transactions: [DataTransaction<UserEventLog>] = []
    
    var body: some View {
        List {
            if transactions.count == 0 {
                Text("No Transactions in this session")
            }
            
            ForEach(transactions) { transaction in
                
                VStack(alignment: .leading) {
                    Text(transaction.data.label)
                    //                    .font(F.body)
                    Text(transaction.timestamp.formatted())
                        .opacity(0.6)
                }
                .contextMenu {
                    Button {
                        Task {
                            await repository.tasks.rollbackTo(after: transaction)
                            transactions = await repository.tasks.getTransactions()
                        }
                    } label: {
                        Text("Rollback to After")
                    }
                    
                    Button {
                        Task {
                            await repository.tasks.rollbackTo(before: transaction)
                            transactions = await repository.tasks.getTransactions()
                        }
                    } label: {
                        Text("Rollback to Before")
                    }
                }
            }
        }
        .navigationTitle("Transactions")
        .listStyle(V.listStyle)
        
        .task { transactions = await repository.tasks.getTransactions() }
        .refreshable { transactions = await repository.tasks.getTransactions() }
    }
}

#Preview {
    TransactionHistoryScreen()
}

