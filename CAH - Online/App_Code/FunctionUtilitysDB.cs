using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Descrizione di riepilogo per FunctionUtilitysDB
/// </summary>

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
            return ok;
        }

        public static void Connessione()
        {
            string strcn = "Data Source= .\\;Trusted_Connection=Yes;DATABASE=CAHOnline";
            cn = new SqlConnection(strcn);
            cn.Open();
        }
    }
}