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

        //Questa funzione controlla che la connessione sia aperta
        public static bool IsOpenConnection()
        {
            if (cn != null)
            {
                if (cn.State == System.Data.ConnectionState.Open)
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

        public static void DeleteCookies(Account userEmail)
        {
            HttpCookie aCookie;
            int limit = HttpContext.Current.Request.Cookies.Count;
            for (int i = 0; i < limit; i++)
            {
                userEmail.Email = HttpContext.Current.Request.Cookies[i].Name;
                aCookie = new HttpCookie(userEmail.Email);
                aCookie.Expires = DateTime.Now.AddDays(-1);
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }
        //Questa funzione controlla che l'email e la pwd siano inseriti nel DB
        public static bool Login(Account email, String pwd)
        {
            string strcn1 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn1 = new SqlConnection(strcn1);
            cn1.Open();

            String strsql = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "' and pwd = HASHBYTES('SHA1', '" + pwd + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn1);
            cmd.ExecuteNonQuery();
            var dr1 = cmd.ExecuteReader();
            dr1.Read();
            bool ok = dr1.HasRows;
            dr1.Close();
            cmd.Dispose();
            cn1.Close();
            return ok;
        }

        //Questa funzione controlla che l'email non sia già stata inserita nel DB
        public static bool CeckEmail(Account email)
        {
            string strcn2 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn2 = new SqlConnection(strcn2);
            cn2.Open();

            String strsql = "SELECT email FROM tblAccount WHERE email = '" + email.Email + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn2);
            cmd.ExecuteNonQuery();
            var dr2 = cmd.ExecuteReader();
            dr2.Read();
            bool ok = dr2.HasRows;
            dr2.Close();
            cmd.Dispose();
            cn2.Close();
            return ok;
        }

        //Questa funzione controlla che lo username non sia già stato inserito nel DB
        public static bool CeckUsername(Account user)
        {
            string strcn3 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn3 = new SqlConnection(strcn3);
            cn3.Open();

            String strsql = "SELECT username FROM tblAccount WHERE username = '" + user.Username + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn3);
            cmd.ExecuteNonQuery();
            var dr3 = cmd.ExecuteReader();
            dr3.Read();
            bool ok = dr3.HasRows;
            dr3.Close();
            cmd.Dispose();
            cn3.Close();
            return ok;
        }

        //Questa funzione registra il nuovo utente e lo inserisce nella tabella Account
        public static void RegisterUser(Account email, Account user, String pwd)
        {
            string strcn4 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn4 = new SqlConnection(strcn4);
            cn4.Open();

            String strsql = @"INSERT INTO tblAccount(email, username, pwd, matchesPlayed, matchesWon, matchesMissed) 
                              VALUES ('" + email.Email + "', '" + user.Username + "', HASHBYTES('SHA1', '" + pwd + "'), '0', '0', '0')";
            SqlCommand cmd = new SqlCommand(strsql, cn4);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn4.Close();
        }

        //Questa funzione modifica lo username e la e la password di un utente
        public static void ChangeUsername(Account user)
        {
            string strcn5 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn5 = new SqlConnection(strcn5);
            cn5.Open();

            String strsqlUser = "UPDATE tblAccount SET username = '" + user.Username + "' WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            SqlCommand cmd = new SqlCommand(strsqlUser, cn5);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn5.Close();
        }

        //Questa funzione permette di cambiare una pwd in base alla email che è loggata
        public static void ChangePwd(String pwd)
        {
            string strcn6 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn6 = new SqlConnection(strcn6);
            cn6.Open();

            String strsqlPwd = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "') WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            SqlCommand cmd = new SqlCommand(strsqlPwd, cn6);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn6.Close();
        }

        //Questa funzione serve per leggere i valori della tabella profilo presente nel db
        public static Account ReadValuesProfileDB()
        {
            string strcn7 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn7 = new SqlConnection(strcn7);
            cn7.Open();

            String strsql = @"SELECT idAccount, email, username, matchesPlayed, matchesWon, matchesMissed FROM tblAccount 
                            WHERE email = '" + HttpContext.Current.Session["userEmail"] + "' ";
            Account value = new Account();
            SqlCommand cmd = new SqlCommand(strsql, cn7);
            var dr7 = cmd.ExecuteReader();
            if (dr7.HasRows)
            {
                dr7.Read();
                value.MatchesPlayed = Convert.ToInt32(dr7["matchesPlayed"]);
                value.MatchesWon = Convert.ToInt32(dr7["matchesWon"]);
                value.MatchesMissed = Convert.ToInt32(dr7["matchesMissed"]);
                value.Username = dr7["username"].ToString();
                value.idAccount = Convert.ToInt32(dr7["idAccount"]);
                value.Email = dr7["email"].ToString();
            }
            dr7.Close();
            cmd.Dispose();
            cn7.Close();
            return value;
        }

        //Questa funzione legge tutti gli ID delle carte inserite nel DB e le inserisce in una lista
        public static List<Cards> Cards(String strsql)
        {
            string strcn8 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn8 = new SqlConnection(strcn8);
            cn8.Open();

            List<Cards> value = new List<Cards>();

            SqlCommand cmd = new SqlCommand(strsql, cn8);
            var dr8 = cmd.ExecuteReader();

            while (dr8.Read())
            {
                Cards cards = new Cards();
                cards.idCards = Convert.ToInt32(dr8["idCard"]);
                cards.Text = dr8["text"].ToString();
                value.Add(cards);
            }

            dr8.Close();
            cmd.Dispose();
            cn8.Close();
            return value;
        }

        //Scrivo nella tabella Game
        public static void WriteGame(Account user, int idRoom)
        {
            string strcn9 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn9 = new SqlConnection(strcn9);
            cn9.Open();

            String strsql = "INSERT INTO tblGame(points, idAccount, room) VALUES ('0', '" + user.idAccount + "', '" + idRoom + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn9);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn9.Close();
        }

        //Recupero l'id della room in base all'idAccount dalla tabella Game
        public static int GetRoom(Account user)
        {
            string strcn10 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn10 = new SqlConnection(strcn10);
            cn10.Open();

            String strsql = "SELECT room FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn10);
            cmd.ExecuteNonQuery();
            var dr10 = cmd.ExecuteReader();
            dr10.Read();
            int idRoom = Convert.ToInt32(dr10["room"]);
            cmd.Dispose();
            cn10.Close();
            return idRoom;
        }

        /*Questa funzione permette di scrivere nella tabella CardsSelect lo user, la 
        stanza in cui si trova e la/e carta/e che ha selezionato*/
        public static void WriteCardsSelect(Account user, Cards card, int idRoom)
        {
            string strcn11 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn11 = new SqlConnection(strcn11);
            cn11.Open();

            String strsql = "INSERT INTO tblCardsSelect(idAccount, idCardWhite, room) VALUES ('" + user.idAccount + "', '" + card.idCards + "', '" + idRoom + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn11);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn11.Close();
        }

        /*Questa funzione permette di leggere tutti gli id degli utenti (tranne il master)  
          che sono in una stanza e inserirli in una lista*/
        public static List<Account> ReadUsernames(int room)
        {
            string strcn12 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn12 = new SqlConnection(strcn12);
            cn12.Open();

            List<Account> ListUsers = new List<Account>();

            String strsql = @"SELECT a.idAccount, a.username FROM tblAccount AS a INNER JOIN tblCardsSelect as cs
                              ON a.idAccount = cs.idAccount WHERE cs.room = '" + room + "' ORDER BY cs.idAccount ASC";

            SqlCommand cmd = new SqlCommand(strsql, cn12);
            var dr12 = cmd.ExecuteReader();

            while (dr12.Read())
            {
                Account value = new Account();
                value.idAccount = Convert.ToInt32(dr12["idAccount"]);
                value.Username = dr12["username"].ToString();
                ListUsers.Add(value);
            }
            dr12.Close();
            cmd.Dispose();
            cn12.Close();
            return ListUsers;
        }

        public static Account ReadUserWin(int room, Cards cardId)
        {
            string strcn13 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn13 = new SqlConnection(strcn13);
            cn13.Open();

            String strsql = "SELECT idAccount FROM tblCardsSelect WHERE room = '" + room + @"' 
                             and idCardWhite = '" + cardId.idCards + "'";

            SqlCommand cmd = new SqlCommand(strsql, cn13);
            cmd.ExecuteNonQuery();
            var dr13 = cmd.ExecuteReader();
            dr13.Read();
            Account user = new Account();
            user.idAccount = Convert.ToInt32(dr13["idAccount"]);
            dr13.Close();
            cmd.Dispose();
            cn13.Close();
            return user;
        }

        public static Winner PointUserWin(int room, Cards cardId)
        {
            string strcn14 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn14 = new SqlConnection(strcn14);
            cn14.Open();

            Account user = ReadUserWin(room, cardId);

            String strsql = "SELECT idAccount, points FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn14);
            Winner value = new Winner();
            var dr14 = cmd.ExecuteReader();
            if (dr14.HasRows)
            {
                dr14.Read();
                value.idAccount = Convert.ToInt32(dr14["idAccount"]);
                value.Point = Convert.ToInt32(dr14["points"]); ;
            }

            dr14.Close();
            cmd.Dispose();
            cn14.Close();
            return value;
        }
        //Questa funzione mi permette di scrivere nella tblGame il punteggio al vincitore
        public static void WritePointUserWin(int room, Cards cardId)
        {
            string strcn15 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn15 = new SqlConnection(strcn15);
            cn15.Open();

            Winner point = PointUserWin(room, cardId);
            String strsql = "UPDATE tblGame SET points = '" + point.Point + 1 + "' WHERE idAccount = '" + point.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn15);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn15.Close();
        }

        /*Questa funzione permette di leggere tutti gli id delle carte selezionate e i testi e 
        inserirli in una lista*/
        public static List<Cards> ReadTetxtCardsSelect(int room)
        {
            string strcn16 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn16 = new SqlConnection(strcn16);
            cn16.Open();

            List<Cards> ListIdCards = new List<Cards>();

            String strsql = @"SELECT cs.idCardWhite, wc.text FROM tblCardsSelect as cs INNER JOIN tblWhiteCard as wc 
                                ON cs.idCardWhite = wc.idCard WHERE room = '" + room + "' ORDER BY cs.idAccount ASC";
            SqlCommand cmd = new SqlCommand(strsql, cn16);
            var dr16 = cmd.ExecuteReader();

            while (dr16.Read())
            {   
                if (dr16.HasRows)
                {
                    //dr.Read();
                    Cards value = new Cards();
                    value.idCards = Convert.ToInt32(dr16["idCardWhite"]);
                    value.Text = dr16["text"].ToString();
                    ListIdCards.Add(value);
                } 
            }
            dr16.Close();
            cmd.Dispose();
            cn16.Close();
            return ListIdCards;
        }

        //Questa funzione permette di leggere il numero delle persone di una stanza che hanno selezionato le carte
        public static bool ReadListUserInRoom(Account user, int room)
        {
            string strcn17 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn17 = new SqlConnection(strcn17);
            cn17.Open();

            String strsql = @"SELECT COUNT(*), idAccount FROM tblCardsSelect GROUP BY idAccount 
                              HAVING COUNT(*) >= 1 AND idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn17);
            var dr17 = cmd.ExecuteReader();
            dr17.Read();
            bool ok = dr17.HasRows;
            dr17.Close();
            cmd.Dispose();
            cn17.Close();
            return ok;
        }
    }
}