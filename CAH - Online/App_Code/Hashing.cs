using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Hashing
    {
        public Hashing()
        {
        }

        //Questa funzione permette di generare un salt che serve per criptare la pwd
        private static String GetRandomSalt()
        {
            return BCrypt.Net.BCrypt.GenerateSalt(12);
        }

        //Questa funzione serve per criptare la pwd
        public static String HashPassword(String password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password, GetRandomSalt());
        }

        //Questa funzione serve per controllare che la pwd immessa sia corretta
        public static bool ValidatePassword(String password, String correctHash)
        {
            return BCrypt.Net.BCrypt.Verify(password, correctHash);
        }
        
    }
}
