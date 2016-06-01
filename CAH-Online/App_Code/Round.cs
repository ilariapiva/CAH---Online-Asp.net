using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Round
    {
        private int _newRound, _numberRound;

        public Round()
        {
            _newRound = 0;
            _numberRound = 0;
        }

        public int newRound
        {
            get { return _newRound; }
            set { _newRound = value; }
        }

        public int numberRound
        {
            get { return _numberRound; }
            set { _numberRound = value; }
        }
    }
}
