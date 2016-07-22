using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
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
        public static String CookiesRequest()
        {
            String email = "";
            if (HttpContext.Current.Request.Cookies["userEmail"] != null)
            {
                HttpContext.Current.Session["userEmail"] = HttpContext.Current.Server.HtmlEncode(HttpContext.Current.Request.Cookies["userEmail"].Value);
                email = Convert.ToString(HttpContext.Current.Session["userEmail"]);
            }
            return email;
        }

        //Questa funzione controlla se il cookies esiste
        public static bool ExistCookies()
        {
            String existEmailCookies = CookiesRequest();
            if(existEmailCookies != "")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        //Questa funzione salva l'email nei cookies
        public static void CookiesResponse(Account userEmail)
        {
            HttpContext.Current.Response.Cookies["userEmail"].Value = userEmail.Email;
            HttpContext.Current.Response.Cookies["userEmail"].Expires = DateTime.Now.AddDays(1);

            HttpContext.Current.Session["userEmail"] = userEmail.Email;
        }

        //Questa funzione elimina il coockies
        public static void DeleteCookies(Account userEmail)
        {
            HttpCookie aCookie;
            string cookieName;
            int limit = HttpContext.Current.Request.Cookies.Count;
            for (int i = 0; i < limit; i++)
            {
                cookieName = HttpContext.Current.Request.Cookies[i].Name;
                aCookie = new HttpCookie(cookieName);
                aCookie.Expires = DateTime.Now.AddDays(-1);
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }

        //Questa funzione permette di selezionare la pwd criptata in base all'email
        private static String SelectPwd(String email)
        {
            string strcn1 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn1 = new SqlConnection(strcn1);
            cn1.Open();

            String strsql = "SELECT pwd FROM tblAccount WHERE email = @email";
            SqlCommand cmd = new SqlCommand(strsql, cn1);
            cmd.Parameters.AddWithValue("email", email);

            String value = "";
            var dr1 = cmd.ExecuteReader();
            if (dr1.HasRows)
            {
                dr1.Read();
                value = dr1["pwd"].ToString();
            }

            dr1.Close();
            cmd.Dispose();
            cn1.Close();
            return value;
        }

        //Questa funzione controlla che l'email e la pwd siano inseriti nel DB
        public static bool Login(String email, String pwd)
        {
            String pass = SelectPwd(email);

            if(pass == "")
            {
                return false;
            }

            if (Hashing.ValidatePassword(pwd, pass) == true)
            {
                return true;
            } 
            else
            {
                return false;
            }
        }

        //Questa funzione controlla che l'email non sia già stata inserita nel DB
        public static bool CeckEmail(String email)
        {
            string strcn2 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn2 = new SqlConnection(strcn2);
            cn2.Open();

            String strsql = "SELECT email FROM tblAccount WHERE email = @email";
            SqlCommand cmd = new SqlCommand(strsql, cn2);
            cmd.Parameters.AddWithValue("email", email);
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
        public static bool CeckUsername(String user)
        {
            string strcn3 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn3 = new SqlConnection(strcn3);
            cn3.Open();

            String strsql = "SELECT username FROM tblAccount WHERE username = @username";
            SqlCommand cmd = new SqlCommand(strsql, cn3);
            cmd.Parameters.AddWithValue("username", user);
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
        public static void RegisterUser(String email, String user, String pwd)
        {
            string strcn4 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn4 = new SqlConnection(strcn4);
            cn4.Open();

            String pass = Hashing.HashPassword(pwd);

            String strsql = @"INSERT INTO tblAccount(email, username, pwd, matchesPlayed, matchesWon, matchesMissed, matchesEqualized) 
                              VALUES (@email, @username, @pwd, '0', '0', '0', '0')";
            SqlCommand cmd = new SqlCommand(strsql, cn4);
            cmd.Parameters.AddWithValue("email", email);
            cmd.Parameters.AddWithValue("username", user);
            cmd.Parameters.AddWithValue("pwd", pass);

            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn4.Close();
        }

        //Questa funzione modifica lo username di un utente
        public static void ChangeUsername(String user)
        {
            string strcn5 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn5 = new SqlConnection(strcn5);
            cn5.Open();

            String email = CookiesRequest();
            String strsqlUser = "UPDATE tblAccount SET username = @username WHERE email = '" + email + "' ";
            SqlCommand cmd = new SqlCommand(strsqlUser, cn5);
            cmd.Parameters.AddWithValue("username", user);
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
            
            String pass = Hashing.HashPassword(pwd);
            String email = CookiesRequest();

            String strsqlPwd = "UPDATE tblAccount SET pwd = @pwd WHERE email = '" + email + "' ";
            SqlCommand cmd = new SqlCommand(strsqlPwd, cn6);
            cmd.Parameters.AddWithValue("pwd", pass);
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

            String email = CookiesRequest();
            String strsql = @"SELECT idAccount, email, username, matchesPlayed, matchesWon, matchesMissed, matchesEqualized FROM tblAccount 
                            WHERE email = '" + email + "' ";
            Account value = new Account();
            SqlCommand cmd = new SqlCommand(strsql, cn7);
            var dr4 = cmd.ExecuteReader();
            if (dr4.HasRows)
            {
                dr4.Read();
                value.MatchesPlayed = Convert.ToInt32(dr4["matchesPlayed"]);
                value.MatchesWon = Convert.ToInt32(dr4["matchesWon"]);
                value.MatchesMissed = Convert.ToInt32(dr4["matchesMissed"]);
                value.MatchesEqualized = Convert.ToInt32(dr4["matchesEqualized"]);
                value.Username = dr4["username"].ToString();
                value.idAccount = Convert.ToInt32(dr4["idAccount"]);
                value.Email = dr4["email"].ToString();
            }
            dr4.Close();
            cmd.Dispose();
            cn7.Close();
            return value;
        }

        //Questa funzione legge tutti gli ID delle carte inserite nel DB e le inserisce in una lista
        public static List<Cards> CardsBlack()
        {
            string strcn8 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn8 = new SqlConnection(strcn8);
            cn8.Open();

            List<Cards> value = new List<Cards>();
            String strsql = "SELECT * FROM tblBlackCards ";
            SqlCommand cmd = new SqlCommand(strsql, cn8);
            var dr5 = cmd.ExecuteReader();

            while (dr5.Read())
            {
                Cards cards = new Cards();
                cards.idCards = Convert.ToInt32(dr5["idBlackCards"]);
                cards.Text = dr5["textBlack"].ToString();
                value.Add(cards);
            }

            dr5.Close();
            cmd.Dispose();
            cn8.Close();
            return value;
        }

        //Questa funzione legge tutti gli ID delle carte inserite nel DB e le inserisce in una lista
        public static List<Cards> CardsWhite()
        {
            string strcn9 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn9 = new SqlConnection(strcn9);
            cn9.Open();

            List<Cards> value = new List<Cards>();
            String strsql = "SELECT * FROM tblWhiteCards";
            SqlCommand cmd = new SqlCommand(strsql, cn9);
            var dr6 = cmd.ExecuteReader();

            while (dr6.Read())
            {
                Cards cards = new Cards();
                cards.idCards = Convert.ToInt32(dr6["idWhiteCards"]);
                cards.Text = dr6["textWhite"].ToString();
                value.Add(cards);
            }

            dr6.Close();
            cmd.Dispose();
            cn9.Close();
            return value;
        }

        //Scrivo nella tabella Game
        public static void WriteGame(Account user, int idRoom, int indexMaster)
        {
            string strcn10 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn10 = new SqlConnection(strcn10);
            cn10.Open();

            String strsql = @"INSERT INTO tblGame(points, idAccount, idRoom, isMaster) 
                            VALUES (0, '" + user.idAccount + "', '" + idRoom + "', '" + indexMaster + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn10);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn10.Close();
        }

        //Recupero l'id della room in base all'idAccount dalla tabella Game
        public static int GetRoom(Account user)
        {
            string strcn11 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn11 = new SqlConnection(strcn11);
            cn11.Open();

            String strsql = "SELECT idRoom FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn11);
            cmd.ExecuteNonQuery();
            var dr7 = cmd.ExecuteReader();
            dr7.Read();
            int idRoom = Convert.ToInt32(dr7["idRoom"]);
            cmd.Dispose();
            cn11.Close();
            return idRoom;
        }

        /*Questa funzione permette di scrivere nella tabella CardsSelect lo user, la 
        stanza in cui si trova e la/e carta/e che ha selezionato*/
        public static void WriteCardsSelect(Account user, Cards card, int idRoom)
        {
            string strcn12 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn12 = new SqlConnection(strcn12);
            cn12.Open();

            String strsql = "INSERT INTO tblSelectedCards(idAccount, idWhiteCards, idRoom) VALUES ('" + user.idAccount + "', '" + card.idCards + "', '" + idRoom + "')";
            SqlCommand cmd = new SqlCommand(strsql, cn12);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn12.Close();
        }

        /*Questa funzione permette di leggere tutti gli id degli utenti (tranne il master)  
          che sono in una stanza e inserirli in una lista*/
        public static List<Account> ReadUsernames(int room)
        {
            string strcn13 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn13 = new SqlConnection(strcn13);
            cn13.Open();

            List<Account> ListUsers = new List<Account>();

            String strsql = @"SELECT a.idAccount, a.username FROM tblAccount AS a INNER JOIN tblSelectedCards as cs
                              ON a.idAccount = cs.idAccount WHERE cs.idRoom = '" + room + "' ORDER BY cs.idAccount ASC";

            SqlCommand cmd = new SqlCommand(strsql, cn13);
            var dr8 = cmd.ExecuteReader();

            while (dr8.Read())
            {
                Account value = new Account();
                value.idAccount = Convert.ToInt32(dr8["idAccount"]);
                value.Username = dr8["username"].ToString();
                ListUsers.Add(value);
            }
            dr8.Close();
            cmd.Dispose();
            cn13.Close();
            return ListUsers;
        }

        //Questa funzione permette di leggere l'id e lo username del vincitore del turno
        public static Account ReadUserWin(int room, Cards cardId)
        {
            string strcn14 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn14 = new SqlConnection(strcn14);
            cn14.Open();

            String strsql = @"SELECT a.idAccount, a.username FROM tblAccount AS a INNER JOIN tblSelectedCards as cs
                            ON a.idAccount = cs.idAccount WHERE cs.idRoom = '" + room + @"' 
                            AND idWhiteCards = '" + cardId.idCards + "'";

            SqlCommand cmd = new SqlCommand(strsql, cn14);
            cmd.ExecuteNonQuery();
            var dr9 = cmd.ExecuteReader();
            Account value = new Account();

            while (dr9.Read())
            {
                value.idAccount = Convert.ToInt32(dr9["idAccount"]);
                value.Username = dr9["username"].ToString();
            }
            dr9.Close();
            cmd.Dispose();
            cn14.Close();
            return value;
        }

        //QUesta funzione di scrivere nella tblGame e quindi permette di assegnare il punteggio al vincitore
        public static Winner PointUserWin(int room, Cards cardId)
        {
            string strcn15 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn15 = new SqlConnection(strcn15);
            cn15.Open();

            Account user = ReadUserWin(room, cardId);

            String strsql = "SELECT idAccount, points FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn15);
            Winner value = new Winner();
            var dr10 = cmd.ExecuteReader();
            if (dr10.HasRows)
            {
                dr10.Read();
                value.idAccount = Convert.ToInt32(dr10["idAccount"]);
                value.Point = Convert.ToInt32(dr10["points"]); ;
            }

            dr10.Close();
            cmd.Dispose();
            cn15.Close();
            return value;
        }
        //Questa funzione mi permette di scrivere nella tblGame il punteggio al vincitore
        public static void WritePoint(int room, Cards cardId)
        {
            string strcn16 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn16 = new SqlConnection(strcn16);
            cn16.Open();

            Winner point = PointUserWin(room, cardId);
            String strsql = "UPDATE tblGame SET points = '" + (point.Point + 1) + "' WHERE idAccount = '" + point.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn16);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn16.Close();
        }

        /*Questa funzione permette di leggere tutti gli id delle carte selezionate e i testi e 
        inserirli in una lista*/
        public static List<Cards> ReadTetxtCardsSelect(int room)
        {
            string strcn17 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn17 = new SqlConnection(strcn17);
            cn17.Open();

            List<Cards> ListIdCards = new List<Cards>();

            String strsql = @"SELECT cs.idWhiteCards, wc.textWhite FROM tblSelectedCards as cs INNER JOIN tblWhiteCards as wc 
                                ON cs.idWhiteCards = wc.idWhiteCards WHERE idRoom = '" + room + "' ORDER BY cs.idAccount";
            SqlCommand cmd = new SqlCommand(strsql, cn17);
            var dr11 = cmd.ExecuteReader();

            while (dr11.Read())
            {
                if (dr11.HasRows)
                {
                    //dr.Read();
                    Cards value = new Cards();
                    value.idCards = Convert.ToInt32(dr11["idWhiteCards"]);
                    value.Text = dr11["textWhite"].ToString();
                    ListIdCards.Add(value);
                }
            }
            dr11.Close();
            cmd.Dispose();
            cn17.Close();
            return ListIdCards;
        }

        //Questa funzione permette di eliminare le righe dalla tblSelectedCards 
        public static void DeleteCardSelectDB(int room)
        {
            string strcn18 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn18 = new SqlConnection(strcn18);
            cn18.Open();

            String strsql = @"DELETE FROM tblSelectedCards WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn18);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn18.Close();
        }

        //Questa funzione permette di leggere il punteggio di un utente in una stanza
        public static int ReadPoints(int room, Account user)
        {
            string strcn19 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn19 = new SqlConnection(strcn19);
            cn19.Open();

            String strsql = "SELECT points FROM tblGame WHERE idAccount = '" + user.idAccount + "' and idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn19);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr12 = cmd.ExecuteReader();
            if (dr12.HasRows)
            {
                dr12.Read();
                value = Convert.ToInt32(dr12["points"]);
            }

            dr12.Close();
            cmd.Dispose();
            cn19.Close();
            return value;
        }

        //Questa funzione permette di leggere quanti utenti ci sono nella stanza
        public static int ReadUsersInRoom(int room)
        {
            string strcn20 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn20 = new SqlConnection(strcn20);
            cn20.Open();

            String strsql = "SELECT COUNT(idAccount) as C FROM tblGame WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn20);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr13 = cmd.ExecuteReader();
            if (dr13.HasRows)
            {
                dr13.Read();
                value = Convert.ToInt32(dr13["C"]);
            }

            dr13.Close();
            cmd.Dispose();
            cn20.Close();
            return value;
        }

        //Questa funzione permette di eliminare le righe dalla tblGame
        public static void DeleteRoomDB(int room)
        {
            string strcn21 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn21 = new SqlConnection(strcn21);
            cn21.Open();

            String strsql = @"DELETE FROM tblGame WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn21);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn21.Close();
        }

        //Questa funzione mi permette di scrivere nella tblGame il master
        public static void UpdateMaster(int room, int indexMaster, int user)
        {
            string strcn22 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn22 = new SqlConnection(strcn22);
            cn22.Open();

            String strsql = "UPDATE tblGame SET isMaster = '" + indexMaster + @"'
                             WHERE idAccount = '" + user + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn22);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn22.Close();
        }

        //Questa funzione permette di leggere il master della stanza x
        public static Master ReadMaster(int room, Account user)
        {
            string strcn23 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn23 = new SqlConnection(strcn23);
            cn23.Open();

            String strsql = "SELECT isMaster, idAccount FROM tblGame WHERE idRoom = '" + room + @"' 
                             AND idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn23);
            cmd.ExecuteNonQuery();

            Master value = new Master();
            var dr14 = cmd.ExecuteReader();
            if (dr14.HasRows)
            {
                dr14.Read();
                value.indexMaster = Convert.ToInt32(dr14["isMaster"]);
                value.idAccount = Convert.ToInt32(dr14["idAccount"]);
            }

            dr14.Close();
            cmd.Dispose();
            cn23.Close();
            return value;
        }

        ////Questa funzione permette di leggere se l'utente è già presente in una stanza
        //public static bool CheckUserInARoom(Account user)
        //{
        //    string strcn25 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        //    SqlConnection cn25 = new SqlConnection(strcn25);
        //    cn25.Open();

        //    String strsql = "SELECT idAccount FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
        //    SqlCommand cmd = new SqlCommand(strsql, cn25);
        //    cmd.ExecuteNonQuery();

        //    var dr21 = cmd.ExecuteReader();
        //    dr21.Read();
        //    bool ok = dr21.HasRows;
        //    dr21.Close();
        //    cmd.Dispose();
        //    cn25.Close();
        //    return ok;
        //}

        //Questa funzione mi permette di aggiornare la pwd 
        public static bool ResetPwd(String email, String pwd)
        {
            string strcn24 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn24 = new SqlConnection(strcn24);
            cn24.Open();

            String strsql1 = "Select email FROM tblAccount WHERE email = @email";
            SqlCommand cmd1 = new SqlCommand(strsql1, cn24);

            cmd1.Parameters.AddWithValue("email", email);
            cmd1.ExecuteNonQuery();

            var dr15 = cmd1.ExecuteReader();
            dr15.Read();
            bool ok = dr15.HasRows;
            dr15.Close();
            cmd1.Dispose();

            if (ok == true)
            {
                String pass = Hashing.HashPassword(pwd);

                String strsql = "UPDATE tblAccount SET pwd = @pwd WHERE email = @email";
                SqlCommand cmd = new SqlCommand(strsql, cn24);

                cmd.Parameters.AddWithValue("email", email);
                cmd.Parameters.AddWithValue("pwd", pass);

                cmd.ExecuteNonQuery();
                cmd.Dispose();
                cn24.Close();   
                return true;
            }
            else
            {
                cn24.Close();   
                return false;
            }      
        }

        //Questa funzione mi permette di aggiornare la il numero di partite giocate 
        public static void UpdateMatchesPlayed(Account user)
        {
            string strcn25 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn25 = new SqlConnection(strcn25);
            cn25.Open();

            Account result = new Account();
            result = ReadValuesProfileDB();
            int matchesPlayed = result.MatchesPlayed;

            String strsql = "UPDATE tblAccount SET matchesPlayed = '" + (matchesPlayed + 1) + "' WHERE idAccount= '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn25);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn25.Close();
        }

        //Questa funzione mi permette di aggiornare la il numero di partite vinte 
        public static void UpdateMatchesWon(Account user)
        {
            string strcn26 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn26 = new SqlConnection(strcn26);
            cn26.Open();

            Account result = new Account();
            result = ReadValuesProfileDB();
            int matchesWon = result.MatchesWon;

            String strsql = "UPDATE tblAccount SET matchesWon = '" + (matchesWon + 1) + "' WHERE idAccount= '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn26);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn26.Close();
        }

        //Questa funzione mi permette di aggiornare la il numero di partite perse 
        public static void UpdateMatchesMissed(Account user)
        {
            string strcn27 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn27 = new SqlConnection(strcn27);
            cn27.Open();

            Account result = new Account();
            result = ReadValuesProfileDB();
            int matchesMissed = result.MatchesMissed;

            String strsql = "UPDATE tblAccount SET matchesMissed = '" + (matchesMissed + 1) + "' WHERE idAccount= '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn27);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn27.Close();
        }

        //Questa funzione mi permette di aggiornare il numero di partite pareggiate 
        public static void UpdateMatchesEqualizedd(Account user)
        {
            string strcn28 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn28 = new SqlConnection(strcn28);
            cn28.Open();

            Account result = new Account();
            result = ReadValuesProfileDB();
            int matchesEqualized = result.MatchesEqualized;

            String strsql = "UPDATE tblAccount SET matchesEqualized = '" + (matchesEqualized + 1) + "' WHERE idAccount= '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn28);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn28.Close();
        }

        //Questa funzione permette di trovare il punteggio massimo 
        public static int GetMaxPoint(int room)
        {
            string strcn29 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn29 = new SqlConnection(strcn29);
            cn29.Open();

            String strsql = "SELECT MAX(points) AS maxPoints FROM tblGame WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn29);

            int points = 0;

            var dr16 = cmd.ExecuteReader();
            if (dr16.HasRows)
            {
                dr16.Read();
                points = Convert.ToInt32(dr16["maxPoints"]);
            }
            dr16.Close();
            cmd.Dispose();
            cn29.Close();
            return points;
        }

        //Questa funzione permette di trovare il numero di giocatori con il punteggio più basso rispetto al massimo punteggio 
        public static List<Account> GetUserLose(int room, int maxPoint)
        {
            string strcn30 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn30 = new SqlConnection(strcn30);
            cn30.Open();

            String strsql = "SELECT a.username AS u FROM tblGame as g INNER JOIN tblAccount as a ON g.idAccount = a.idAccount WHERE idRoom = '" + room + "' and points <> '" + maxPoint + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn30);

            List<Account> listUsername = new List<Account>();

            var dr17 = cmd.ExecuteReader();

            while (dr17.Read())
            {
                if (dr17.HasRows)
                {
                    Account value = new Account();
                    value.Username = dr17["u"].ToString();
                    listUsername.Add(value);
                }
            }
            dr17.Close();
            cmd.Dispose();
            cn30.Close();
            return listUsername;
        }

        //Questa funzione permette di trovare quanti giocatori hanno il punteggio massimo
        public static int GetNUserPointsMax(int room)
        {
            string strcn31 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn31 = new SqlConnection(strcn31);
            cn31.Open();

            int point = GetMaxPoint(room);

            String strsql = "SELECT COUNT(idAccount) AS nUserWon FROM tblGame WHERE points = '" + point + "' and idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn31);

            int numberUserWon = 0;
            var dr18 = cmd.ExecuteReader();
            if (dr18.HasRows)
            {
                dr18.Read();
                numberUserWon = Convert.ToInt32(dr18["nUserWon"]);
            }
            dr18.Close();
            cmd.Dispose();
            cn31.Close();
            return numberUserWon;
        }

        //Questa funzione restituisce lo username in base all'idAccount e il punteggio
        public static List<Account> GetUsername(int room, int point)
        {
            string strcn32 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn32 = new SqlConnection(strcn32);
            cn32.Open();

            String strsql = "SELECT a.username AS u FROM tblGame as g INNER JOIN tblAccount as a ON g.idAccount = a.idAccount WHERE points = '" + point + "' and idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn32);

            List<Account> listUsername = new List<Account>();
   
            var dr19 = cmd.ExecuteReader();

            while (dr19.Read())
            {
                if (dr19.HasRows)
                {
                    Account value = new Account();
                    value.Username = dr19["u"].ToString();
                    listUsername.Add(value);
                }
            }
            dr19.Close();
            cmd.Dispose();
            cn32.Close();
            return listUsername;
        }

        //Questa funzione mi permette di controllare se nella tblGame c'è già il giocatore
        public static bool CheckUserInGame(Account user)
        {
            string strcn33 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn33 = new SqlConnection(strcn33);
            cn33.Open();

            String strsql = "SELECT idAccount FROM tblGame WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn33);
            cmd.ExecuteNonQuery();

            var dr20 = cmd.ExecuteReader();
            dr20.Read();
            bool ok = dr20.HasRows;
            dr20.Close();
            cmd.Dispose();
            cn33.Close();
            return ok; 
        }

        //Questa funzione mi permette di aggiornare il numero dei rounds 
        public static void UpdateRounds(int indexRoom)
        {
            string strcn34 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn34 = new SqlConnection(strcn34);
            cn34.Open();

            Round value = ReadRounds(indexRoom);

            String strsql = "UPDATE tblRooms SET numberRound = '" + (value.numberRound + 1) + "' WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn34);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn34.Close();
        }

        //Questa funzione permette di leggere il numero dei rounds 
        public static Round ReadRounds(int indexRoom)
        {
            string strcn35 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn35 = new SqlConnection(strcn35);
            cn35.Open();

            String strsql = "SELECT numberRound, newRound FROM tblRooms WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn35);
            cmd.ExecuteNonQuery();

            Round value = new Round();
            var dr21 = cmd.ExecuteReader();
            if (dr21.HasRows)
            {
                dr21.Read();
                value.numberRound = Convert.ToInt32(dr21["numberRound"]);
                value.newRound = Convert.ToInt32(dr21["newRound"]);    
            }

            dr21.Close();
            cmd.Dispose();

            dr21.Close();
            cmd.Dispose();
            cn35.Close();
            return value;
        }

        //Questa funzione permette di leggere il numero di carte selezionate da un utente
        public static int ReadNCardSelect(int indexRoom, Account user)
        {
            string strcn36 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn36 = new SqlConnection(strcn36);
            cn36.Open();

            String strsql = "SELECT COUNT(idAccount) as c FROM tblSelectedCards WHERE idAccount = '" + user.idAccount + "' and idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn36);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr22 = cmd.ExecuteReader();
            if (dr22.HasRows)
            {
                dr22.Read();
                value = Convert.ToInt32(dr22["c"]);
            }

            dr22.Close();
            cmd.Dispose();
            cn36.Close();
            return value;
        }

        ////Questa funzione mi permette di controllare se nella tblSelectedCards ci sono delle carte già selezionate
        //public static bool CheckCardsSelect(int indexRoom)
        //{
        //    string strcn38 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        //    SqlConnection cn38 = new SqlConnection(strcn38);
        //    cn38.Open();

        //    String strsql = "SELECT * FROM tblSelectedCards WHERE idRoom = '" + indexRoom + "'";
        //    SqlCommand cmd = new SqlCommand(strsql, cn38);
        //    cmd.ExecuteNonQuery();

        //    var dr32 = cmd.ExecuteReader();
        //    dr32.Read();
        //    bool ok = dr32.HasRows;
        //    dr32.Close();
        //    cmd.Dispose();
        //    cn38.Close();
        //    return ok;
        //}

        //Questa funzione mi permette di scrivere il numero dei rounds 
        public static void WriteRounds(int indexRoom)
        {
            string strcn37 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn37 = new SqlConnection(strcn37);
            cn37.Open();

            Round value = ReadRounds(indexRoom);

            String strsql = "INSERT INTO tblRooms(idRoom, numberRound, newRound, timer, indexMaster) VALUES ('" + indexRoom + "', 1, 0, 0, 0)";
            SqlCommand cmd = new SqlCommand(strsql, cn37);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn37.Close();
        }

        //Questa funzione mi permette di aggiornare il newRound
        public static void ResetRounds(int indexRoom)
        {
            string strcn38 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn38 = new SqlConnection(strcn38);
            cn38.Open();

            String strsql = "UPDATE tblRooms SET numberRound = 0, newRound = 0, timer = 0, indexMaster = 0 WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn38);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn38.Close();
        }

        ////Questa funzione permette di eliminare le righe dalla tblRooms
        //public static void DeleteRounds(int room)
        //{
        //    string strcn41 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        //    SqlConnection cn41 = new SqlConnection(strcn41);
        //    cn41.Open();

        //    String strsql = "DELETE FROM tblRooms WHERE idRoom = '" + room + "'";
        //    SqlCommand cmd = new SqlCommand(strsql, cn41);
        //    cmd.ExecuteNonQuery();
        //    cmd.Dispose();
        //    cn41.Close();
        //}

        //Questa funzione mi permette di controllare se nella tblRooms è già presente la stanza con i round
        public static bool CheckRounds(int indexRoom)
        {
            string strcn39 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn39 = new SqlConnection(strcn39);
            cn39.Open();

            String strsql = "SELECT idRoom FROM tblRooms WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn39);
            cmd.ExecuteNonQuery();

            var dr23 = cmd.ExecuteReader();
            dr23.Read();
            bool ok = dr23.HasRows;
            dr23.Close();
            cmd.Dispose();
            cn39.Close();
            return ok;
        }

        //Questa funzione mi permette di controllare se nella tblSelectedCards sono state selezionate il numero giusto di carte
        public static int CheckNCardsSelect(int indexRoom)
        {
            string strcn40 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn40 = new SqlConnection(strcn40);
            cn40.Open();

            String strsql = "SELECT COUNT(idRoom) as c FROM tblSelectedCards WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn40);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr24 = cmd.ExecuteReader();
            if (dr24.HasRows)
            {
                dr24.Read();
                value = Convert.ToInt32(dr24["c"]);
            }

            dr24.Close();
            cmd.Dispose();
            cn40.Close();
            return value;
        }

        //Questa funzione permette di eliminare le carte che un utente ha selezionato dalla tblSelectedCards 
        public static void DeleteCardSelectUser(int room, Account user)
        {
            string strcn41 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn41 = new SqlConnection(strcn41);
            cn41.Open();

            String strsql = "DELETE FROM tblSelectedCards WHERE idRoom = '" + room + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn41);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn41.Close();
        }

        //Questa funzione permette di eliminare un utente dalla tblGame
        public static void DeleteUserInGame(int room, Account user)
        {
            string strcn42 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn42 = new SqlConnection(strcn42);
            cn42.Open();

            String strsql = "DELETE FROM tblGame WHERE idRoom = '" + room + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn42);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn42.Close();
        }

        //Questa funzione mi permette di controllare se nella tblGame esiste l'utente
        public static bool CheckUserInGame(int idRoom, Account user)
        {
            string strcn43 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn43 = new SqlConnection(strcn43);
            cn43.Open();

            String strsql = "SELECT * FROM tblGame WHERE idRoom = '" + idRoom + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn43);
            cmd.ExecuteNonQuery();

            var dr25 = cmd.ExecuteReader();
            dr25.Read();
            bool ok = dr25.HasRows;
            dr25.Close();
            cmd.Dispose();
            cn43.Close();
            return ok;
        }

        //Questa funzione mi permette di controllare se nella tblGame esiste l'utente
        public static bool CheckCardsUser(int room, Account user)
        {
            string strcn44 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn44 = new SqlConnection(strcn44);
            cn44.Open();

            String strsql = "SELECT idRoom, idAccount FROM tblSelectedCards WHERE idRoom = '" + room + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn44);
            cmd.ExecuteNonQuery();

            var dr26 = cmd.ExecuteReader();
            dr26.Read();
            bool ok = dr26.HasRows;
            dr26.Close();
            cmd.Dispose();
            cn44.Close();
            return ok;
        }

        //Questa funzione mi permette di controllare se nel db esiste la room
        public static bool CheckRoom(int room)
        {
            string strcn45 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn45 = new SqlConnection(strcn45);
            cn45.Open();

            String strsql = "SELECT idRoom FROM tblGame WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn45);
            cmd.ExecuteNonQuery();

            var dr27 = cmd.ExecuteReader();
            dr27.Read();
            bool ok = dr27.HasRows;
            dr27.Close();
            cmd.Dispose();
            cn45.Close();
            return ok;
        }

        //Questa funzione mi permette di controllare quanti giocatori ci sono nella tblGame che non sono master
        public static int UsersNotMaster(int room)
        {
            string strcn46 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn46 = new SqlConnection(strcn46);
            cn46.Open();

            String strsql = "SELECT count(idAccount) as c FROM tblGame WHERE idRoom = '" + room + "' and isMaster = 0";
            SqlCommand cmd = new SqlCommand(strsql, cn46);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr28 = cmd.ExecuteReader();
            if (dr28.HasRows)
            {
                dr28.Read();
                value = Convert.ToInt32(dr28["c"]);
            }

            dr28.Close();
            cmd.Dispose();
            cn46.Close();
            return value;
        }

        //Questa funzione mi permette di aggiornare il valore del newRound nella tblRooms
        public static void UpdateNewRound(int indexRoom, int round)
        {
            string strcn47 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn47 = new SqlConnection(strcn47);
            cn47.Open();

            String strsql = "UPDATE tblRooms SET newRound = '" + round + "' WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn47);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn47.Close();
        }

        //Questa funzione mi permette di leggere il count dei secondi per far far vedere i nome degli utenti al master
        public static int ReadTimer(int indexRoom)
        {
            string strcn48 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn48 = new SqlConnection(strcn48);
            cn48.Open();

            String strsql = "SELECT timer FROM tblRooms WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn48);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr29 = cmd.ExecuteReader();
            if (dr29.HasRows)
            {
                dr29.Read();
                value = Convert.ToInt32(dr29["timer"]);
            }

            dr29.Close();
            cmd.Dispose();
            cn48.Close();
            return value;
        }

        //Questa funzione mi permette di aggiornare il count dei secondi per far far vedere i nome degli utenti al master
        public static void UpdateTimer(int indexRoom)
        {
            string strcn49 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn49 = new SqlConnection(strcn49);
            cn49.Open();

            int timer = FunctionsDB.ReadTimer(indexRoom);

            String strsql = "UPDATE tblRooms SET timer = '" + (timer + 1) + "' WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn49);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn49.Close();
        }

        //Questa funzione mi permette di resettare il count dei secondi per far far vedere i nome degli utenti al master
        public static void ResetTimer(int indexRoom)
        {
            string strcn50 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn50 = new SqlConnection(strcn50);
            cn50.Open();

            String strsql = "UPDATE tblRooms SET timer = 0 WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn50);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn50.Close();
        }

        //Questa funzione mi permette di scrivere le carte bianche che un utente possiede
        public static void WriteCardsWhite(int indexRoom, Account user, Cards card)
        {
            string strcn51 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn51 = new SqlConnection(strcn51);
            cn51.Open();

            String strsql = @"INSERT INTO tblWhiteCardsUsed (idRoom, idAccount, idWhiteCards, cardsUsed) 
                              VALUES ('" + indexRoom + "', '" + user.idAccount + "', '" + card.idCards + "', 0)";
            SqlCommand cmd = new SqlCommand(strsql, cn51);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn51.Close();
        }

        //Questa funzione mi permette se una carta bianca è già usata da un'altro utente
        public static bool CheckCardsWhite(int room, Cards card)
        {
            string strcn52 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn52 = new SqlConnection(strcn52);
            cn52.Open();

            String strsql = "SELECT idWhiteCards FROM tblWhiteCardsUsed WHERE idRoom = '" + room + "' and idWhiteCards = '" + card.idCards + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn52);
            cmd.ExecuteNonQuery();

            var dr30 = cmd.ExecuteReader();
            dr30.Read();
            bool ok = dr30.HasRows;
            dr30.Close();
            cmd.Dispose();
            cn52.Close();
            return ok;
        }

        //Questa funzione mi permette di aggiornare lo stato della carta bianca, cioè che è stata usata
        public static void UpdateCardsWhite(int indexRoom, Cards card)
        {
            string strcn53 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn53 = new SqlConnection(strcn53);
            cn53.Open();

            String strsql = "UPDATE tblWhiteCardsUsed SET cardsUsed = 1 WHERE idRoom = '" + indexRoom + "' and idWhiteCards = '" + card.idCards + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn53);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn53.Close();
        }

        //Questa funzione permette di eliminare le carte di un utente dalla tblWhiteCardsUsed
        public static void DeleteCardsWhite(int room, Account user)
        {
            string strcn54 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn54 = new SqlConnection(strcn54);
            cn54.Open();

            String strsql = "DELETE FROM tblWhiteCardsUsed WHERE idRoom = '" + room + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn54);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn54.Close();
        }

        //Questa funzione mi permette di controllare se le carte di un utente sono state eliminate
        public static bool CheckDeleteCardsWhite(int room, Account user)
        {
            string strcn55 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn55 = new SqlConnection(strcn55);
            cn55.Open();

            String strsql = "SELECT idAccount FROM tblWhiteCardsUsed WHERE idRoom = '" + room + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn55);
            cmd.ExecuteNonQuery();

            var dr31 = cmd.ExecuteReader();
            dr31.Read();
            bool ok = dr31.HasRows;
            dr31.Close();
            cmd.Dispose();
            cn55.Close();
            return ok;
        }

        //Questa funzione mi permette di controllare se una carta nera è già stata usata 
        public static bool CheckCardsBlack(int room, Cards card)
        {
            string strcn56 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn56 = new SqlConnection(strcn56);
            cn56.Open();

            String strsql = "SELECT idBlackCards FROM tblBlackCardsUsed WHERE idRoom = '" + room + "' and idBlackCards = '" + card.idCards + "' and cardsUsed = 1";
            SqlCommand cmd = new SqlCommand(strsql, cn56);
            cmd.ExecuteNonQuery();

            var dr32 = cmd.ExecuteReader();
            dr32.Read();
            bool ok = dr32.HasRows;
            dr32.Close();
            cmd.Dispose();
            cn56.Close();
            return ok;
        }

        //Questa funzione mi permette di aggiornare lo stato della carta nera, cioè che è stata usata
        public static void UpdateCardsBlack(int indexRoom, Cards card)
        {
            string strcn57 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn57 = new SqlConnection(strcn57);
            cn57.Open();

            String strsql = "UPDATE tblBlackCardsUsed SET cardsUsed = 1 WHERE idRoom = '" + indexRoom + "' and idBlackCards = '" + card.idCards + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn57);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn57.Close();
        }

        //Questa funzione permette di eliminare le carte nere dalla tblBlackCardsUsed
        public static void DeleteCardsBlack(int room)
        {
            string strcn58 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn58 = new SqlConnection(strcn58);
            cn58.Open();

            String strsql = "DELETE FROM tblBlackCardsUsed WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn58);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn58.Close();
        }

        //Questa funzione mi permette di controllare se le carte nere sono state eliminate dalla tblBlackCardsUsed
        public static bool CheckDeleteCardsBlack(int room)
        {
            string strcn59 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn59 = new SqlConnection(strcn59);
            cn59.Open();

            String strsql = "SELECT idRoom FROM tblBlackCardsUsed WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn59);
            cmd.ExecuteNonQuery();

            var dr33 = cmd.ExecuteReader();
            dr33.Read();
            bool ok = dr33.HasRows;
            dr33.Close();
            cmd.Dispose();
            cn59.Close();
            return ok;
        }

        //Questa funzione mi permette di scrivere le carte nere nella tblBlackCardsUsed
        public static void WriteCardsBlack(int indexRoom, Cards card)
        {
            string strcn60 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn60 = new SqlConnection(strcn60);
            cn60.Open();

            String strsql = @"INSERT INTO tblBlackCardsUsed(idRoom, idBlackCards, cardsUsed) 
                              VALUES ('" + indexRoom + "', '" + card.idCards + "', 0)";
            SqlCommand cmd = new SqlCommand(strsql, cn60);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn60.Close();
        }

        ////Questa funzione mi permette di controllare se il master è stato eliminato dal db
        //public static bool CheckDeleteMaster(int room)
        //{
        //    string strcn61 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        //    SqlConnection cn61 = new SqlConnection(strcn61);
        //    cn61.Open();

        //    String strsql = "SELECT idRoom FROM tblMaster WHERE idRoom = '" + room + "'";
        //    SqlCommand cmd = new SqlCommand(strsql, cn61);
        //    cmd.ExecuteNonQuery();

        //    var dr34 = cmd.ExecuteReader();
        //    dr34.Read();
        //    bool ok = dr34.HasRows;
        //    dr34.Close();
        //    cmd.Dispose();
        //    cn61.Close();
        //    return ok;
        //}

        ////Questa funzione mi permette di scrivere l'indice del master nella tblMaster
        //public static void WriteIndexMaster(int indexRoom)
        //{
        //    string strcn62 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        //    SqlConnection cn62 = new SqlConnection(strcn62);
        //    cn62.Open();

        //    String strsql = "INSERT INTO tblMaster(idRoom, indexMaster) VALUES ('" + indexRoom + "', 0)";
        //    SqlCommand cmd = new SqlCommand(strsql, cn62);
        //    cmd.ExecuteNonQuery();
        //    cmd.Dispose();
        //    cn62.Close();
        //}

        //Questa funzione mi permette di aggiornare l'indice del master nella tblMaster
        public static void UpdateIndexMaster(int indexRoom)
        {
            string strcn63 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn63 = new SqlConnection(strcn63);
            cn63.Open();

            int indexMaster = FunctionsDB.ReadIndexMaster(indexRoom);

            String strsql = "UPDATE tblRooms SET indexMaster = '" + (indexMaster + 1) + "' WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn63);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn63.Close();
        }

        //Questa funzione mi permette di resettare l'indice del master nella tblMaster
        public static void ResetIndexMaster(int indexRoom)
        {
            string strcn64 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn64 = new SqlConnection(strcn64);
            cn64.Open();

            String strsql = "UPDATE tblRooms SET indexMaster = 0 WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn64);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn64.Close();
        }
        //Questa funzione mi permette di leggere il numero dell'indice del master dalla tblMaster
        public static int ReadIndexMaster(int indexRoom)
        {
            string strcn65 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn65 = new SqlConnection(strcn65);
            cn65.Open();

            String strsql = "SELECT indexMaster FROM tblRooms WHERE idRoom = '" + indexRoom + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn65);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr35 = cmd.ExecuteReader();
            if (dr35.HasRows)
            {
                dr35.Read();
                value = Convert.ToInt32(dr35["indexMaster"]);
            }

            dr35.Close();
            cmd.Dispose();
            cn65.Close();
            return value;
        }

        ////Questa funzione permette di eliminare l'indice del master nella tblMaster
        //public static void DeleteMaster(int room)
        //{
        //    string strcn66 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
        //    SqlConnection cn66 = new SqlConnection(strcn66);
        //    cn66.Open();

        //    String strsql = "DELETE FROM tblMaster WHERE idRoom = '" + room + "'";
        //    SqlCommand cmd = new SqlCommand(strsql, cn66);
        //    cmd.ExecuteNonQuery();
        //    cmd.Dispose();
        //    cn66.Close();
        //}

        //Questa funzione mi permette di aggiornare nella tabella l'uscita del giocatore dal gioco
        public static void UpdateUserExit(Account user)
        {
            string strcn66 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn66 = new SqlConnection(strcn66);
            cn66.Open();

            String strsql = "UPDATE tblUserExit SET isExit = '1' WHERE idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn66);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn66.Close();
        }

        //Questa funzione mi permette di leggere il numero di utenti che sono usciti dal gioco
        public static int ReadUserExit()
        {
            string strcn67 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn67 = new SqlConnection(strcn67);
            cn67.Open();

            String strsql = "SELECT COUNT(idAccount) AS a FROM tblUserExit WHERE isExit = 1";
            SqlCommand cmd = new SqlCommand(strsql, cn67);
            cmd.ExecuteNonQuery();

            int value = 0;
            var dr36 = cmd.ExecuteReader();
            if (dr36.HasRows)
            {
                dr36.Read();
                value = Convert.ToInt32(dr36["a"]);
            }

            dr36.Close();
            cmd.Dispose();
            cn67.Close();
            return value;
        }

        //Scrivo nella tabella userExit
        public static void WriteUserExit(Account user, int idRoom)
        {
            string strcn68 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn68 = new SqlConnection(strcn68);
            cn68.Open();

            String strsql = @"INSERT INTO tblUserExit(idAccount, idRoom, isExit) 
                            VALUES ('" + user.idAccount + "', '" + idRoom + "', 0)";
            SqlCommand cmd = new SqlCommand(strsql, cn68);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn68.Close();
        }

        //Questa funzione permette di eliminare le righe dalla tblUserExit 
        public static void DeleteUserExit(int room)
        {
            string strcn69 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn69 = new SqlConnection(strcn69);
            cn69.Open();

            String strsql = @"DELETE FROM tblUserExit WHERE idRoom = '" + room + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn69);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            cn69.Close();
        }

        //Questa funzione mi permette di controllare se nella tblUserExit esiste l'utente
        public static bool CheckUserExit(int room, Account user)
        {
            string strcn70 = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            SqlConnection cn70 = new SqlConnection(strcn70);
            cn70.Open();

            String strsql = "SELECT idRoom, idAccount FROM tblUserExit WHERE idRoom = '" + room + "' and idAccount = '" + user.idAccount + "'";
            SqlCommand cmd = new SqlCommand(strsql, cn70);
            cmd.ExecuteNonQuery();

            var dr37 = cmd.ExecuteReader();
            dr37.Read();
            bool ok = dr37.HasRows;
            dr37.Close();
            cmd.Dispose();
            cn70.Close();
            return ok;
        }
    }
}