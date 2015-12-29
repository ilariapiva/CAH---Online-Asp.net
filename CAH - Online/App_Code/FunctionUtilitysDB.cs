using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;


namespace CAHOnline
{
    public static class FunctionUtilitysDB
    {
        static SqlConnection cn;
        static SqlCommand cmd;

        public static bool Verifica(String strsql)
        {
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
            var dr = cmd.ExecuteReader();
            dr.Read();
            bool ok = dr.HasRows;
            dr.Close();
            cn.Dispose();
            cmd.Dispose();
            return ok;
        }

        public static void ScriviDB(String strsql)
        {
            cmd = new SqlCommand(strsql, cn);
            cmd.ExecuteNonQuery();
        }

        public static List<string> LeggiValoriProfiloDB(String strsql)
        {
            String username = null;
            String partiteGiocate = null;
            String partiteVinte = null;
            String partitePerse = null;

            List<string> valori = new List<string>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while(dr.Read())
            {
                username += dr["username"];
                valori.Add(username);
                partiteGiocate += dr["giocate"];
                valori.Add(partiteGiocate);
                partiteVinte += dr["perse"];
                valori.Add(partiteVinte);
                partitePerse += dr["vinte"];
                valori.Add(partitePerse);
            }

            dr.Close();
            cn.Dispose();
            cmd.Dispose();
            
            return valori;
        }

        public static List<string> LeggiUsernameDB(String strsql)
        {
            String username = null;
            
            List<string> valori = new List<string>();

            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                username += dr["username"];
                valori.Add(username);
            }

            dr.Close();

            return valori;
        }

        public static void ApriConnessioneDB()
        {
            string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            cn = new SqlConnection(strcn);
            cn.Open();
        }
    }
}