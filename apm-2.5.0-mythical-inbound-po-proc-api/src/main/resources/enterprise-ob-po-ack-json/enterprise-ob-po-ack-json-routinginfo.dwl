%dw 2.0
output application/json

---
{
	partnerReferenceId: payload.B2BMessage.B2BHeader.Receiver,
	hostReferenceId: payload.B2BMessage.B2BHeader.Sender,
	businessDocumentKey: payload.B2BMessage.B2BHeader.BusinessKey
}