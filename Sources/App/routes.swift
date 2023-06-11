import Vapor
import Foundation

struct CreateOrder: Content {
    var clientId: String
    var amount: Double
}

struct Order: Content {
    var id: String
    var clientId: String
    var amount: Double
}

func routes(_ app: Application) throws {
    var orders: [Order] = []

    app.get("orders") { req -> [Order] in
        return orders
    }

    app.get("orders", ":orderId") { req throws -> Order in
        guard let orderId = req.parameters.get("orderId") else {
            throw Abort(.badRequest, reason: "Provide orderId as path param")
        }
        let order = orders.first(where: {$0.id == orderId})
        guard let order else {
            throw Abort(.notFound, reason: "Order not found")
        }
        return order
    }

    app.post("orders") { req throws -> Order in
        let orderData = try req.content.decode(CreateOrder.self)

        let orderId = UUID()
        let newOrder = Order(id: orderId.uuidString, clientId: orderData.clientId, amount: orderData.amount)

        orders.append(newOrder)

        return newOrder
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}



