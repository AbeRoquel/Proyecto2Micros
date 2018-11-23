#Interfaz
from Tkinter import*
import tkMessageBox
import random
from time import sleep
from math import log
from math import exp
import serial
import time
#---------------------Definicion de variables--------------------------------------------------------------------------------------------------
global grabador1
global grabador2
global grabador3
global comenzar
global contador
global fondos
global fondos2
global actives
global estadoEnviar1
global estadoEnviar2
global estadoEnviar3
global datosGuardados
global contador1
global contador2
global contador3

grabador1=False
grabador2=False
grabador3=False
estadoEnviar1=False
estadoEnviar2=False
estadoEnviar3=False
datosGuardados=[]
contador=1
contador10=0
comenzar=0
fondos = 'SteelBlue1'
fondos2= 'gray42'
actives = 'DarkGoldenrod1'

#-----------------------------------------------------------------------------------------------------------------------------------------------
#ser= serial.Serial(port='COM5',baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS, timeout=0)

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
            
#------------------------------------------------------Funciones para guardar rutinas-----------------------------------------------------------
        def Principal():
            if(grabador1 == True):
                global contador1
                contador1 = 0
                vals = ['','','','']
                v = ser.read()
                if v == '\n':
                     for i in range(3):
                          vals[i] = ord(ser.read())
                     ser.read()
                     ser.read()
                     vals[3] = ord(ser.read())
                     temp = vals[3]
                     vals[3] = vals[2]
                     vals[2] = temp
                     ser.flushInput()
                     print vals
                     archivo=open('rutina1.txt', 'a')
                     archivo.write(str('10')+'\n')
                     contador1 = 1
                     for i in range(4):
                           archivo.write(str(vals[i])+'\n')
                           contador1 += 1
                     archivo.close()
                     
            elif (grabador2 == True):
                global contador2
                contador2 = 0
                vals = ['','','','']
                v = ser.read()
                if v == '\n':
                     for i in range(3):
                          vals[i] = ord(ser.read())
                     ser.read()
                     ser.read()
                     vals[3] = ord(ser.read())
                     temp = vals[3]
                     vals[3] = vals[2]
                     vals[2] = temp
                     ser.flushInput()
                     print vals
                     archivo=open('rutina2.txt', 'a')
                     archivo.write(str('10')+'\n')
                     contador2 = 1
                     for i in range(4):
                           archivo.write(str(vals[i])+'\n')
                           contador2 += 1
                     archivo.close()
                     
            elif (grabador3 == True):
                global contador3
                contador3 = 0
                vals = ['','','','']
                v = ser.read()
                if v == '\n':
                     for i in range(3):
                          vals[i] = ord(ser.read())
                     ser.read()
                     ser.read()
                     vals[3] = ord(ser.read())
                     temp = vals[3]
                     vals[3] = vals[2]
                     vals[2] = temp
                     ser.flushInput()
                     print vals
                     archivo=open('rutina3.txt', 'a')
                     archivo.write(str('10')+'\n')
                     contador3 = 1
                     for i in range(4):
                           archivo.write(str(vals[i])+'\n')
                           contador3 += 1
                     archivo.close()
            else:
                None
            self.raiz.after(100,Principal)



#-------------------------------------------------Funciones para detener de grabar------------------------------------------------------------

        def DetenerGrab1():
            global contador1
            global grabador1
            archivo=open('rutina1.txt','r')
            linea = archivo.readlines()
            archivo.close()
            if (contador1 != 0) and (contador1 != 5):
                 for i in range(contador1):
                      linea.pop()
            archivo=open('rutina1.txt','a')
            archivo.write('255')
            archivo.close()
            grabador1 = False

        def DetenerGrab2():
           global contador2
           global grabador2
           archivo=open('rutina2.txt','r')
           linea = archivo.readlines()
           archivo.close()
           if (contador2 != 0) and (contador2 != 5):
                for i in range(contador2):
                     linea.pop()
           archivo=open('rutina2.txt','a')
           archivo.write('255')
           archivo.close()
           grabador2= False

        def DetenerGrab3():
           global contador3
           global grabador3
           archivo=open('rutina3.txt','r')
           linea = archivo.readlines()
           archivo.close()
           if (contador3 != 0) and (contador3 != 5):
                for i in range(contador1):
                     linea.pop()
           archivo=open('rutina3.txt','a')
           archivo.write('255')
           archivo.close()
           grabador3 = False

#---------------------------------------------Funciones al presionar botones de grabar--------------------------------------------------------

        def grabar1():
            global grabador1
            grabador1=True
            archivo = archivo=open('rutina1.txt','w')
            archivo.write('')
            archivo.close()
        def grabar2():
            global grabador2
            grabador2=True
            archivo = archivo=open('rutina2.txt','w')
            archivo.write('')
            archivo.close()
        def grabar3():
            global grabador3
            archivo = archivo=open('rutina3.txt','w')
            archivo.write('')
            archivo.close()
            grabador3=True

#-------------------------------------------------Botones para reproducir rutinas---------------------------------------------------------------------
        def Comenzar1():
            archivo = open("rutina1.txt", "r")
            lineas = archivo.readlines()
            archivo.close()
            for linea in lineas:
                 time.sleep(.04)
                 n = chr(int(linea))
                 print n
                 ser.write(n)

        def Comenzar2():
            archivo = open("rutina2.txt", "r")
            lineas = archivo.readlines()
            archivo.close()
            for linea in lineas:
                 time.sleep(.04)
                 n = chr(int(linea))
                 print n
                 ser.write(n)

        def Comenzar3():
            archivo = open("rutina3.txt", "r")
            lineas = archivo.readlines()
            archivo.close()
            for linea in lineas:
                 time.sleep(.04)
                 n = chr(int(linea))
                 print n
                 ser.write(n)
          

#-------------------------------------------------Interfaz-------------------------------------------------------------------------------------
        miFrame.config(bg=fondos, width ='1000', height = '600', bd=5, relief='groove')
        self.grabar1=Button(miFrame, text="Grabar", command=grabar1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar1.place(x=500, y=200, anchor="center")
        self.grabar1.config(width="10", height="1")
        self.play1= Button(miFrame, text="Comenzar", command = Comenzar1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play1.place(x=650, y=200, anchor="center")
        self.play1.config(width="10", height="1")
        self.detenerGrab1 = Button(miFrame, text="Detener Grab.", command=DetenerGrab1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab1.place(x=350, y=200, anchor="center")
        self.detenerGrab1.config(width="10", height="1")

        self.grabar2 = Button(miFrame, text="Grabar", command=grabar2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar2.place(x=500, y=300, anchor="center")
        self.grabar2.config(width="10", height="1")
        self.play2=Button(miFrame, text="Comenzar", command = Comenzar2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play2.place(x=650, y=300, anchor="center")
        self.play2.config(width="10", height="1")
        self.detenerGrab2= Button(miFrame, text="Detener Grab.", command=DetenerGrab2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab2.place(x=350, y=300, anchor="center")
        self.detenerGrab2.config(width="10", height="1")
       

        self.grabar3=Button(miFrame, text="Grabar", command=grabar3,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar3.place(x=500, y=400, anchor="center")
        self.grabar3.config(width="10", height="1")
        self.play3=Button(miFrame, text="Comenzar", command = Comenzar3,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play3.place(x=650, y=400, anchor="center")
        self.play3.config(width="10", height="1")
        self.detenerGrab2= Button(miFrame, text="Detener Grab.", command=DetenerGrab3,bg=fondos2, font=("Times New Roman",15), fg=actives)
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
        self.raiz.after(100,Principal)
        self.raiz.mainloop()

app=App()
