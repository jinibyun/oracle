using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;

namespace odp.net
{
    public class ArrayBind:BaseClass
    {
        public void Testing()
        {

            // Setup the Tables for sample
            Setup(constr);

            // Initialize array of data
            int[] myArrayDeptNo = new int[3] { 1, 2, 3 };
            String[] myArrayDeptName = { "Dev", "QA", "Facility" };
            String[] myArrayDeptLoc = { "New York", "Maryland", "Texas" };

            OracleConnection connection = new OracleConnection(constr);
            OracleCommand command = new OracleCommand(
              "insert into dept values (:deptno, :deptname, :loc)", connection);

            // Set the Array Size to 3. This applied to all the parameter in 
            // associated with this command
            command.ArrayBindCount = 3;

            // deptno parameter
            OracleParameter deptNoParam = new OracleParameter("deptno", OracleDbType.Int32);
            deptNoParam.Direction = ParameterDirection.Input;
            deptNoParam.Value = myArrayDeptNo;
            command.Parameters.Add(deptNoParam);

            // deptname parameter
            OracleParameter deptNameParam = new OracleParameter("deptname", OracleDbType.Varchar2);
            deptNameParam.Direction = ParameterDirection.Input;
            deptNameParam.Value = myArrayDeptName;
            command.Parameters.Add(deptNameParam);

            // loc parameter
            OracleParameter deptLocParam = new OracleParameter("loc", OracleDbType.Varchar2);
            deptLocParam.Direction = ParameterDirection.Input;
            deptLocParam.Value = myArrayDeptLoc;
            command.Parameters.Add(deptLocParam);

            try
            {
                connection.Open();
                command.ExecuteNonQuery();
                Console.WriteLine("{0} Rows Inserted", command.ArrayBindCount);
            }
            catch (Exception e)
            {
                Console.WriteLine("Execution Failed:" + e.Message);
            }
            finally
            {
                // connection, command used server side resource, dispose them
                // asap to conserve resource
                connection.Close();
                command.Dispose();
                connection.Dispose();
            }
        }

        private void Setup(string connectStr)
        {
            int[] myArrayDeptNo = new int[3] { 1, 2, 3 };

            OracleConnection conn = new OracleConnection(connectStr);
            OracleCommand cmd = new OracleCommand("delete dept where deptno = :1", conn);

            // Bind with an array of 3 items
            cmd.ArrayBindCount = 3;

            OracleParameter param1 = new OracleParameter();
            param1.OracleDbType = OracleDbType.Int32;
            param1.Value = myArrayDeptNo;

            cmd.Parameters.Add(param1);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Setup Failed:{0}", e.Message);
            }
            finally
            {
                conn.Close();
                cmd.Dispose();
            }
        }
    }
}
