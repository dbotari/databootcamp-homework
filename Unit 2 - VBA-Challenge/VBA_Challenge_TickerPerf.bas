Attribute VB_Name = "Module1"
Sub TickerPerf()

For Each ws In Worksheets

' Set an initial variable for Ticker
  Dim Ticker As String

' Keep track of the location for each Ticker in the summary table
  Dim Summary_Table_Row As Integer
  Summary_Table_Row = 2
 
 
  ' Created a Variable to Hold File Name, Last Row, Last Column, and Year
    Dim WorksheetName As String

  ' Grabbed the WorksheetName
    WorksheetName = ws.Name
    
  ' Set an initial variable for holding the Open_Price, Close_Price, Tot_Volume per Ticker
    Dim Open_Price, Close_Price, Tot_Volume, Yoychange, Percent_change As Double
    Open_Price = Close_Price = Tot_Volume = Yoychange = Percent_change = Great_incr = Great_decr = Great_Vol = Max_Vol = 0

  ' Setup Headers for Summary Table
    ws.Range("J1").Value = "Ticker"
    ws.Range("J1").Font.Bold = True
    ws.Range("k1").Value = "Yearly Change"
    ws.Range("k1").Font.Bold = True
    ws.Range("l1").Value = "Percent Change"
    ws.Range("l1").Font.Bold = True
    ws.Range("m1").Value = "Total Volume Traded"
    ws.Range("m1").Font.Bold = True
    ws.Range("O2").Value = "Greatest % Increase"
    ws.Range("O2").Font.Bold = True
    ws.Range("O3").Value = "Greatest % Decrease"
    ws.Range("O3").Font.Bold = True
    ws.Range("O4").Value = "Greatest Total Volume"
    ws.Range("O4").Font.Bold = True
    ws.Range("P1").Value = "Ticker"
    ws.Range("P1").Font.Bold = True
    ws.Range("Q1").Value = "Value"
    ws.Range("Q1").Font.Bold = True

   ' Determine lastrow and lastcolumn of worksheet
    LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    lastcolumn = ws.Cells(1, Columns.Count).End(xlToLeft).Column
    
    Open_Price = ws.Cells(2, 3).Value
   
  ' Loop through all observation
      For i = 2 To LastRow

    
      ' Check if we are still within the same Ticker.
        If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then

        ' Set the Ticker
          Ticker = ws.Cells(i, 1).Value
          
          Close_Price = ws.Cells(i, 6).Value
          Yoychange = Close_Price - Open_Price
          
          If Open_Price <> 0 Then
            Percent_change = Yoychange / Open_Price
          Else
            Percent_change = 0
          End If
          
          Open_Price = ws.Cells(i + 1, 3).Value

        ' Add to the Tot_Volume
          Tot_Volume = Tot_Volume + ws.Cells(i, 7).Value

        ' Print the Ticker in the Summary Table
          ws.Range("j" & Summary_Table_Row).Value = Ticker

        ' Print the Ticker Year over Year Change in the Summary Table
          ws.Range("l" & Summary_Table_Row).NumberFormat = "0.00000"
          ws.Range("k" & Summary_Table_Row).Value = Yoychange
          
          If (ws.Range("k" & Summary_Table_Row).Value > 0) Then
            ws.Range("k" & Summary_Table_Row).Interior.ColorIndex = 4
          ElseIf (ws.Range("k" & Summary_Table_Row).Value < 0) Then
            ws.Range("k" & Summary_Table_Row).Interior.ColorIndex = 3
          End If

        ' Print the Ticker Percent Change in the Summary Table
          ws.Range("l" & Summary_Table_Row).NumberFormat = "0.00%"
          ws.Range("l" & Summary_Table_Row).Value = Percent_change

        ' Print the Tot_Volume to the Summary Table
          ws.Range("m" & Summary_Table_Row).Value = Tot_Volume

        ' Add one to the summary table row
          Summary_Table_Row = Summary_Table_Row + 1
        
        ' Reset the Open_Price, Close_Price and Tot_Volume
          Close_Price = 0
          Yoychange = 0
          Percent_change = 0
          Tot_Volume = 0

        ' If the cell immediately following a row is the same Ticket.
        Else

          ' Add to the Tot_Volume
            Tot_Volume = Tot_Volume + ws.Cells(i, 7).Value

        End If

     Next i
     
     'Determine lastrow and lastcolumn of worksheet
      LastRow2 = ws.Cells(Rows.Count, 11).End(xlUp).Row
      
      ' Loop through all observation
        For j = 2 To LastRow2
        
          If (ws.Range("L" & j).Value > Great_incr) Then
            Great_incr = ws.Range("L" & j).Value
            Ticker_incr = ws.Range("J" & j).Value
            
          End If
        
          If (ws.Range("L" & j).Value < Great_decr) Then
            Great_decr = ws.Range("L" & j).Value
            Ticker_decr = ws.Range("J" & j).Value
            
          End If
        
          If (ws.Range("M" & j).Value > Max_Vol) Then
            Max_Vol = ws.Range("M" & j).Value
            Ticker_maxvol = ws.Range("J" & j).Value
            
          End If
          
        Next j
        
        'Great_incr = WorksheetFunction.Max(ws.Range("L2:L" & LastRow2))
        'Ticker_incr = WorksheetFunction.Match(Great_incr, ws.Range("L2:L" & LastRow2), 0)
        
        'Great_decr = WorksheetFunction.Min(ws.Range("L2:L" & LastRow2))
        'Ticker_decr = WorksheetFunction.Match(Great_decr, ws.Range("L2:L" & LastRow2), 0)
        
        'Max_Vol = WorksheetFunction.Max(ws.Range("M2:M" & LastRow2))
        'Ticker_maxvol = WorksheetFunction.Match(Max_Vol, ws.Range("M2:M" & LastRow2), 0)
        
        
        
        'Print the Greatest % increase, Greatest % decrease, Max volume and Ticker in the Second Summary Table
          ws.Range("P2").Value = Ticker_incr 'ws.Cells(Great_incr - 2, 1)
          ws.Range("Q2").NumberFormat = "0.00%"
          ws.Range("Q2").Value = Great_incr
          ws.Range("P3").Value = Ticker_decr 'ws.Cells(Great_decr - 2, 1)
          ws.Range("Q3").NumberFormat = "0.00%"
          ws.Range("Q3").Value = Great_decr
          ws.Range("P4").Value = Ticker_maxvol 'ws.Cells(Max_Vol - 2, 1)
          ws.Range("Q4").Value = Max_Vol

          Great_incr = 0
          Great_decr = 0
          Max_Vol = 0
        
  Next ws

End Sub



