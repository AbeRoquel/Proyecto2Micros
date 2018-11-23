#Interfaz proyecto
from Tkinter import*
import tkMessageBox
import random
import serial
import sys
from time import sleep
from math import log
from math import exp
global fondos
global fondos2
global actives
grabador1 = False
grabador2 = False
grabador3 = False
grabador4 = False
activar = False
servo1 = ''
servo2 = ''
servo3 = ''
servo4 = ''
fondos = 'chocolate1'
fondos2= 'RoyalBlue4'
actives = 'DarkGoldenrod1'

ser= serial.Serial(port='COM3',baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS, timeout=0)

#Create window & frames
class App:
     def __init__(self):
        global fondos
        global fondos2
        global actives
        self.raiz=Tk()
        self.raiz.title("Proyecto Final")
        self.raiz.config(bg="SteelBlue1")
        self._job = None
        miFrame=Frame()
        miFrame.pack()
#----------------------------------------Rutinas generales para grabar------------------------------------
        def Revisar():
             if grabador1==True:
                  almacenar1()
             elif grabador2==True:
                  almacenar2()
             elif grabador3==True:
                  almacenar3()
             else:
                  None
             self.raiz.after(500,Revisar)

        def a1macenar1():
             global servo1
             global servo2
             global servo3
             global servo4
             archivo1 = open('rutina1.txt','a')
             archivo.write(str(servo1)+',')
             archivo.write(str(servo2)+',')
             archivo.write(str(servo3)+',')
             archivo.write(str(servo4)+',')
             archivo1.close()

        def a1macenar2():
             global servo1
             global servo2
             global servo3
             global servo4
             archivo2 = open('rutina2.txt','a')
             archivo.write(str(servo1)+',')
             archivo.write(str(servo2)+',')
             archivo.write(str(servo3)+',')
             archivo.write(str(servo4)+',')
             archivo2.close()

        def a1macenar3():
             global servo1
             global servo2
             global servo3
             global servo4
             archivo = open('rutina3.txt','a')
             archivo.write(str(servo1)+',')
             archivo.write(str(servo2)+',')
             archivo.write(str(servo3)+',')
             archivo.write(str(servo4)+',')
             archivo3.close()
#------------------------------------------------Leer datos------------------------------------------------
        while activar == True:
             ser.flushInput()
             ser.flushOutput()
             time.sleep(.2)
             recibido = 
             
#------------------------------------------------Rutina boton grabar 1-------------------------------------
        def funBoton1():
            global grabador1
            global grabador2
            global grabador3
            global activar
            activar = True
            grabador1 = True
            grabador2 = False
            grabador3 = False
            Revisar()

#-------------------------------------------------------------------------------------------------------
        def funBoton2():
            None
#------------------------------------------------Rutina detener cualquier grabación-------------------
        def funBoton3():
             global grabador1
             global grabador2
             global grabador3
             grabador1=False
             grabador2=False
             grabador3=False
             
#------------------------------------------------Rutina boton grabar 2---------------------------------
        def funBoton4():
            global grabador1
            global grabador2
            global grabador3
            global activar
            activar = True
            grabador1 = False
            grabador2 = True
            grabador3 = False
            Revisar()
#------------------------------------------------------------------------------------------------------
        def funBoton5():
            None
        def funBoton6():
            None
#-----------------------------------------------Rutina boton grabar 3---------------------------------
        def funBoton7():
            global grabador1
            global grabador2
            global grabador3
            activar = True
            grabador1 = False
            grabador2 = False
            grabador3 = True
            Revisar()
#------------------------------------------------------------------------------------------------------
        def funBoton8():
            None
        def funBoton9():
            None
        def funBoton10():
            None
        def funBoton11():
            None
        def funBoton12():
            None
#-----------------------------------------------Interfaz------------------------------------------------------------------
        miFrame.config(bg=fondos, width ='1000', height = '600', bd=5, relief='groove')
        self.grabar1=Button(miFrame, text="Grabar", command=funBoton1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar1.place(x=500, y=200, anchor="center")
        self.grabar1.config(width="10", height="1")
        self.play1= Button(miFrame, text="Comenzar", command = funBoton2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play1.place(x=650, y=200, anchor="center")
        self.play1.config(width="10", height="1")
        self.detener1=Button(miFrame, text="Detener", command = funBoton3, bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detener1.place(x=800, y=200, anchor="center")
        self.detener1.config(width="10", height="1")
        self.detenerGrab1 = Button(miFrame, text="Detener Grab.", command=funBoton10,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab1.place(x=350, y=200, anchor="center")
        self.detenerGrab1.config(width="10", height="1")

        self.grabar2 = Button(miFrame, text="Grabar", command=funBoton4,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar2.place(x=500, y=300, anchor="center")
        self.grabar2.config(width="10", height="1")
        self.play2=Button(miFrame, text="Comenzar", command = funBoton5,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play2.place(x=650, y=300, anchor="center")
        self.play2.config(width="10", height="1")
        self.detener2=Button(miFrame, text="Detener", command = funBoton3, bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detener2.place(x=800, y=300, anchor="center")
        self.detener2.config(width="10", height="1")
        self.detenerGrab2= Button(miFrame, text="Detener Grab.", command=funBoton11,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab2.place(x=350, y=300, anchor="center")
        self.detenerGrab2.config(width="10", height="1")
       

        self.grabar3=Button(miFrame, text="Grabar", command=funBoton7,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar3.place(x=500, y=400, anchor="center")
        self.grabar3.config(width="10", height="1")
        self.play3=Button(miFrame, text="Comenzar", command = funBoton8,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play3.place(x=650, y=400, anchor="center")
        self.play3.config(width="10", height="1")
        self.detener3=Button(miFrame, text="Detener", command = funBoton3, bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detener3.place(x=800, y=400, anchor="center")
        self.detener3.config(width="10", height="1")
        self.detenerGrab2= Button(miFrame, text="Detener Grab.", command=funBoton12,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab2.place(x=350, y=400, anchor="center")
        self.detenerGrab2.config(width="10", height="1")

        self.label1 = Label(miFrame, bg=fondos, text="Rutina 1", font=("Times New Roman",20))
        self.label1.place(x=175, y=182)
        self.label2 = Label(miFrame, bg = fondos, text ="Rutina 2", font =("Times New Roman", 20))
        self.label2.place(x=175, y=282)
        self.label3 = Label(miFrame, bg=fondos, text="Rutina 3", font =("Times New Roman", 20))
        self.label3.place(x=175, y=382)
        self.titulo = Label(miFrame, bg =fondos, text = "Proyecto 2", font=("Times New Roman",28))
        self.titulo.place(x=450, y=50)
        self.nombres = Label(miFrame, bg=fondos, text="Hans Burmester, 17022", font=("Times New Roman",9))
        self.nombres.place(x=50,y=500)
        self.nombres2=Label(miFrame, bg=fondos, text="Abraham Roquel, 17529", font=("Times New Roman",9))
        self.nombres2.place(x=50,y=525)
        self.raiz.mainloop()

app=App()

         
