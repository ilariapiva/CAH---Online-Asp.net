using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Room
    {
        static Dictionary<int, List<int>> listUsers = new Dictionary<int, List<int>>();
        static List<Cards> RandomCardBlack, RandomCardsWhite;
        static int indexCardBlack, indexCardWhite; //, indexMaster;//, indexUser; //numberCardWhite, 
        static Dictionary<int, List<Cards>> listCardsUsers = new Dictionary<int, List<Cards>>();
        static Dictionary<int, List<Cards>> listCardsBlack = new Dictionary<int, List<Cards>>();
        List<Cards> cardsWhite = new List<Cards>();
        List<Cards> cardBlack = new List<Cards>();

        public Room()
        {
            indexCardBlack = 0;
            indexCardWhite = 0;
            //indexMaster = 1;
            //indexUser = 0;

            //prendo tutte le carte dalla tabella BlackCard e le inserisco in una lista
            Random rndBlackCard = new Random();
            cardBlack = FunctionsDB.CardsBlack();

            RandomCardBlack = (cardBlack.OrderBy(x => rndBlackCard.Next())).ToList();
            //numberCardWhite = CheckStringBlackCard();

            //prendo tutte le carte dalla tabella WhiteCard e le inserisco in una lista
            Random rndWhiteCards = new Random();
            cardsWhite = FunctionsDB.CardsWhite();

            RandomCardsWhite = (cardsWhite.OrderBy(x => rndWhiteCards.Next())).ToList();
        }

        //Creo una nuova lista di utenti e di carte nere in base ad una stanza
        public void CreateNewListInDictionary(int idRoom)
        {
            listUsers.Add(idRoom, new List<int>());
            listCardsBlack.Add(idRoom, new List<Cards>());
        }

        //Aggiungo utenti ad una lista in base alla stanza e creo la lista delle carte
        public void AddUser(Account user, int idRoom)
        {
            listUsers[idRoom].Add(user.idAccount);
            listCardsUsers.Add(user.idAccount, new List<Cards>());
        }

        //Questa verifica se l'utente è il master
        public bool IsMaster(Account user, int idRoom)
        {
            Master indexUser = FunctionsDB.ReadMaster(idRoom, user);
            bool ok = false;
            foreach (int u in listUsers[idRoom])
            {
                if (u == indexUser.idAccount)
                {
                    if (indexUser.indexMaster == 1)
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
            List<Cards> listCards = new List<Cards>();

            int idRoom = ReturnKeyRoomUser(user);

            for (int i = 0; i < 10; i++)
            {
                listCards.Add(RandomCardsWhite[indexCardWhite + i]);
            }

            indexCardWhite += 10;        
            
            for(int i = 0; i < listCards.Count; i++)
            {
                Cards card = listCards.ElementAt(i);
                if (FunctionsDB.CheckCardsWhite(idRoom, card))
                {
                    listCards.Remove(card);
                    Cards c = new Cards();
                    while (FunctionsDB.CheckCardsWhite(idRoom, c))
                    {
                        c = RandomCardsWhite[indexCardWhite];
                        indexCardWhite++;
                    }
                    listCards.Add(c);
                    FunctionsDB.WriteCardsWhite(idRoom, user, c);
                }
                else
                {
                    FunctionsDB.WriteCardsWhite(idRoom, user, card);
                }  
            }
            listCardsUsers[user.idAccount] = listCards;
        }

        //Questa funziona genera e aggiunge una carta all'utente
        public void GenerateCardForUser(Account user)
        {
            int idRoom = ReturnKeyRoomUser(user);
            Cards card = new Cards();
            card = RandomCardsWhite[indexCardWhite];
            indexCardWhite++;

            if (FunctionsDB.CheckCardsWhite(idRoom, card))
            {
                Cards c = new Cards();
                while (FunctionsDB.CheckCardsWhite(idRoom, c))
                {
                    c = RandomCardsWhite[indexCardWhite];
                    indexCardWhite++;
                }
                listCardsUsers[user.idAccount].Add(c);
                FunctionsDB.WriteCardsWhite(idRoom, user, c);
            }
            else
            {
                listCardsUsers[user.idAccount].Add(card);
                FunctionsDB.WriteCardsWhite(idRoom, user, card);
            }    
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
            c = RandomCardBlack[indexCardBlack];
            if (FunctionsDB.CheckCardsBlack(idRoom, c))
            {
                Cards card = new Cards();
                while (FunctionsDB.CheckCardsWhite(idRoom, card))
                {
                    card = RandomCardBlack[indexCardBlack];
                }
                listCardsBlack[idRoom].Add(card);
                FunctionsDB.WriteCardsBlack(idRoom, card);
            }
            else
            {
                listCardsBlack[idRoom].Add(c);
                FunctionsDB.WriteCardsBlack(idRoom, c);
            }    
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
            int spacesBlackCard = CheckStringBlackCard(room);
            int cardsSelect = FunctionsDB.CheckNCardsSelect(room);
            int user = FunctionsDB.UsersNotMaster(room);
            //if (UsersNotMaster(room, user) == 4)
            //{
            //    if (spacesBlackCard == 1)
            //    {
            //        if (cardsSelect == 4)
            //        {
            //            return true;
            //        }
            //    }
            //    if (spacesBlackCard == 2)
            //    {
            //        if (cardsSelect == 8)
            //        {
            //            return true;
            //        }
            //        else
            //        {
            //            return false;
            //        }
            //    }

            //    if (spacesBlackCard == 3)
            //    {
            //        if (cardsSelect == 12)
            //        {
            //            return true;
            //        }
            //        else
            //        {
            //            return false;
            //        }
            //    }
            //}

            if (user == 2)
            {
                if (spacesBlackCard == 1)
                {
                    if (cardsSelect == 2)
                    {
                        return true;
                    }
                }
                if (spacesBlackCard == 2)
                {
                    if (cardsSelect == 4)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }

                if (spacesBlackCard == 3)
                {
                    if (cardsSelect == 6)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            return false;
        }


        ////Questa funziona mi ritorna il numero dei giocatori meno il master presenti nella stanza
        //public int UsersNotMaster(int room, Account user)
        //{
        //    int count = 0;

        //    foreach (int u in listUsers[room])
        //    {
        //        if (u == user.idAccount)
        //        {
        //            if (!IsMaster(user, room))
        //            {
        //                count++;
        //            }
        //            if (count == 2)
        //            {
        //                break;
        //            }
        //        }
        //    }
        //    return count;
        //}

        //Questa funzione permette di mandare avanti l'index del master
        public void NewRaund(int room, Account user)
        {     
            foreach (int u in listUsers[room])
            {
                if (u == user.idAccount)
                {
                    int indexMaster = FunctionsDB.ReadIndexMaster(room);
                    //if (IsMaster(user, room))
                    //{
                    if (indexMaster == 3)
                    {
                        FunctionsDB.ResetIndexMaster(room);
                        //indexMaster = 0;
                        //indexUser = 0;
                        indexCardBlack++;
                        GetCardBlack(room);
                        //indexMaster = indexMaster % listUsers[room].Count;
                        FunctionsDB.UpdateMaster(room, 0, user.idAccount);                      
                        break;
                    }
                    else if (indexMaster < 3)
                    {
                        //indexMaster++;
                        //indexUser++;
                        indexCardBlack++;
                        GenerateCardBlack(room);
                        //indexMaster = indexMaster % listUsers[room].Count;
                        FunctionsDB.UpdateMaster(room, 0, user.idAccount);
                        FunctionsDB.UpdateIndexMaster(room);
                        break;
                    }
                    //}
                }
            }

            int masterIndex = FunctionsDB.ReadIndexMaster(room);
            foreach (int u in listUsers[room])
            {
                int userIndex = listUsers[room].FindIndex(x => x == u);          
                if (userIndex == masterIndex)
                {
                    int idAccount = listUsers[room].ElementAt(userIndex);
                    FunctionsDB.UpdateMaster(room, 1, idAccount);
                    break;
                }
            }
            //List<Account> listIdAccount = FunctionsDB.GetIdAccountFromGame(room);
            //foreach (Account id in listIdAccount)
            //{
            //    int idAccount = listIdAccount.IndexOf(id);
            //    if(idAccount == masterIndex)
            //    {
            //        int idUser = listUsers[room].ElementAt(id.idAccount);
            //        FunctionsDB.UpdateMaster(room, 1, idAccount);
            //    }
            //}
                //foreach (int u in listUsers[room])
                //{
                    //for (int u = 0; u < listUsers[room].Count; u++)
                    //{

                    //int userIndex = listUsers[room].FindIndex(x => x == u);
                    //int idAccount = listUsers[room].ElementAt(u);
                    //if (idAccount == indexMaster)
                    //{
                    //    FunctionsDB.UpdateMaster(room, 1, u);
                    //    break;
                    //}
                //}
            //}
                //foreach (int u in listUsers[room])
                //{
                //    if (u == user.idAccount)
                //    {
                //        int index = listUsers[room].IndexOf(u);
                //        if (index == indexMaster)
                //        {
                //            FunctionsDB.UpdateMaster(room, 1, user);
                //            break;
                //        }
                //    }
                //}

            FunctionsDB.UpdateRounds(room);
            int round = 1;
            FunctionsDB.UpdateNewRound(room, round);
            //return indexMaster;
        }

        //Questa funzione permette di eliminare le carte di un utente
        public void DeleteCardsUser(Account user)
        {
            //listCardsUsers[user.idAccount].Clear();
            listCardsUsers.Remove(user.idAccount);
        }

        //Questa funzione permette di eliminare un utente da una stanza
        public void DeleteUser(int indexRoom, Account user)
        {
            foreach (int u in listUsers[indexRoom])
            {
                if (u == user.idAccount)
                {
                    listUsers[indexRoom].Remove(u);
                    break;
                }
            }
        }

        //Questa funzione permette di controllare se la stanza è piena
        public bool listUserIsFull(int indexRoom)
        {
            bool ok = false;

            if (listUsers.ContainsKey(indexRoom))
            {
                if (listUsers[indexRoom].Count == 3)
                {
                    ok = true;
                }
            }
            return ok;
        }
        //Questa funzione permette di eliminare le carte nere di una stanza
        public void DeleteCardBlack(int indexRoom)
        {
            listCardsBlack[indexRoom] = new List<Cards>();
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

        //Questa funzione permette di controllare se nella lista degli user l'utente è stato eliminato
        public bool CheckDeleteUser(int indexRoom, Account user)
        {
            bool ok = false;
            //if (listUsers.ContainsKey(indexRoom))
            //{
            foreach (int u in listUsers[indexRoom])
                {
                    if (u == user.idAccount)
                    {
                        ok = true;
                        break;
                    }
                }
            //}
            return ok;
        }

        //Questa funzione resituisce la idRoom 
        public int ReturnKeyRoomUser(Account user)
        {
            Game g = new Game();
            List<Room> listRooms = g.rooms();
            int indexRoom = 0;

            for (int i = 0; i < listRooms.Count; i++)
            {
                foreach (int u in listUsers[i])
                {
                    if (u == user.idAccount)
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
                if (listRooms.Count == 0)
                {
                    break;
                }
                else
                {
                    foreach (int u in listUsers[i])
                    {
                        if (u == user.idAccount)
                        {
                            ok = true;
                            break;
                        }
                    }
                    if (ok == true)
                    {
                        break;
                    }
                }
            }
            return ok;
        }
    }
}