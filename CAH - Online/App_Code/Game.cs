using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Game
    {
        static List<Room> Rooms = new List<Room>();

        public Game()
        {
            //
            // TODO: aggiungere qui la logica del costruttore
            //
        }

        //Aggiunge gli user alle rooms
        public static bool NewGame(Account user)
        {
            if (Rooms.Count == 0) //Controllo se la lista delle rooms è vuota, se lo è aggiungo una room e lo user alla room
            {
                Room room = new Room();
                Rooms.Add(room);
                Room.AddUser(user);
                FunctionsDB.WriteGame(user, 0);
                return true;
            }
            else //Se la lista rooms non è vuota allora controllo nelle rooms se c'è spazio, e se ce nè allora aggiungo lo user nella prima room non piena
            {
                foreach(Room i in Rooms)
                {
                    if(!Room.IsFull())
                    {
                        Room.AddUser(user);
                        FunctionsDB.WriteGame(user, Rooms.IndexOf(i));
                        return true;
                    }
                }

                Room room = new Room(); //altrimenti creo una nuova room e aggiungo lo user alla lista
                Rooms.Add(room);
                Room.AddUser(user);
                FunctionsDB.WriteGame(user, Rooms.Count - 1);
                return true;
            }
        }

        //Restituisce la room
        public static Room UserEntered(int idRoom)
        {
            return Rooms[idRoom];
        }
    }
}