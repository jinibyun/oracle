using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace odp.net
{
    class Program
    {
        static void Main(string[] args)
        {
            var odpNet = new OdpNet();

            odpNet.DataSourceEnumerator();
            // odpNet.GetSchema();
            // odpNet.DataReader();
        }
    }
}
