using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Winner
    {
        private int _idAccount, _point;

        public Winner()
        {
            _idAccount = 0;
            _point = 0;
        }

        public int idAccount
        {
            get { return _idAccount; }
            set { _idAccount = value; }
        }

        public int Point
        {
            get { return _point; }
            set { _point = value; }
        }
    }
}
