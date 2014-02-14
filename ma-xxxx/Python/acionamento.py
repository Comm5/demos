
import socket

class Acionamento:
    
    def __init__(self):
		self.__lastSensorRead = 0
		self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.socket.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    
    def connect(self, host):
        self.socket.connect((host, 5000))
    
    def setRele(self, rele, estado):
        if ( estado ):
            self.socket.send("set %i\n" % rele)
        else:
            self.socket.send("reset %i\n" % rele)
        
        buffer = ""
        while( not "210" in buffer ):
            buffer += self.socket.recv(1024)
    
    def sensor(self):
		self.socket.send("query\n");
		
		buffer = ""
		while( not "210" in buffer ):
			buffer += self.socket.recv(1024)
		
		lastUsableLine = ""
		lines = buffer.split('\n')
		for line in reversed(lines):
			if "210" in line:
				lastUsableLine = line.replace('\r', '')
				break
		tokens = lastUsableLine.split(" ")
		self.__lastSensorRead = int(tokens[1], 16);
		
		return self.__lastSensorRead

    
    def isSensorActive(self, sensor):
        return ((self.__lastSensorRead & (1 << sensor)) != 0);
    
    def disconnect(self):
        self.socket.close()

