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

        public static void OpenConnectionDB()
        {
            string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            cn = new SqlConnection(strcn);
            cn.Open();
        }

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

        public static void WriteDB(String strsql)
        {
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
        }

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
    }
}