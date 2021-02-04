%dw 2.0
output application/json
ns ns0 http://xmlns.mulesoft.com/enterpriseobjects/finance/purchaseorder/
---
{
	PONumber: payload.ns0#PurchaseOrder.ns0#PONumber,
	NTOLob: payload.ns0#PurchaseOrder.ns0#LineOfBusiness,
	Supplier: payload.ns0#PurchaseOrder.ns0#VendorName
}