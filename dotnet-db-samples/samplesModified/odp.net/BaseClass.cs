using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;

namespace odp.net
{
    public class BaseClass
    {
        protected const string constr = "User Id=scott; Password=tiger; Data Source=JINIDEV;";
        protected const string ProviderName = "Oracle.ManagedDataAccess.Client";
        protected DbProviderFactory factory;

        public BaseClass()
        {
            factory = DbProviderFactories.GetFactory(ProviderName);
        }

        protected OracleConnection Connect(string connectStr)
        {
            OracleConnection con = new OracleConnection(connectStr);
            try
            {
                con.Open();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            return con;
        }
    }
}
