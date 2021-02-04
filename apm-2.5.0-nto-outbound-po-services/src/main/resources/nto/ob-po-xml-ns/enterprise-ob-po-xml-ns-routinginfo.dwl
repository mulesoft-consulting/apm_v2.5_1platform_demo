%dw 2.0
output application/json
ns ns0 http://xmlns.mulesoft.com/enterpriseobjects/finance/purchaseorder/
---
{
	partnerReferenceId: payload.ns0#PurchaseOrder.ns0#VendorName,
	hostReferenceId: payload.ns0#PurchaseOrder.ns0#LineOfBusiness,
	businessDocumentKey: payload.ns0#PurchaseOrder.ns0#PONumber
}