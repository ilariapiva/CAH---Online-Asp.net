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
        }

        //Aggiunge gli user alle rooms
        public static bool NewGame(Account user)
        {
            if (Rooms.Count == 0) //Controllo se la lista delle rooms è vuota, se lo è aggiungo una room e lo user alla room
            {
                Room room = new Room();
                Rooms.Add(room); 
                FunctionsDB.WriteGame(user, 0, 1);
                int indexRoom = Convert.ToInt32(Rooms.IndexOf(room));
                room.AddRoomInListUser(user, indexRoom);
                room.GenerateCardsForUser(user);
                return true;
            }
            else //Se la lista rooms non è vuota allora controllo nelle rooms se c'è spazio, e se ce nè allora aggiungo lo user nella prima room non piena
            {
                foreach(Room i in Rooms)
                {
                    if(!IsFull(i))
                    {
                        FunctionsDB.WriteGame(user, Rooms.IndexOf(i), 0);
                        int indexRoom = Convert.ToInt32(Rooms.IndexOf(i));
                        i.AddUser(user, indexRoom);
                        i.GenerateCardsForUser(user);
                        return true;
                    }
                }

                Room room = new Room(); //altrimenti creo una nuova room e aggiungo lo user alla lista
                Rooms.Add(room);
                FunctionsDB.WriteGame(user, Rooms.Count - 1, 1);
                int idRoom = Convert.ToInt32(Rooms.IndexOf(room));
                room.AddRoomInListUser(user, idRoom);
                room.GenerateCardsForUser(user);
                return true;
            }
        }

        //Restituisce la room
        public static Room UserEntered(int idRoom)
        {
            return Rooms[idRoom];
        }

        //Questa funzione permette di verificare la stanza è piena
        public static bool IsFull(Room r)
        {
            int indexRoom = Convert.ToInt32(Rooms.IndexOf(r));
            int NumberUsers = FunctionsDB.ReadUsersInRoom(indexRoom);
            if (NumberUsers == 3)
            {
                return true;
            }
            return false;
        }
    }
}