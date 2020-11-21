import json
import serial
import time
#import wiringpi as wiringpi

#Clases: Bebida, Ingrediente y Materia_prima
class Bebida:
  def __init__(self, bebida_id, nombre, descripcion, ingredientes):
    self.bebida_id = bebida_id
    self.nombre = nombre
    self.descripcion = descripcion
    self.ingredientes = ingredientes

  def es_bebida_alcocholica(self):
    for ingrediente in self.ingredientes:
      if ingrediente.Materia_prima.tiene_alcohol:
        return True
  
    return False

  def hay_ingredientes(self):
    for ingrediente in self.ingredientes:
      if not ingrediente.hay_suficiente():
        return False

    return True  

  def obtener_ingredientes(self):
    i = []
    for ingrediente in self.ingredientes:
      i.append(ingrediente.obtener_nombre())

    return i

  def preparar_bebida(self):
    for ingrediente in self.ingredientes:
      ingrediente.suministrar_ingrediente()

class Ingrediente:
  def __init__(self, cantidad_en_ml, Materia_prima):
    self.cantidad_en_ml = cantidad_en_ml    
    self.Materia_prima = Materia_prima
  
  def obtener_nombre(self):    
    return str(self.cantidad_en_ml) + " ml de " + self.Materia_prima.nombre

  def hay_suficiente(self):
    
    return self.Materia_prima.obtener_cantidad_total() > self.cantidad_en_ml      

  def suministrar_ingrediente(self):
    prima_id = self.Materia_prima.materia_prima_id
    cantidad = self.cantidad_en_ml
    print("Suministrando al actuador:", str(prima_id))
    print("Cantidad:", str(cantidad))
    
    

class Materia_prima:
  def __init__(self, materia_prima_id, nombre, tiene_alcohol):
    self.materia_prima_id = materia_prima_id
    self.nombre = nombre    
    self.tiene_alcohol = tiene_alcohol  

  def LeerSensor(self):    

    cantidad = 500
    print('Valor del sensor:', cantidad)
    return int(cantidad)

  def obtener_cantidad_total(self):
    print("Leyendo el sensor:", str(self.materia_prima_id))
    return self.LeerSensor()

  
     
class Materia_prima_nivel:
   def __init__(self, nombre, nivel):    
    self.nombre = nombre    
    self.nivel = nivel

# Funciones de utilidades

#Esta función sirve para leer un archivo json de bebidas y regresar una lista de objetos Bebida
def Obtener_bebidas_de_archivo():
  bebidas_disponibles = []

  with open('bebidas.json') as file:
    data = json.load(file)
    for bebida in data['bebidas']:
      ingredientes_de_bebida = []
      for ingrediente in bebida['ingredientes']:            
        ingredientes_de_bebida.append(Ingrediente(ingrediente['cantidad_en_ml'], Materia_prima(ingrediente['materia_prima']['materia_prima_id'], ingrediente['materia_prima']['nombre'], ingrediente['materia_prima']['tiene_alcohol'])))

      bebidas_disponibles.append(Bebida(bebida['id'], bebida['nombre'], bebida['descripcion'], ingredientes_de_bebida))

  return bebidas_disponibles

#Esta función sirve para serializar los objetos a formato json
def to_serializable(val):
  """JSON serializer for objects not serializable by default"""        
  if hasattr(val, '__dict__'):
    return val.__dict__

  return val

              
        

