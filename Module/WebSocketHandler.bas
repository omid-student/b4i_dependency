﻿Type=Class
Version=4
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Class module
#Event: Connected
#Event: Closed (Reason As String)
Sub Class_Globals
	Public ws As WebSocket
	Private CallBack As Object
	Private EventName As String
End Sub

Public Sub Initialize (vCallback As Object, vEventName As String)
	CallBack = vCallback
	EventName = vEventName
	ws.Initialize("ws")
End Sub

Public Sub Connect(Url As String)
	ws.Connect(Url)
End Sub

Public Sub Close
	If ws.Connected Then ws.Close
End Sub

'Raises an event on the server. The Event parameter must include an underscore
Public Sub SendEventToServer(Event As String, Data As Map)
	Dim m As Map
	m.Initialize
	m.Put("type", "event")
	m.Put("event", Event)
	m.Put("params", Data)
	Dim jg As JSONGenerator
	jg.Initialize(m)
	ws.SendText(jg.ToString)
End Sub

Private Sub ws_TextMessage(msg As String)
	Try
		Dim jp As JSONParser
		jp.Initialize(msg)
		Dim m As Map = jp.NextObject
		Dim etype As String = m.get("etype")
		Dim params As List = m.get("value")
		Dim event As String = m.get("prop")
		If etype = "runFunction" Then
			CallSub2(CallBack, EventName & "_" & event, params)
		Else If etype = "runFunctionWithResult" Then
			Dim data As Map = CallSub2(CallBack, EventName & "_" & event, params)
			Dim jg As JSONGenerator
			jg.Initialize(CreateMap("type": "data", "data": data))
			ws.SendText(jg.ToString)
		End If
	Catch
		Log("TextMessage Error: " & LastException)
	End Try
End Sub

Private Sub ws_Connected
	CallSub(CallBack,  EventName & "_Connected")
End Sub

Private Sub ws_Closed (Reason As String)
	CallSub2(CallBack, EventName & "_Closed", Reason)
End Sub