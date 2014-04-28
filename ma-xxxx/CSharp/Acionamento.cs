﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;

namespace Comm5
{
    class Acionamento
    {
        public void connect(string host)
        {
            socket.Connect(host, 5000);
        }
        
        public void setRele( int rele, bool estado )
        {
            if ( rele > 8 || rele < 0 )
                throw new IndexOutOfRangeException();

            if ( estado )
                socket.Send( System.Text.Encoding.ASCII.GetBytes("set " + rele.ToString() + "\n" ) );
            else
                socket.Send(System.Text.Encoding.ASCII.GetBytes("reset " + rele.ToString() + "\n" ));

            Byte[] recvBytes = new Byte[1024];
            string buffer;
            do
            {
                int recvSize = socket.Receive(recvBytes);
                buffer = System.Text.Encoding.ASCII.GetString(recvBytes);
            }
            while (!buffer.Contains("210"));

        }

        /*
         * Lê o valor dos sensores no hardware e retorna um numero inteiro representando
         * todos os sensores lidos. Atualiza cache interno usado por isSensorActive
         */ 
        public int sensor()
        {
            socket.Send(System.Text.Encoding.ASCII.GetBytes("query\n"));
            

            Byte[] recvBytes = new Byte[1024];
            string buffer;
            do
            {

                int recvSize = socket.Receive(recvBytes);
                buffer = System.Text.Encoding.ASCII.GetString(recvBytes);
            }
            while (!buffer.Contains("210"));

            char[] charSeparators = new char[] { '\n' };
            string[] lines = buffer.Split(charSeparators, StringSplitOptions.RemoveEmptyEntries);

            string lastUsableLine = null;
            for ( int i = lines.Count() - 1; i >= 0; --i )
            {
                if (lines[i].Contains("210") && !lines[i].Contains("OK") )
                {
                    lastUsableLine = lines[i].Replace("\r", "");
                    break;
                }
            }

            if (lastUsableLine == null)
                throw new Exception();

            string[] tokens = lastUsableLine.Split(' ');
            
            lastSensorRead = Convert.ToInt32(tokens[1], 16);
            return lastSensorRead;
        }

        /*!
         * Retorna verdadeiro caso o sensor especificado esteja ligado.
         * É preciso chamar o método sensor para atualizar o cache interno.
         */
        public bool isSensorActive( int sensor )
        {
             return ((lastSensorRead & (1 << sensor)) != 0);
        }

        public void disconnect()
        {
            socket.Send(System.Text.Encoding.ASCII.GetBytes("quit\n"));
            socket.Disconnect(true);
        }

        private int lastSensorRead = 0;
        private Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

    }
    
}
