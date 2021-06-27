function Get-MessageReadEvents{
	Param(
		[parameter(Mandatory=$true,Position=1)]
		[string]$Mailbox,
		[parameter(Mandatory=$true,Position=1)]
		[string]$MessageId
		)

	$Message = Search-MessageTrackingReport -Identity $Mailbox -MessageId $MessageID -BypassDelegateChecking

	$TrackingReport = Get-MessageTrackingReport -Identity $Message.MessageTrackingReportId -BypassDelegateChecking
	$RecipienttrackingEvents = @($TrackingReport | Select -ExpandProperty RecipientTrackingEvents)

	$ReadEvents = @()
	$Recipients = $RecipienttrackingEvents | select RecipientAddress
	foreach ($Recipient in $Recipients) {
		$Events = Get-MessageTrackingReport -Identity $Message.MessageTrackingReportId -BypassDelegateChecking -RecipientPathFilter $Recipient.RecipientAddress -ReportTemplate RecipientPath
		$ReadEventsline = $Events.RecipientTrackingEvents[-1] | Select RecipientAddress,Status,EventDescription
		$ReadEvents += $ReadEventsline
	}
	return $ReadEvents
}