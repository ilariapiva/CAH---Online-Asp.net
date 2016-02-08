using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Account
    {
        private String _email, _username;
        private int _idAccount, _matchesPlayed, _matchesWon, _matchesMissed;

        public Account()
        {
            _idAccount = 0;
            _email = "";
            _username = "";
            _matchesPlayed = 0; 
            _matchesWon = 0;
            _matchesMissed = 0;
        }
       
        public int idAccount
        {
            get { return _idAccount; }
            set { _idAccount = value; }
        }

        public String Email
        {
            get { return _email; }
            set { _email = value; }
        }

        public String Username
        {
            get { return _username; }
            set { _username = value; }
        }

        public int MatchesPlayed
        {
            get { return _matchesPlayed; }
            set { _matchesPlayed = value; }
        }

        public int MatchesWon
        {
            get { return _matchesWon; }
            set { _matchesWon = value; }
        }

        public int MatchesMissed
        {
            get { return _matchesMissed; }
            set { _matchesMissed = value; }
        }
    }
}