using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Room
    {
        static List<Account> listUsers = new List<Account>();
        static List<Cards> RandomCardBlack, RandomCardsWhite, CardsWhiteSelect;
        static int indexCardBlack, indexCardWhite, numberCardWhite, indexMaster;
         
        public Room()
        {
            indexCardBlack = 0;
            indexCardWhite = 0;
            indexMaster = 0;

            //prendo tutte le carte dalla tabella BlackCard e le inserisco in una lista
            Random rndBlackCard = new Random();

            String BlackCard = "SELECT idCard, text FROM tblBlackCard";
            List<Cards> cardBlack = FunctionsDB.Cards(BlackCard);

            RandomCardBlack = (cardBlack.OrderBy(x => rndBlackCard.Next())).ToList();
            numberCardWhite = CheckStringBlackCard();

            //prendo tutte le carte dalla tabella WhiteCard e le inserisco in una lista
            Random rndWhiteCards = new Random();

            String WhiteCards = "SELECT idCard, text FROM tblWhiteCard";
            List<Cards> cardsWhite = FunctionsDB.Cards(WhiteCards);

            RandomCardsWhite = (cardsWhite.OrderBy(x => rndWhiteCards.Next())).ToList();

        }

        //Controllo che nella lista listUsers non ci siano già 5 giocatori
        public static bool AddUser(Account user)
        {
            if (listUsers.Count <= 5)
            {
                listUsers.Add(user);
                return true;
            }
            else
            {
                return false;
            }
        }

        //Controllo che la lista degli utenti non sia piena
        public static bool IsFull()
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
        public static bool IsMaster(Account user)
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
        public static List<Cards> GetNewCardsWhite()
        {
            List<Cards> cards = new List<Cards>();

            for (int i = 0; i < 10; i++)
            {
                cards.Add(RandomCardsWhite[indexCardWhite + i]);
            }

            indexCardWhite += 10;
            return cards;
        }

        //Questa funzione restituisce una nuova carta bianca
        public static Cards GetNewCardWhite()
        {
            Cards card = new Cards();
            card = RandomCardsWhite[indexCardWhite];
            indexCardWhite++;
            return card;
        }

        //Questa funzione restituisce la carta nera del turno a tutti i giocatori
        public static Cards GetCardBlack()
        {
            Cards card = new Cards();
            card = RandomCardBlack[indexCardBlack];
            return card;
        }

        //Questa funzione restituisce il numero di spazi presenti nella blackCard selezionata
        public static int CheckStringBlackCard()
        {
            String str = GetCardBlack().Text;
            String[] toFind = str.Split('_');
            return toFind.Length - 1;
        }

        /*Questa funzione controlla che il numero di carte selezionate corrispondana 
        al numero di spazi che ci sono nella blackCard*/
        public static bool CheckSelectCards(List<Cards> listCards)
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
        public static void UsersAndCards(List<Cards> listCardsWhite, int idRoom)
        {
            foreach (Account user in listUsers)
            {
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
        }

        //Questa funzione permette di cercare nel db se lo user ha selezionato la carta
        public static bool CheckUserCardSelected(int room)
        {
            int count = 0;

            foreach (Account user in listUsers)
            {
                if (!IsMaster(user))
                {
                    if(FunctionsDB.ReadListUserInRoom(user, room))
                    {
                        count++;
                    }
                }
            }

            if (count == 4)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}