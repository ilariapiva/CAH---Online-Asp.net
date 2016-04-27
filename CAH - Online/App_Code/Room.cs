﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Room
    {
        static List<Account> listUsers = new List<Account>();
        static List<Cards> RandomCardBlack, RandomCardsWhite;
        static int indexCardBlack, indexCardWhite, numberCardWhite, indexMaster;
        static Dictionary<int, List<Cards>> listCardsUsers;
         
        public Room()
        {
            indexCardBlack = 0;
            indexCardWhite = 0;
            indexMaster = 0;

            //prendo tutte le carte dalla tabella BlackCard e le inserisco in una lista
            Random rndBlackCard = new Random();

            String BlackCard = "SELECT * FROM tblBlackCard";
            List<Cards> cardBlack = FunctionsDB.Cards(BlackCard);

            RandomCardBlack = (cardBlack.OrderBy(x => rndBlackCard.Next())).ToList();
            numberCardWhite = CheckStringBlackCard();

            //prendo tutte le carte dalla tabella WhiteCard e le inserisco in una lista
            Random rndWhiteCards = new Random();

            String WhiteCards = "SELECT * FROM tblWhiteCard";
            List<Cards> cardsWhite = FunctionsDB.Cards(WhiteCards);

            RandomCardsWhite = (cardsWhite.OrderBy(x => rndWhiteCards.Next())).ToList();

            listCardsUsers = new Dictionary<int, List<Cards>>();
            
        }

        //Controllo che nella lista listUsers non ci siano già 5 giocatori
        public bool AddUser(Account user)
        {
            if (listUsers.Count <= 5)
            {
                listUsers.Add(user);
                listCardsUsers.Add(user.idAccount, new List<Cards>());
                return true;
            }
            else
            {
                return false;
            }
        }

        //Elimino i giocatori dalla lista
        public void DeleteUser(Account user)
        {
            foreach (Account u in listUsers)
            {
                if (u.idAccount == user.idAccount)
                {
                    listUsers.Remove(u);
                    break;
                }
            }
        }

        //Controllo che la lista degli utenti non sia piena
        public bool IsFull()
        {
            if (listUsers.Count < 5)
            {
                return false;
            }
            else 
            {
                return true;
            }
        }

        //Questa verifica se l'utente è il master
        public bool IsMaster(Account user)
        {
            if (listUsers[indexMaster].idAccount == user.idAccount)
            {
                return true;
            }
            else
            {
                return false;
            }
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
            foreach(Cards c in listCardsUsers[user.idAccount])
            {
                if(c.idCards == idCard)
                {
                    listCardsUsers[user.idAccount].Remove(c);
                    break;
                }
            }
        }

        //Questa funzione permette di eliminare tutte le carte di un utente
        /*public void DeleteCards(Account user, List<Cards> listCards)
        {
            for (int i = 0; i < listCards.Count(); i++)
            {
                int card = listCards[i].idCards;

                DeleteCardForUser(user, card);
            }             
        }*/

        //Questa funzione restituisce la carta nera del turno a tutti i giocatori
        public Cards GetCardBlack()
        {
            Cards card = new Cards();
            card = RandomCardBlack[indexCardBlack];
            return card;
        }

        //Questa funzione restituisce il numero di spazi presenti nella blackCard selezionata
        public int CheckStringBlackCard()
        {
            String str = GetCardBlack().Text;
            String[] toFind = str.Split('_');
            return toFind.Length - 1;
        }

        /*Questa funzione controlla che il numero di carte selezionate corrispondana 
        al numero di spazi che ci sono nella blackCard*/
        public bool CheckSelectCards(List<Cards> listCards)
        {
            if (CheckStringBlackCard() == listCards.Count)
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
            if (!IsMaster(user))
            {
                if (CheckSelectCards(listCardsWhite) == true)
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
            return false;
        }

        //Questa funziona mi ritorna il numero dei giocatori meno il master presenti nella stanza
        public int UsersNotMaster(int room)
        {
            int count = 0;

            foreach (Account user in listUsers)
            {
                if (!IsMaster(user))
                {
                    count++;
                }
            }
            return count;
        }

        //Questa funzione permette di fare un nuovo round mandando avanti l'indice del master
        public int NewRaund(int room)
        {
            foreach (Account user in listUsers)
            {
                if (IsMaster(user))
                {
                    indexMaster++;
                    indexCardBlack++;
                    indexMaster = indexMaster % listUsers.Count; 
                    break;
                }
            }
            return indexMaster;
        }
    }
}