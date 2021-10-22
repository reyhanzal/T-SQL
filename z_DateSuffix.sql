SELECT FORMAT(GETDATE(), 'dddd, MMMM') + ' '
+ FORMAT(GETDATE(), 'dd'
+ IIF(DAY(GETDATE()) IN (1, 21, 31), '''st'''
 ,IIF(DAY(GETDATE()) IN (2, 22), '''nd'''
 ,IIF(DAY(GETDATE()) IN (1, 21, 31), '''rd'''
 ,'''th'''))))
