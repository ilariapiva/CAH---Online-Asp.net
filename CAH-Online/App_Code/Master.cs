using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CAHOnline
{
    public class Master
    {
        private int _idAccount, _indexMaster;

        public Master()
        {
            _idAccount = 0;
            _indexMaster = 0;
        }

        public int idAccount
        {
            get { return _idAccount; }
            set { _idAccount = value; }
        }
        public int indexMaster
        {
            get { return _indexMaster; }
            set { _indexMaster = value; }
        }
    }
}