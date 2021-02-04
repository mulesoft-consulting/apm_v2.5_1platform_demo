%dw 2.0
output application/java
type BigDecimal = Number {class : "java.math.BigDecimal"}
ns ns0 http://xmlns.mulesoft.com/enterpriseobjects/finance/purchaseorder/
var approvedDate = payload.ns0#PurchaseOrder.ns0#PODate

---
{
	TransactionSets: {
		v004010: {
			"850": [{
				Heading: {
					"020_BEG": {
						BEG01: if(payload.ns0#PurchaseOrder.ns0#POPurpose == "New") "00" else "01",
						BEG02: "NE",
						BEG03: payload.ns0#PurchaseOrder.ns0#PONumber as String,
						BEG05: (approvedDate.year ++ approvedDate.month ++ approvedDate.day) as Date {format: "yyyyMMdd"}
					},
					"050_REF": [{
						REF01: "VR",
						REF02: payload.ns0#PurchaseOrder.ns0#VendorId as String
					}],
					"060_PER": [{
						PER01: "BD",
						PER02: payload.ns0#PurchaseOrder.ns0#BuyerName,
						PER03: "EM",
						PER04: payload.ns0#PurchaseOrder.ns0#BuyerEmailID
					}]
				},
				Detail: {
					"010_PO1_Loop": payload.ns0#PurchaseOrder.ns0#POLineItems.*ns0#POLineItem map (item, index) -> {
						"010_PO1": {
							PO101: item.ns0#LineNum,
							PO102: item.ns0#Quantity as Number,
							(PO103: "PH") if(item.ns0#UnitofMeasure == "Pack"),
							PO104: item.ns0#UnitPrice as BigDecimal,
							PO108: "MG",
							PO109: item.ns0#VendorItemNum
						},
						"050_PID_Loop": [{
							"050_PID": {
								PID01: "F",
								PID05: if(sizeOf(item.ns0#ItemDescription) > 79)item.ns0#ItemDescription[0 to 79] else item.ns0#ItemDescription
							}
						}],
						"350_N1_Loop": [{
							"350_N1": {
								N101: "ST",
								N102: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#ShipToLocationName,
								N103: "92",
								N104: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#ShipToLocationCode
							},
							"370_N3": [{
								N301: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#Address.ns0#AddressLine1,
								N302: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#Address.ns0#AddressLine2
							}],
							"380_N4": {
								N401: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#Address.ns0#City,
								N402: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#Address.ns0#State,
								N403: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#Address.ns0#PostalCode,
								N404: item.ns0#POLineLocation.ns0#ShipToLocation.ns0#Address.ns0#Country
							}
						}]
					}
				},
				Summary: {
					"010_CTT_Loop": {
						"010_CTT": {
							CTT01: sizeOf(payload.ns0#PurchaseOrder.ns0#POLineItems.*ns0#POLineItem)
						}
					}
				}
			
			}]}
		}
	
}