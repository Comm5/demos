
import socket

class Acionamento:

    def __init__(self):
        self.__lastSensorRead = 0
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def connect(self, host):
        self.socket.connect((host, 5000))

    def setRele(self, rele, estado):
        if ( estado ):
            self.socket.send("set %i\n" % rele)
        else:
            self.socket.send("reset %i\n" % rele)

        buffer = ""
        while( not buffer.contains("210") ):
            buffer += self.socket.recv(1024)

    def sensor(self):
        pass

    def isSensorActive(self):
        pass

    def disconnect(self):
        pass

