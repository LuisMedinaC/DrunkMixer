import sys
import os, os.path
import random
import requests
import string
import json

import socket

from collections import deque 

import cherrypy

from clases import *

#Recibir host
host_port = "http://" + str(sys.argv[1]) + ":8080"

#Conectar con robot studio
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('127.0.0.1', 55555))

while True:

    time.sleep(1)
    #Preguntar si hay bebida en fila
    r = requests.get(host_port + "/siguienteEnFila")
    

    try:
        data = r.json()

        #Obtener id
        bebida_id = data['bebida_id']

        #Mandar bebida a robot studio
        print("Bebida: ", data['nombre'])
        #str(bebida_id)
        sock.send(bytes(str(bebida_id), 'UTF-8'))

        #Esperar a que se prepare
        while True:
            try:
                data = sock.recv(16)
                completion = data.decode('utf-8')
                print("Respuesta: ", completion)
                if not data:
                    print("waiting...")
                    time.sleep(1)
                else:
                    del(completion)
                    del(data)
                    break
                    
            except:
                print("Lo siento, morí")
                break

    except:
        print("No hay bebida enfilada")