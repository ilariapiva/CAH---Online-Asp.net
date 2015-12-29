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
        static String strsql;

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

        /*public static string LeggiDB(String strsql, String username, String partiteGiocate, String partiteVinte, String partitePerse)
        {
            cmd = new SqlCommand(strsql, cn);
            var dr = cmd.ExecuteReader();
            while(dr.Read())
            {
                username += dr["username"];
                partiteGiocate += dr["giocate"];
                partiteVinte += dr["perse"];
                partitePerse += dr["vinte"];
            }
            dr.Close();
            cn.Dispose();
            cmd.Dispose();
        }*/

        public static void ApriConnessioneDB()
        {
            string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            cn = new SqlConnection(strcn);
            cn.Open();
        }
    }
}