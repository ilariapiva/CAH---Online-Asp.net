using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Room
    {
        List<Account> listUsers = new List<Account>();
        List<Cards> RandomCardBlack, RandomCardsWhite, CardsWhiteSelect;
        int indexCardBlack, indexCardWhite, indexMaster, numberCardWhite;

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
        public bool AddUser(Account user)
        {
            if(listUsers.Count <= 5)
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
        public bool IsFull()
        {
            if(listUsers.Count < 5)
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
            if(listUsers[indexMaster].idAccount == user.idAccount)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        //Questa funzione restituisce le carte bianche dell'utente
        public List<Cards> GetNewCardsWhite()
        {
            List<Cards> cards = new List<Cards>();

            for(int i = 0; i<10; i++)
            {
                cards.Add(RandomCardsWhite[indexCardWhite + i]);
            }

            indexCardWhite += 10;
            return cards;
        }

        //Questa funzione restituisce una nuova carta bianca
        public Cards GetNewCardWhite()
        {
            Cards card = new Cards();
            card = RandomCardsWhite[indexCardWhite];
            indexCardWhite++;
            return card;
        }

        //Questa funzione restituisce la carta nera del turno a tutti i giocatori
        public Cards GetCardBlack()
        {
            Cards card = new Cards();
            card = RandomCardBlack[indexCardBlack];
            return card;
        }

        public int CheckStringBlackCard()
        {
            String str = GetCardBlack().Text;
            String[] toFind = str.Split('_');
            return toFind.Length - 1;
        }

        /*public bool CheckSelectCards()
        {
            foreach (Account user in listUsers)
            {
              
            }
        }*/
    }
}