import socket

#Start conection
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('127.0.0.1', 55555))
print("Connected to server")

loop = True

while loop:

    direction = input("Enter direction: ")
    if direction == "":
        loop = False
    else:
        sock.send(bytes(direction, 'UTF-8'))

sock.close()
print("Ending connection")
