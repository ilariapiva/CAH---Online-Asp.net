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
        public static List<string> ReadValuesProfileDB(String strsql)
        {
            String username = null;
            String matchesPlayed = null;
            String matchesWon = null;
            String matchesMissed = null;

            List<string> value = new List<string>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while(dr.Read())
            {
                matchesPlayed += dr["matchesPlay"];
                value.Add(matchesPlayed);

                matchesWon += dr["matchesWon"];
                value.Add(matchesWon);

                matchesMissed += dr["matchesMissed"];
                value.Add(matchesMissed);

                username += dr["username"];
                value.Add(username);

            }

            dr.Close();
            cmd.Dispose();
            
            return value;
        }

        //Questa funzione legge lo username del profilo loggato e lo inserisce in una lista
        public static List<string> ReadUsernameDB(String strsql)
        {
            String Username = null;
            
            List<string> value = new List<string>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Username += dr["username"];
                value.Add(Username);
            }

            dr.Close();
            cmd.Dispose();

            return value;
        }

        /*public static void Cookies(String lblEmail)
        {
            lblEmail = Request.Cookies["userEmail"].Value;

            if (Request.Cookies["userEmail"] != null)
            {
                lblEmail = Server.HtmlEncode(Request.Cookies["userEmail"].Value);
            }
            String email = lblEmail;

            String strsql = "SELECT username FROM tblAccount WHERE email = '" + email + "' ";
        }*/
    }
}