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
    
    private let getTransactions: () async -> [DataTransaction<UserEventLog>]
    private let rollbackToBefore: (DataTransaction<UserEventLog>) async -> ()
    private let rollbackToAfter: (DataTransaction<UserEventLog>) async -> ()

    @State private var transactions: [DataTransaction<UserEventLog>] = []
    
    var body: some View {
        List {
            if transactions.count == 0 {
                Text("No Transactions in this session.")
            }
            
            Button {
                print("\(transactions.asJsonString() ?? "NULL")")
            } label: {
                Text("Print")
            }
            
            ForEach(transactions) { transaction in
                
                VStack(alignment: .leading) {
                    Text(transaction.data.label)
                    Text(transaction.timestamp.formatted())
                        .opacity(0.6)
                }
                .contextMenu {
                    Button {
                        Task {
                            await repository.tasks.rollbackTo(after: transaction)
                            transactions = await getTransactions()
                        }
                    } label: {
                        Text("Rollback to After")
                    }
                    
                    Button {
                        Task {
                            await rollbackToBefore(transaction)
                            transactions = await getTransactions()
                        }
                    } label: {
                        Text("Rollback to Before")
                    }
                }
            }
        }
        .navigationTitle("Transactions")
        .listStyle(.inset)
        
        .task { transactions = await getTransactions() }
        .refreshable { transactions = await getTransactions() }
    }
    
    init(
        getTransactions: @escaping () async -> [DataTransaction<UserEventLog>]
        , rollbackToBefore: @escaping (DataTransaction<UserEventLog>) async -> ()
        , rollbackToAfter: @escaping (DataTransaction<UserEventLog>) async -> ()

    ) {
        self.getTransactions = getTransactions
        self.rollbackToBefore = rollbackToBefore
        self.rollbackToAfter = rollbackToAfter
    }
}

//#Preview {
//    TransactionHistoryScreen()
//}

