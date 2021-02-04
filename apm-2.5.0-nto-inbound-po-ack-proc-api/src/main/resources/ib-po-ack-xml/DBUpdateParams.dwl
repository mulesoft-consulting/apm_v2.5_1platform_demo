%dw 2.0
output application/json
ns ns0 http://xmlns.mulesoft.com/enterpriseobjects/v1
---
{
	poNumber: payload.ns0#B2BMessage.ns0#B2BHeader.ns0#BusinessKey,
	ackReceiver: payload.ns0#B2BMessage.ns0#Data.ns0#NetSuitePOAck.ns0#POAckHeader.ns0#ReceiverId,
	ackSender: payload.ns0#B2BMessage.ns0#Data.ns0#NetSuitePOAck.ns0#POAckHeader.ns0#SenderId,
	ackStatus: "ACK-RECEIVED",
	ackDttm: now() as DateTime {format: "yyyy-MM-dd HH:mm:ss"}
}