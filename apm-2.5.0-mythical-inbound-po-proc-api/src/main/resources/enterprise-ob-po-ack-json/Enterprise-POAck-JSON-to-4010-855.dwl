%dw 2.0
output application/java
---
{
	TransactionSets: {
		v004010: {
			"855": [{
				Heading: {
					"020_BAK": {
						BAK01: "00",
						BAK02: "AT",
						BAK03: payload.B2BMessage.B2BHeader.BusinessKey,
						BAK04: now() as Date {
							format : "yyyyMMdd"
						}
					},
					"150_DTM": [{
						DTM01: "003",
						DTM02: payload.B2BMessage.Data.NetSuitePOAck.POAckHeader.DueDate as Date,
						DTM03: "000000" as Number
					}]
				},
				Detail: {
					"010_PO1_Loop": payload.B2BMessage.Data.NetSuitePOAck.Shipment.Orders.Order.Items.*Item map(item, itemidx) -> {

						"010_PO1": item.ItemReference reduce (itemref, acc = {
						}) -> acc ++ {
							(PO101: itemref.RefValue) if(itemref.RefType == "POLineNumber"),
							(PO103: itemref.RefValue) if(itemref.RefType == "QuantityUOM"),
							(PO102: itemref.RefValue as Number) if(itemref.RefType == "ShipQuantity"),
							PO106: "BP",
							(PO107: itemref.RefValue) if(itemref.RefType == "ItemNumber")
						},
						"100_REF": [{
							REF01: "PO",
							REF02: if ( payload.B2BMessage.Data.NetSuitePOAck.Shipment.Orders.Order.OrderReferences.RefType == "PONumber" ) payload.B2BMessage.Data.NetSuitePOAck.Shipment.Orders.Order.OrderReferences.RefValue else ""
						}],
						"370_N1_Loop": item.Locations map(location, index) -> {
							"370_N1": {
								N101: if ( location."@role" == "SHIP FROM" ) "SF" else if ( location."@role" == "SHIP TO" ) "ST" else null,
								N103: "92",
								N104: location.LocationId
							},
							"390_N3": [{
								N301: location.Address.AddressLine1
							}],
							"400_N4": {
								N401: location.Address.City,
								N402: location.Address.State,
								N403: location.Address.PostalCode
							}
						}
					}
				},
				Summary: {
					"010_CTT_Loop": {
						"010_CTT": {
							CTT01: sizeOf(payload.B2BMessage.Data.NetSuitePOAck.Shipment.Orders.Order.Items.Item)
						}
					}
				}
			}]
		}
	}
}