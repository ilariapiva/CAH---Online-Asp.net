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
                FunctionsDB.WriteGame(user, listRooms.IndexOf(room), 1);
                //int indexRoom = Convert.ToInt32(listRooms.IndexOf(room));
                room.CreateNewListInDictionary(listRooms.IndexOf(room));
                room.AddUser(user, listRooms.IndexOf(room));
                room.GenerateCardsForUser(user);
                room.GenerateCardBlack(listRooms.IndexOf(room));
                FunctionsDB.WriteRounds(listRooms.IndexOf(room));
                FunctionsDB.WriteUserExit(user, listRooms.IndexOf(room));
                return true;
            }
            else //Se la lista rooms non è vuota allora controllo se nelle rooms c'è spazio, e se ce nè allora aggiungo lo user nella prima room non piena
            {
                foreach(Room i in listRooms)
                {
                    if(!IsFull(i))
                    {
                        if(FunctionsDB.CheckRoom(listRooms.IndexOf(i)))//controllo nel db se c'è già la stanza, se c'è scrivo l'utente, aggiungo 
                        {                                               //l'utente alla lista degli utenti e gli genero le carte bianche
                            FunctionsDB.WriteGame(user, listRooms.IndexOf(i), 0);
                            i.AddUser(user, listRooms.IndexOf(i));
                            i.GenerateCardsForUser(user);
                            FunctionsDB.WriteUserExit(user, listRooms.IndexOf(i));
                        }
                        else //se invece la stanza non è già presente nel db, scrivo l'utente, aggiungo l'utente alla lista degli utenti e gli genero le carte bianche 
                        {   //e genero la carta nera e resetto i round
                            FunctionsDB.WriteGame(user, listRooms.IndexOf(i), 1);
                            i.AddUser(user, listRooms.IndexOf(i));
                            i.GenerateCardsForUser(user);
                            i.GenerateCardBlack(listRooms.IndexOf(i));
                            if (FunctionsDB.CheckRounds(listRooms.IndexOf(i)))
                            {
                                FunctionsDB.ResetRounds(listRooms.IndexOf(i));
                            }
                            else
                            {
                                FunctionsDB.WriteRounds(listRooms.IndexOf(i));
                            }
                            FunctionsDB.WriteUserExit(user, listRooms.IndexOf(i));
                        }
                        //int indexRoom = Convert.ToInt32(listRooms.IndexOf(i));
                        return true;
                    }
                }

                Room room = new Room(); //altrimenti creo una nuova room e aggiungo lo user alla lista
                listRooms.Add(room);
                FunctionsDB.WriteGame(user, listRooms.IndexOf(room), 1);
                //int idRoom = Convert.ToInt32(listRooms.IndexOf(room));
                room.CreateNewListInDictionary(listRooms.IndexOf(room));
                room.AddUser(user, listRooms.IndexOf(room));
                room.GenerateCardsForUser(user);
                room.GenerateCardBlack(listRooms.IndexOf(room));
                FunctionsDB.WriteRounds(listRooms.IndexOf(room));
                FunctionsDB.WriteUserExit(user, listRooms.IndexOf(room));
                return true;
            }
        }

        //Restituisce la room
        public static Room UserEntered(int idRoom)
        {
            return listRooms[idRoom];
        }

        //Questa funzione permette di verificare la stanza è piena
        public static bool IsFull(Room r)
        {
            int indexRoom = Convert.ToInt32(listRooms.IndexOf(r));
            Room room = new Room();
            if (room.listUserIsFull(listRooms.IndexOf(r)))
            {
                return true;
            }
            return false;
        }

        //Questa funzione restituisce la lista delle rooms
        public List<Room> rooms()
        {
            return listRooms;
        }
    }
}