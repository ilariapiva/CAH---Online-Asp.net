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

        //Questa funzione risponde l'email memorizzata nei cookies
        public static void CookiesRequest()
        {
            if (HttpContext.Current.Request.Cookies["userEmail"] != null)
            {
                HttpContext.Current.Session["userEmail"] = HttpContext.Current.Server.HtmlEncode(HttpContext.Current.Request.Cookies["userEmail"].Value);
            } 
        }

        //Questa funzione salva l'email nei cookies
        public static void CookiesResponse(Account userEmail)
        {
            HttpContext.Current.Response.Cookies["userEmail"].Value = userEmail.Email;
            HttpContext.Current.Response.Cookies["userEmail"].Expires = DateTime.Now.AddDays(1);

            HttpContext.Current.Session["userEmail"] = userEmail.Email;
        }

        //Questa funzione controlla che l'email e la pwd siano inseriti nel DB
        public static bool Login(Account email, String pwd)
        {
            String strsql = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "' and pwd = HASHBYTES('SHA1', '" + pwd + "')";
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            bool ok = dr.HasRows;
            dr.Close();
            cmd.Dispose();
            return ok;
        }

        //Questa funzione controlla che l'email non sia già stata inserita nel DB
        public static bool CeckEmail(Account email)
        {
            String strsql = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "'";
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            bool ok = dr.HasRows;
            dr.Close();
            cmd.Dispose();
            return ok;
        }

        //Questa funzione controlla che lo username non sia già stato inserito nel DB
        public static bool CeckUsername(Account user)
        {
            String strsql = "SELECT username FROM tblAccount WHERE username = '" + user.Username + "'";
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            bool ok = dr.HasRows;
            dr.Close();
            cmd.Dispose();
            return ok;         
        }

        //Questa funzione registra il nuovo utente e lo inserisce nella tabella Account
        public static void RegisterUser(Account email, Account user, String pwd)
        {
            String strsql = @"INSERT INTO tblAccount(email, username, pwd, matchesPlayed, matchesWon, matchesMissed) 
                              VALUES ('" + email.Email + "', '" + user.Username + "', HASHBYTES('SHA1', '" + pwd + "'), '0', '0', '0')";
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery(); 
        }

        //Questa funzione modifica lo username e la e la password di un utente
        public static void ChangeUsername(Account user)
        {
            String strsqlUser = "UPDATE tblAccount SET username = '" + user.Username + "' WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            cmd = new SqlCommand(strsqlUser, cn);
            cmd.ExecuteNonQuery();
        }

        //Questa funzione permette di cambiare una pwd in base alla email che è loggata
        public static void ChangePwd(String pwd)
        {
            String strsqlPwd = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "') WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            cmd = new SqlCommand(strsqlPwd, cn);
            cmd.ExecuteNonQuery();
        }

        //Questa funzione serve per leggere i valori della tabella profilo presente nel db e li inserisce in una lista
        public static List<Account> ReadValuesProfileDB()
        {
            String strsql = @"SELECT username, matchesPlayed, matchesWon, matchesMissed FROM tblAccount WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";

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
        public static Account ReadUsernameDB()
        {
            String strsql = "SELECT username FROM tblAccount WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";

            Account value = new Account();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            dr.Read();              
            Account username = new Account(); 
            username.Username += dr["username"].ToString();
            value = username;
            
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

        //Scrivo nella tabella Game
        public static void WriteGame(Account user, int idRoom)
        {
            String strsql = "INSERT INTO tblGame(points, idAccount, room) VALUES ('0', '" + user.idAccount + "', '" + idRoom + "'";
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
        }

        //Recupero l'id della room in base all'idAccount dalla tabella Game
        public static int GetRoom(Account user)
        {
            String strsql = "SELECT room FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            int idRoom = Convert.ToInt32(dr["room"]);
            dr.Close();
            cmd.Dispose();
            return idRoom;
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