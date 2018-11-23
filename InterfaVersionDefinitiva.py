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
global contador10

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
fondos = 'chocolate1'
fondos2= 'RoyalBlue4'
actives = 'DarkGoldenrod1'

#-----------------------------------------------------------------------------------------------------------------------------------------------
ser= serial.Serial(port='COM10',baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS, timeout=0)

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
#------------------------------------------------------Funciones para enviar datos--------------------------------------------------------------
        def Enviar1():
            None
        def Enviar2():
            None
        def Enviar3():
            None
            
#------------------------------------------------------Funciones para guardar rutinas-----------------------------------------------------------
        def Grabar1():
            global grabador1
            global contador
            global comenzar
            if grabador1:
                ser.flushOutput()
                time.sleep(.1)
                recibido=ser.read()
                if recibido=="":
                    None
                elif ((ord(recibido1)==10)):
                    contador10=1
                    comenzar=1
                    archivo=open('rutina1.txt', 'a')
                    archivo.write(str(10)+'\r\n')
                    archivo.close
                    comenzar=1
                else:
                    if comenzar ==1:
                        dato=ord(recibido)
                        if contador==1:
                            dato=int(dato)
                            archivo=open('rutina1.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=2
                        elif contador==2:
                            dato=int(dato)
                            archivo=open('rutina1.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=3
                        elif contador==3:
                            dato=int(dato)
                            archivo=open('rutina1.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=4
                        elif contador==4:
                            dato=int(dato)
                            archivo=open('rutina1.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=1
                            ser.flushInput()
                            comenzar=0
                    else:
                        None
            else:
                None
            self.raiz.after(2,Grabar1)

        def Grabar2():
            global grabador2
            global contador
            global comenzar
            if grabador2:
                ser.flushOutput()
                time.sleep(.1)
                recibido=ser.read()
                if recibido=="":
                    None
                elif (ord(recibido)==10):
                    archivo=open('rutina2.txt', 'a')
                    archivo.write(str(10)+'\r\n')
                    archivo.close
                    comenzar=1
                else:
                    if comenzar==1:
                        dato=ord(recibido)
                        if contador==1:
                            dato=int(dato)
                            archivo=open('rutina2.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=2
                        elif contador==2:
                            dato=int(dato)
                            archivo=open('rutina2.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=3
                        elif contador==3:
                            dato=int(dato)
                            archivo=open('rutina2.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=4
                        elif contador==4:
                            dato=int(dato)
                            archivo=open('rutina2.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=1
                            ser.flushInput()
                            comenzar=0
                    else:
                        None
            else:
                None
            self.raiz.after(2,Grabar2)

        def Grabar3():
            global grabador3
            global contador
            global comenzar
            if grabador3:
                ser.flushOutput()
                time.sleep(.1)
                recibido=ser.read()
                if recibido=="":
                    None
                elif (ord(recibido)==10):
                    archivo=open('rutina3.txt', 'a')
                    archivo.write(str(10)+'\r\n')
                    archivo.close
                    comenzar=1
                else:
                    if comenzar==1:
                        dato=ord(recibido)
                        if contador==1:
                            dato=int(dato)
                            archivo=open('rutina3.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=2
                        elif contador==2:
                            dato=int(dato)
                            archivo=open('rutina3.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=3
                        elif contador==3:
                            dato=int(dato)
                            archivo=open('rutina3.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=4
                        elif contador==4:
                            dato=int(dato)
                            archivo=open('rutina3.txt','a')
                            archivo.write(str(dato)+'\r\n')
                            archivo.close
                            contador=1
                            ser.flushInput()
                            comenzar=0
                    else:
                        None
            else:
                None
            self.raiz.after(2,Grabar3)

#-------------------------------------------------Funciones para detener de grabar------------------------------------------------------------

        def DetenerGrab1():
            global grabador1
            global contador
            if contador !=1:
                archivo=open('rutina1.txt','r')
                linea = archivo.readlines()
                archivo.close()
                if contador ==2:
                    linea.pop()
                    linea.pop()
                    archivo=open('rutina1.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                elif contador==3:
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    archivo=open('rutina1.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                elif contador==4:
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    archivo = open('rutina1.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                else:
                    archivo.close()
                    None
            contador=1
            grabador1=False

        def DetenerGrab2():
            global grabador2
            global contador
            if contador !=1:
                archivo=open('rutina2.txt','r')
                linea = archivo.readlines()
                archivo.close()
                if contador ==2:
                    linea.pop()
                    linea.pop()
                    archivo=open('rutina2.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                elif contador==3:
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    archivo=open('rutina2.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                elif contador==4:
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    archivo = open('rutina2.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                else:
                    archivo.close()
                    None
            contador=1
            grabador2=False

        def DetenerGrab3():
            global grabador3
            global contador
            if contador !=1:
                archivo=open('rutina3.txt','r')
                linea = archivo.readlines()
                archivo.close()
                if contador ==2:
                    linea.pop()
                    linea.pop()
                    archivo=open('rutina3.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                elif contador==3:
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    archivo=open('rutina3.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                elif contador==4:
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    linea.pop()
                    archivo = open('rutina3.txt','w')
                    for i in linea:
                        archivo.write(i)
                    archivo.write('255')
                    archivo.close()
                else:
                    archivo.close()
                    None
            contador=1
            grabador3=False

#---------------------------------------------Funciones al presionar botones de grabar--------------------------------------------------------

        def grabar1():
            global grabador1
            grabador1=True
        def grabar2():
            global grabador2
            grabador2=True
        def grabar3():
            global grabador3
            grabador3=True
#-------------------------------------------------Detener una rutina------------------------------------------------------------------
        def DetenerRut1():
            None
        def DetenerRut2():
            None
        def DetenerRut3():
            None

#-------------------------------------------------Botones comenzar---------------------------------------------------------------------
        def Comenzar1():
            global estadoEnviar1
            global datosGuardados
            datosGuardados = []
            archivo=open('rutina1.txt','r')
            linea=archivo.read.splitlines()
            archivo.close
            for i in linea:
                datosGuardados.append(i)
            estadoEnviar1 = True

        def Comenzar2():
            global estadoEnviar2
            global datosGuardados
            datosGuardados=[]
            archivo=open('rutina2.txt', 'r')
            linea=archivo.read.splitlines()
            archivo.close
            for i in linea:
                datosGuardados.append(i)
            estadoEnviar2=True

        def Comenzar3():
            global estadoEnviar3
            global datosGuardados
            datosGuardados=[]
            archivo=open('rutina3.txt','r')
            linea=archivo.read.splitlines()
            archivo.close
            for i in linea:
                datosGuardados(i)
            estadoEnviar3=True

#-------------------------------------------------Interfaz-------------------------------------------------------------------------------------
        miFrame.config(bg=fondos, width ='1000', height = '600', bd=5, relief='groove')
        self.grabar1=Button(miFrame, text="Grabar", command=grabar1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar1.place(x=500, y=200, anchor="center")
        self.grabar1.config(width="10", height="1")
        self.play1= Button(miFrame, text="Comenzar", command = Comenzar1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play1.place(x=650, y=200, anchor="center")
        self.play1.config(width="10", height="1")
        self.detener1=Button(miFrame, text="Detener", command = DetenerRut1, bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detener1.place(x=800, y=200, anchor="center")
        self.detener1.config(width="10", height="1")
        self.detenerGrab1 = Button(miFrame, text="Detener Grab.", command=DetenerGrab1,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab1.place(x=350, y=200, anchor="center")
        self.detenerGrab1.config(width="10", height="1")

        self.grabar2 = Button(miFrame, text="Grabar", command=grabar2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar2.place(x=500, y=300, anchor="center")
        self.grabar2.config(width="10", height="1")
        self.play2=Button(miFrame, text="Comenzar", command = Comenzar2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play2.place(x=650, y=300, anchor="center")
        self.play2.config(width="10", height="1")
        self.detener2=Button(miFrame, text="Detener", command = DetenerRut2, bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detener2.place(x=800, y=300, anchor="center")
        self.detener2.config(width="10", height="1")
        self.detenerGrab2= Button(miFrame, text="Detener Grab.", command=DetenerGrab2,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detenerGrab2.place(x=350, y=300, anchor="center")
        self.detenerGrab2.config(width="10", height="1")
       

        self.grabar3=Button(miFrame, text="Grabar", command=grabar3,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.grabar3.place(x=500, y=400, anchor="center")
        self.grabar3.config(width="10", height="1")
        self.play3=Button(miFrame, text="Comenzar", command = Comenzar3,bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.play3.place(x=650, y=400, anchor="center")
        self.play3.config(width="10", height="1")
        self.detener3=Button(miFrame, text="Detener", command = DetenerRut3, bg=fondos2, font=("Times New Roman",15), fg=actives)
        self.detener3.place(x=800, y=400, anchor="center")
        self.detener3.config(width="10", height="1")
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
        self.raiz.after(1000,Grabar1)
        self.raiz.after(1000,Grabar2)
        self.raiz.after(1000,Grabar3)
        self.raiz.mainloop()

app=App()
