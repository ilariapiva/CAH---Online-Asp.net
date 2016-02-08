using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Cards
    {
        private String _text;
        private int _idCard;

        public Cards()
        {
            _text = "";
            _idCard = 0;
        }

        public String Text
        {
            get { return _text; }
            set { _text = value; }
        }

        public int idCards
        {
            get { return _idCard; }
            set { _idCard = value; }
        }
    }
}
