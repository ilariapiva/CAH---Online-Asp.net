using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public static class FunctionsDB
    {
        static SqlConnection cn;
        static SqlCommand cmd;

        //Questa funzione apre la connessione con il db
        public static void OpenConnectionDB()
        {
            string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            cn = new SqlConnection(strcn);
            cn.Open();
        }

        //Questa funzione verifica nelle tabelle che in valori che devono essere inseriti non siano già presenti
        public static bool CheckDB(String strsql)
        {
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            bool ok = dr.HasRows;
            dr.Close();
            cmd.Dispose();
            return ok;
        }

        //Questa funzione serve per eseguire le query  
        public static void WriteDB(String strsql)
        {
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
        }

        //Questa funzione serve per leggere i valori della tabella profilo presente nel db e li inserisce in una lista
        public static List<Account> ReadValuesProfileDB(String strsql)
        {
            List<Account> value = new List<Account>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while(dr.Read())
            {
                Account matchesPlayed = new Account(); 
                matchesPlayed.MatchesPlayed += Convert.ToInt32(dr["matchesPlayed"]);
                value.Add(matchesPlayed);

                Account matchesWon = new Account(); 
                matchesWon.MatchesWon += Convert.ToInt32(dr["matchesWon"]);
                value.Add(matchesWon);

                Account matchesMissed = new Account();
                matchesMissed.MatchesMissed += Convert.ToInt32(dr["matchesMissed"]);
                value.Add(matchesMissed);

                Account username = new Account(); 
                username.Username += dr["username"].ToString();
                value.Add(username);
            }

            dr.Close();
            cmd.Dispose();
            
            return value;
        }

        //Questa funzione legge lo username del profilo loggato e lo inserisce in una lista
        public static List<Account> ReadUsernameDB(String strsql)
        {
            List<Account> value = new List<Account>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Account username = new Account(); 
                username.Username += dr["username"].ToString();
                value.Add(username);
            }

            dr.Close();
            cmd.Dispose();

            return value;
        }

        //Questa funzione legge tutti gli ID delle carte inserite nel DB e le inserisce in una lista
        public static List<Cards> Cards(String strsql)
        {
            List<Cards> value = new List<Cards>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Cards cards = new Cards();
                cards.Text = dr["text"].ToString();
                value.Add(cards);
            }

            dr.Close();
            cmd.Dispose();

            return value;
        }

       /* //Questa funzione legge le righe dalla tabella White Card in modo random e le inserisce in una lista
        public static List<Cards> RadomCardWhite(String strsql)
        {
            List<Cards> value = new List<Cards>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Cards cards = new Cards();
                cards.Text = dr["text"].ToString();
                value.Add(cards);
            }

            dr.Close();
            cmd.Dispose();

            return value;

        }

        //Questa funzione legge le righe dalla tabella Black Card in modo random e le inserisce in una lista
        public static Cards RadomCardBlack(String strsql)
        {
            Cards value = new Cards();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Cards card = new Cards();
                card.Text = dr["text"].ToString();
                value = card;
            }
            
            dr.Close();
            cmd.Dispose();

            return value;
        }*/
    }
}