using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Game
    {
        static List<Room> listRooms = new List<Room>();

        public Game()
        {
        }

        //Aggiunge gli user alle rooms
        public static bool NewGame(Account user)
        {
            if (listRooms.Count == 0) //Controllo se la lista delle rooms è vuota, se lo è aggiungo una room e lo user alla room
            {
                Room room = new Room();
                listRooms.Add(room); 
                FunctionsDB.WriteGame(user, 0, 1);
                int indexRoom = Convert.ToInt32(listRooms.IndexOf(room));
                room.CreateNewListInDictionary(indexRoom);
                room.AddUser(user, indexRoom);
                room.GenerateCardsForUser(user);
                room.GenerateCardBlack(indexRoom);
                return true;
            }
            else //Se la lista rooms non è vuota allora controllo nelle rooms se c'è spazio, e se ce nè allora aggiungo lo user nella prima room non piena
            {
                foreach(Room i in listRooms)
                {
                    if(!IsFull(i))
                    {
                        FunctionsDB.WriteGame(user, listRooms.IndexOf(i), 0);
                        int indexRoom = Convert.ToInt32(listRooms.IndexOf(i));
                        i.AddUser(user, indexRoom);
                        i.GenerateCardsForUser(user);
                        //i.GenerateCardBlack(indexRoom);
                        return true;
                    }
                }

                Room room = new Room(); //altrimenti creo una nuova room e aggiungo lo user alla lista
                listRooms.Add(room);
                FunctionsDB.WriteGame(user, listRooms.Count - 1, 1);
                int idRoom = Convert.ToInt32(listRooms.IndexOf(room));
                room.CreateNewListInDictionary(idRoom);
                room.AddUser(user, idRoom);
                room.GenerateCardsForUser(user);
                room.GenerateCardBlack(idRoom);
                return true;
            }
        }

        //Restituisce la room
        public static Room UserEntered(int idRoom)
        {
            return listRooms[idRoom];
        }

        public static void DeleteRoom(int idRoom)
        {
            foreach(Room i in listRooms)
            {
                int indexRoom = Convert.ToInt32(listRooms.IndexOf(i));
                if(indexRoom == idRoom)
                {
                    listRooms.RemoveAt(idRoom);
                    break;
                }
            }
        }

        //Questa funzione permette di verificare la stanza è piena
        public static bool IsFull(Room r)
        {
            int indexRoom = Convert.ToInt32(listRooms.IndexOf(r));
            int NumberUsers = FunctionsDB.ReadUsersInRoom(indexRoom);
            if (NumberUsers == 3)
            {
                return true;
            }
            return false;
        }
    }
}