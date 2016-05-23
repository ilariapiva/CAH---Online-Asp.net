using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Room
    {
        static Dictionary<int, List<Account>> listUsers = new Dictionary<int, List<Account>>();
        static List<Cards> RandomCardBlack, RandomCardsWhite;
        static int indexCardBlack, indexCardWhite, indexMaster; //numberCardWhite, 
        static Dictionary<int, List<Cards>> listCardsUsers = new Dictionary<int, List<Cards>>();
        static Dictionary<int, List<Cards>> listCardsBlack = new Dictionary<int, List<Cards>>();

        public Room()
        {
            indexCardBlack = 0;
            indexCardWhite = 0;
            indexMaster = 0;

            //prendo tutte le carte dalla tabella BlackCard e le inserisco in una lista
            Random rndBlackCard = new Random();

            String BlackCard = "SELECT * FROM tblBlackCard";
            List<Cards> cardBlack = FunctionsDB.CardsBlack(BlackCard);

            RandomCardBlack = (cardBlack.OrderBy(x => rndBlackCard.Next())).ToList();
            //numberCardWhite = CheckStringBlackCard();

            //prendo tutte le carte dalla tabella WhiteCard e le inserisco in una lista
            Random rndWhiteCards = new Random();

            String WhiteCards = "SELECT * FROM tblWhiteCard";
            List<Cards> cardsWhite = FunctionsDB.CardsWhite(WhiteCards);

            RandomCardsWhite = (cardsWhite.OrderBy(x => rndWhiteCards.Next())).ToList();
        }

        //Creo una nuova lista di utenti e di carte nere in base ad una stanza
        public void CreateNewListInDictionary(int idRoom)
        {
            listUsers.Add(idRoom, new List<Account>());
            listCardsBlack.Add(idRoom, new List<Cards>());
        }

        //Aggiungo utenti ad una lista in base alla stanza e creo la lista delle carte
        public void AddUser(Account user, int idRoom)
        {
            listUsers[idRoom].Add(user);
            listCardsUsers.Add(user.idAccount, new List<Cards>());
        }

        //Questa verifica se l'utente è il master
        public bool IsMaster(Account user, int idRoom)
        {
            Master indexUser = FunctionsDB.ReadMaster(idRoom, user);
            bool ok = false;
            foreach(Account u in listUsers[idRoom])
            {
                if (u.idAccount == indexUser.idAccount)
                {
                    if(indexUser.indexMaster == 1)
                    {
                        ok = true;                    
                        break;
                    }
                    else if (indexUser.indexMaster == 0)
                    {
                        ok = false;
                    }
                }
            }
            return ok;
        }

        //Questa funzione restituisce le carte bianche dell'utente
        public List<Cards> GetCardsWhite(Account user)
        {
            return listCardsUsers[user.idAccount];
        }

        //Questa funzione restituisce una nuova carta bianca
        public Cards GetNewCardWhite(Account user)
        {
            return listCardsUsers[user.idAccount][listCardsUsers[user.idAccount].Count - 1];
        }

        //Questa funziona genera una lista iniziale delle carte per l'utente
        public void GenerateCardsForUser(Account user)
        {
            List<Cards> cards = new List<Cards>();

            for (int i = 0; i < 10; i++)
            {
                cards.Add(RandomCardsWhite[indexCardWhite + i]);
            }

            indexCardWhite += 10;
            listCardsUsers[user.idAccount] = cards;
        }

        //Questa funziona genera aggiunge una carta all'utente
        public void GenerateCardForUser(Account user)
        {
            Cards card = new Cards();
            card = RandomCardsWhite[indexCardWhite];
            indexCardWhite++;
            listCardsUsers[user.idAccount].Add(card);
        }

        //Questa funzione permette di eliminare una carta dalla lista delle carte di un utente
        public void DeleteCardForUser(Account user, int idCard)
        {
            foreach (Cards c in listCardsUsers[user.idAccount])
            {
                if (c.idCards == idCard)
                {
                    listCardsUsers[user.idAccount].Remove(c);
                    break;
                }
            }
        }

        //Questa funzione genera la carta nera del turno a tutti i giocatori
        public void GenerateCardBlack(int idRoom)
        {
            Cards c = new Cards();
            //indexCardBlack++;
            c = RandomCardBlack[indexCardBlack];
            listCardsBlack[idRoom].Add(c);
           // return listCardsBlack[idRoom];
        }

        //Questa funzione genera la carta nera del turno a tutti i giocatori
        public void GenerateNewCardBlack(int idRoom)
        {
            Cards c = new Cards();
            c = RandomCardBlack[indexCardBlack];
            listCardsBlack[idRoom].Add(c);
            // return listCardsBlack[idRoom];
        }

        //Questa funzione restituisce la carta nera del turno a tutti i giocatori
        public Cards GetCardBlack(int idRoom)
        {
            return listCardsBlack[idRoom][listCardsBlack[idRoom].Count - 1];
        }


        //Questa funzione restituisce il numero di spazi presenti nella blackCard selezionata
        public int CheckStringBlackCard(int idRoom)
        {
            String str = GetCardBlack(idRoom).Text;
            String[] toFind = str.Split('_');
            return toFind.Length - 1;
        }

        /*Questa funzione controlla che il numero di carte selezionate corrispondana 
        al numero di spazi che ci sono nella blackCard*/
        public bool CheckSelectCards(List<Cards> listCards, int idRoom)
        {
            if (CheckStringBlackCard(idRoom) == listCards.Count)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        //Salvo in nel db le carte dell'utente
        public void UsersAndCards(List<Cards> listCardsWhite, int idRoom, Account user)
        {
            //foreach (Account user in listUsers)
            if (!IsMaster(user, idRoom))
            {
                if (CheckSelectCards(listCardsWhite, idRoom) == true)
                {
                    if (listCardsWhite.Count != 0)
                    {
                        listCardsWhite.ForEach(delegate(Cards cardSelect)
                        {
                            FunctionsDB.WriteCardsSelect(user, cardSelect, idRoom);
                        });
                    }
                }
            }
        }

        /*Questa funzione permette di controllare se il numero dei giocatori che hanno selezionato le carte 
         * (lo si ottiene interrogando il db) sia uguale numero dei giocatori della stanza meno il master */
        public bool CheckUserCardSelected(int room)
        {
            if (UsersNotMaster(room) == 4)
            {
                return true;
            }
            if (UsersNotMaster(room) == 2)
            {
                return true;
            }
            return false;
        }

        //Questa funziona mi ritorna il numero dei giocatori meno il master presenti nella stanza
        public int UsersNotMaster(int room)
        {
            int count = 0;

            foreach (Account user in listUsers[room])
            {
                if (!IsMaster(user, room))
                {
                    count++;
                }
            }
            return count;
        }

        //Questa funzione permette di mandare avanti l'index del master
        public void NewRaund(int room)
        {
            foreach (Account user in listUsers[room])
            {
                if (IsMaster(user, room))
                {
                    if (indexMaster == 3)
                    {
                        indexMaster = 0;
                        indexCardBlack++;
                        GetCardBlack(room);
                        indexMaster = indexMaster % listUsers[room].Count;
                        FunctionsDB.UpdateMaster(room, 0, user);
                        break;
                    }
                    else if (indexMaster < 3)
                    {
                        indexMaster++;
                        indexCardBlack++;
                        GenerateCardBlack(room);
                        indexMaster = indexMaster % listUsers[room].Count;
                        FunctionsDB.UpdateMaster(room, 0, user);
                        break;
                    }
                }
            }
            foreach (Account u in listUsers[room])
            {
                int index = listUsers[room].IndexOf(u);
                if (index == indexMaster)
                {
                    FunctionsDB.UpdateMaster(room, 1, u);
                    break;
                }
            }
            //return indexMaster;
        }

        //Questa funzione permette di eliminare le carte di un utente
        public void DeleteCardsUser(Account user)
        {
            listCardsUsers.Remove(user.idAccount);
        }

        //Questa funzione permette di eliminare un utente da una stanza
        public void DeleteUser(int indexRoom, Account user)
        {
            listUsers[indexRoom].Remove(user);
        }

        //Questa funzione permette di eliminare una stanza dalla lista degli utenti
        public void DeleteRoomInListUsers(int indexRoom)
        {
            listUsers.Remove(indexRoom);
        }

        //Questa funzione permette di eliminare le carte nere di una stanza
        public void DeleteCardBlack(int indexRoom)
        {
            listCardsBlack.Remove(indexRoom);
        }

        /*Questa funzione permette di controllare se la lista delle carte degli users sia stata eliminata*/
        public bool CheckDeleteCardsUser(Account user)
        {
            bool ok = false;
            if (listCardsUsers.ContainsKey(user.idAccount))
            {
                ok = true;

            }
            return ok;
        }

        /*Questa funzione permette di controllare se la lista delle room ,o dove si trovi la room come indice nelle 
          altre liste, sia stata eliminata*/
        public bool CheckDeleteKeyRoom(int indexRoom)
        {
            bool ok = false;
            if (listUsers.ContainsKey(indexRoom))
            {
                ok = true;
            }
            return ok;
        }

        /*Questa funzione permette di controllare se la lista delle carte nere sia stata eliminata la chiave
         la quale corrisponde all'id della room*/
        public bool CheckDeleteCardsBlcak(int indexRoom)
        {
            bool ok = false;
            if (listCardsBlack.ContainsKey(indexRoom))
            {
                ok = true;
            }
            return ok;
        }

        //Questa funzione permette di controllare se nella lista degli user l'utente è stato eliminato
        public bool CheckDeleteUser(int indexRoom, Account user)
        {
            bool ok = false;
            if (listUsers.ContainsKey(indexRoom))
            {
                foreach (Account u in listUsers[indexRoom])
                {
                    if (u == user)
                    {
                        ok = true;
                        break;
                    }
                }
            }
            return ok;
        }

        //Questa funzione resituisce la idRoom 
        public int ReturnKeyRoomUser(Account user)
        {
            Game g = new Game();
            List<Room> listRooms = g.rooms();

            //int idRoom = 0;
            int indexRoom = 0;

            /*foreach(Account u in listUsers[idRoom])
            {
                if(u == user)
                {
                    indexRoom = listUsers.ElementAt(idRoom).Key;
                    break;
                }
                else
                {
                    idRoom++;
                }
            }
            return indexRoom;*/

            for(int i = 0; i < listRooms.Count; i++)
            {
                foreach (Account u in listUsers[i])
                {
                    if (u == user)
                    {
                        indexRoom = listUsers.ElementAt(i).Key;
                        break;
                    }
                }
            }

            return indexRoom;
        }

        //Questa funzione controlla se nelle stanze esiste l'utente
        public bool ExistUserInRoom(Account user)
        {
            Game g = new Game();
            List<Room> listRooms = g.rooms();
            bool ok = false;

            for (int i = 0; i < listRooms.Count; i++)
            {
                foreach (Account u in listUsers[i])
                {
                    if (u.idAccount == user.idAccount)
                    {
                        ok = true;
                        break;
                    }
                }
                if(ok == true)
                {
                    break;
                }
            }
            return ok;
        }
    }
}