using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;

namespace Comm5
{
    abstract class AbstractTerminal
    {
        public enum Keys
        {
            Fim = 's',
            ESC = 27,
            Enter = 13,
            ArrowDown = 'x',
            ArrowUp = '.',
            Func = 'p'
        }

        public AbstractTerminal()
        {
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        }

        public AbstractTerminal(Socket s)
        {
            socket = s;
        }

        public void connect(string host)
        {
            socket.Connect(host, 3000);
        }

        public void connect(string host, Int32 port)
        {
            socket.Connect(host, port);
        }

        public void disconnect()
        {
            if (isConnected())
            {
                try
                {
                    socket.Disconnect(true);
                }
                catch (System.Net.Sockets.SocketException e)
                {
                    string error = e.Message;
                }
            }
        }

        public int bytesAvailable()
        {
            return socket.Available;
        }

        public bool isConnected()
        {
            return socket.Connected;
        }

        public void purgeInputBuffers()
        {
            if ( socket.Available > 0 ) {
                byte[] buffer = new byte[ socket.Available ];
                socket.Receive( buffer );
            }
        }

        public int write(string data)
        {
            return socket.Send(System.Text.Encoding.ASCII.GetBytes(data));
        }

        public char readByte()
        {
            byte[] data = new byte[1];
            socket.Receive(data);
            return (char)data[0];
        }
        
        protected Socket socket;
    }

    class TerminalVT52 : AbstractTerminal
    {
        public TerminalVT52() : base()
        {
        }

        public TerminalVT52(Socket s) : base( s )
        {
        }

        /*
         * Altera posição atual do cursor para coluna x e linha y
         */
        public void setCursorPosition( int x, int y )
        {
            socket.Send(System.Text.Encoding.ASCII.GetBytes("\x1b" + "Y"  + (char)(x + 32) + (char)(y + 32)) );
        }

        public void setCursorEnabled( bool enabled, bool blink = false )
        {
            if ( enabled ) {
                if ( blink ) {
                    socket.Send(System.Text.Encoding.ASCII.GetBytes("\x1b" + "a"));
                } else {
                    socket.Send(System.Text.Encoding.ASCII.GetBytes("\x1b" + "e"));
                }
            } else {
                socket.Send(System.Text.Encoding.ASCII.GetBytes("\x1b" + "f"));
            }
        }

        /*
         * Apaga os caracteres da linha atual do cursor
         */
        public void clearLine()
        {
            socket.Send(System.Text.Encoding.ASCII.GetBytes("\x1b" + "o" + "\x1b" + "K"));
        }

        /*
         * Apaga os caracteres da linha informada no argumento y
         */
        public void clearLinePosition( int y )
        {
            setCursorPosition(0, y);
            clearLine();
        }

        /*
         * Apaga todos os caracteres da tela
         */
        public void clearScreen()
        {
            socket.Send(System.Text.Encoding.ASCII.GetBytes("\x1b" + "E"));
        }
    
    }
    
}
