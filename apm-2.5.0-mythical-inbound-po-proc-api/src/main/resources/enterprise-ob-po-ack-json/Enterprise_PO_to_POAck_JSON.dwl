%dw 2.0
output application/json
---
{
	B2BMessage: {
		Data: {
			NetSuitePOAck: {
				Shipment: {
					Orders: {
						Order: {
							OrderReferences: {
								RefType: "PONumber",
								RefValue: payload.PurchaseOrder.PONumber
							},
							Items: payload.PurchaseOrder.POLineItems map (item, index) -> {
								Item: {
									ItemReference: [{
										RefType: "POLineNumber",
										RefValue: item.LineNum
									},
									{
										RefType: "ItemNumber",
										RefValue: item.SupplierItemNum
									},
									{
										RefType: "ShipQuantity",
										RefValue: item.Quantity
									},
									{
										RefType: "QuantityUOM",
										RefValue: "CT"
									}],
									Locations: [{
										Address: {
											AddressLine1: item.POLineLocation.ShipToLocation.Address.AddressLine1,
											State: item.POLineLocation.ShipToLocation.Address.State,
											PostalCode: item.POLineLocation.ShipToLocation.Address.PostalCode,
											City: item.POLineLocation.ShipToLocation.Address.City
										},
										LocationId: item.POLineLocation.ShipToLocation.ShipToLocationCode,
										"@role": "SHIP TO"
									},
									{
										Address: {
											AddressLine1: "500 Parkview Drive",
											State: "WI",
											PostalCode: "54301",
											City: "Green Bay"
										},
										LocationId: "77292237",
										"@role": "SHIP FROM"
									}]
								}
							}
						}
					}
				},
				POAckHeader: {
					ReceiverId: payload.PurchaseOrder.CustomerId,
					CustomerId: payload.PurchaseOrder.CustomerId,
					SenderId: "MYTHICAL SUPPLIER, LLC",
					DueDate: payload.PurchaseOrder.PODate
				}
			}
		},
		B2BHeader: {
			Sender: "MYTHICAL SUPPLIER, LLC",
			Receiver: payload.PurchaseOrder.CustomerId,
			MessageType: "PO-ACK",
			CreatedDateTime: now() as String,
			BusinessKey: payload.PurchaseOrder.PONumber
		}
	}
}