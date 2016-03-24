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
         

        //Questa funzione apre la connessione con il db
        public static void OpenConnectionDB()
        {
            if (!IsOpenConnection())
            {
                string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
                cn = new SqlConnection(strcn);
                cn.Open();
            }
        }

        public static bool IsOpenConnection()
        {
            if(cn != null)
            {
                if(cn.State == System.Data.ConnectionState.Open)
                {
                    return true;
                }
            }
            return false;
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
            OpenConnectionDB();

            String strsql = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "' and pwd = HASHBYTES('SHA1', '" + pwd + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn);
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
            OpenConnectionDB();

            String strsql = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn);
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
            OpenConnectionDB();

            String strsql = "SELECT username FROM tblAccount WHERE username = '" + user.Username + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn);
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
            OpenConnectionDB();

            String strsql = @"INSERT INTO tblAccount(email, username, pwd, matchesPlayed, matchesWon, matchesMissed) 
                              VALUES ('" + email.Email + "', '" + user.Username + "', HASHBYTES('SHA1', '" + pwd + "'), '0', '0', '0')";
            SqlCommand cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
        }

        //Questa funzione modifica lo username e la e la password di un utente
        public static void ChangeUsername(Account user)
        {
            OpenConnectionDB();

            String strsqlUser = "UPDATE tblAccount SET username = '" + user.Username + "' WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            SqlCommand cmd = new SqlCommand(strsqlUser, cn);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
        }

        //Questa funzione permette di cambiare una pwd in base alla email che è loggata
        public static void ChangePwd(String pwd)
        {
            OpenConnectionDB();

            String strsqlPwd = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "') WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            SqlCommand cmd = new SqlCommand(strsqlPwd, cn);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
        }

        //Questa funzione serve per leggere i valori della tabella profilo presente nel db e li inserisce in una lista
        public static Account ReadValuesProfileDB()
        {
            OpenConnectionDB();

            String strsql = @"SELECT idAccount, email, username, matchesPlayed, matchesWon, matchesMissed FROM tblAccount 
                            WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            Account value = new Account();
            SqlCommand cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();
            if(dr.HasRows)
            {
                dr.Read();
                value.MatchesPlayed = Convert.ToInt32(dr["matchesPlayed"]);
                value.MatchesWon = Convert.ToInt32(dr["matchesWon"]);
                value.MatchesMissed = Convert.ToInt32(dr["matchesMissed"]);
                value.Username = dr["username"].ToString();
                value.idAccount = Convert.ToInt32(dr["idAccount"]);
                value.Email = dr["email"].ToString();
            }
            dr.Close();
            cmd.Dispose();
            return value;
        }

        /* //Questa funzione legge lo username del profilo loggato e lo inserisce in una lista
         public static Account ReadUsernameDB()
         {
         * OpenConnectionDB();
         * 
             String strsql = "SELECT username FROM tblAccount WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";

             Account value = new Account();

             cmd = new SqlCommand(strsql, cn);
             var dr = cmd.ExecuteReader();

             dr.Read();              
             Account username = new Account(); 
             username.Username += dr["username"].ToString();
             value = username;
            
             dr.Close();

             return value;
         }*/

        //Questa funzione legge tutti gli ID delle carte inserite nel DB e le inserisce in una lista
        public static List<Cards> Cards(String strsql)
        {
            List<Cards> value = new List<Cards>();

            SqlCommand cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                Cards cards = new Cards();
                cards.idCards = Convert.ToInt32(dr["idCard"]);
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
            OpenConnectionDB();

            String strsql = "INSERT INTO tblGame(points, idAccount, room) VALUES ('0', '" + user.idAccount + "', '" + idRoom + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
        }

        //Recupero l'id della room in base all'idAccount dalla tabella Game
        public static int GetRoom(Account user)
        {
            OpenConnectionDB();

            String strsql = "SELECT room FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            int idRoom = Convert.ToInt32(dr["room"]);
            dr.Close();
            cmd.Dispose();
            return idRoom;
        }

        public static void WriteCardsSelect(Account user, Cards card, int idRoom)
        {
            OpenConnectionDB();

            String strsql = "INSERT INTO tblCardsSelect(idAccount, idCardWhite, room) VALUES ('" + user.idAccount + "', '" + card.idCards + "', '" + idRoom + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
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

            return value;
        }*/

        //Questa funzione permette di leggere le carte che sono state seleionate da un certo utente
        public static void ReadCardsSelect(Account user, Cards cardsWhite)
        {
            OpenConnectionDB();

            String strsql = "SELECT idAccount, idCardWhite room FROM tblCardsSelect";
            SqlCommand cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();
            dr.Read();
           
            user.idAccount += Convert.ToInt32(dr["idAccount"]);
            cardsWhite.idCards += Convert.ToInt32(dr["idCardWhite"]);
            
            dr.Close();
            cmd.Dispose();
        }

        //Questa funzione permette di leggere il numero delle persone di una stanza che hanno selezionato le carte
        public static bool ReadListUserInRoom(Account user, int room)
        {
            OpenConnectionDB();

            String strsql = @"SELECT COUNT(*), idAccount FROM tblCardsSelect 
                            WHERE room  = '" + room + @"' GROUP BY idAccount 
                            HAVING COUNT(*) >= 1 AND idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();
            dr.Read();
            bool ok = dr.HasRows;
            dr.Close();
            cmd.Dispose();
            return ok;    
        }
    }
}