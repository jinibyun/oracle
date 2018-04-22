using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace odp.net
{
    public class RefCursor:BaseClass
    {
        //Demonstrates how a REF Cursor is obtained as an OracleDataReader.
        public void refCursor()
        {
            // Connect
            OracleConnection con = Connect(constr);

            // Setup table and / or package
            DynamicDBObject.Setup(con);

            // Set the command
            OracleCommand cmd = new OracleCommand("testPackage.Get1CurOut", con);
            cmd.CommandType = CommandType.StoredProcedure;

            // Bind 
            OracleParameter oparam = cmd.Parameters.Add("refcursor", OracleDbType.RefCursor);
            oparam.Direction = ParameterDirection.Output;

            // Execute command
            OracleDataReader reader;
            try
            {
                reader = cmd.ExecuteReader();

                // show the first row
                reader.Read();

                // Print out SCOTT.EMP EMPNO column
                Console.WriteLine("EMPNO: {0}", reader.GetDecimal(0));

                // Print out SCOTT.EMP ENAME column
                Console.WriteLine("ENAME: {0}", reader.GetString(1));
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }

        //Demonstrates how a REF Cursor is obtained as an OracleDataReader through the use of an OracleRefCursor object.
        public void refCursor2()
        {
            // Connect
            OracleConnection con = Connect(constr);

            // Setup table and / or package
            DynamicDBObject.Setup2(con);

            // Set the command
            OracleCommand cmd = new OracleCommand(
                "begin open :1 for select * from multimedia_tab where thekey = 1; end;",
                con);

            cmd.CommandType = CommandType.Text;

            // Bind 
            OracleParameter oparam = cmd.Parameters.Add("refcur", OracleDbType.RefCursor);
            oparam.Direction = ParameterDirection.Output;

            try
            {
                // Execute command
                cmd.ExecuteNonQuery();

                // Obtain the OracleDataReader from the REF Cursor parameter
                // oparam.Value returns an OracleRefCursor object.
                // GetDataReader is a method of OracleRefCursor that returns an OracleDataReader object.
                OracleDataReader reader = (OracleDataReader)((OracleRefCursor)(oparam.Value)).GetDataReader();

                // show the first row
                reader.Read();

                // Print out SCOTT.MULTIMEDIA_TAB THEKEY column
                Console.WriteLine("THEKEY: {0}", reader.GetDecimal(0));

                // Print out SCOTT.MULTIMEDIA_TAB STORY column
                Console.WriteLine("STORY : {0}", reader.GetString(1));
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }

        // Demonstrates how multiple Ref Cursors can be accessed by a single OracleDataReader.
        public void refCursor3()
        {
            // Connect            
            OracleConnection con = Connect(constr);

            // Setup
            DynamicDBObject.Setup3(con);

            // Set the command
            OracleCommand cmd = new OracleCommand("testPackage.Get3Cur", con);
            cmd.CommandType = CommandType.StoredProcedure;

            // Bind 
            // select * from multimedia_tab
            OracleParameter p1 = cmd.Parameters.Add("refcursor1", OracleDbType.RefCursor);
            p1.Direction = ParameterDirection.ReturnValue;

            // select * from emp
            OracleParameter p2 = cmd.Parameters.Add("refcursor2", OracleDbType.RefCursor);
            p2.Direction = ParameterDirection.Output;

            // select * from dept
            OracleParameter p3 = cmd.Parameters.Add("refcursor3", OracleDbType.RefCursor);
            p3.Direction = ParameterDirection.Output;

            // Execute command
            OracleDataReader reader;
            try
            {
                reader = cmd.ExecuteReader();

                // Print out the field count of each REF Cursor
                // for "select * from SCOTT.MULTIMEDIA_TAB",
                // "select * from SCOTT.EMP", and "select * from DEPT";
                do
                {
                    Console.WriteLine("Field count: " + reader.FieldCount);
                } while (reader.NextResult());
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }
        // Demonstrates how a DataSet can be populated from a Ref Cursor. 
        // The sample also demonstrates how a Ref Cursor can be updated
        public void refCursor4()
        {
            // Connect
            OracleConnection con = Connect(constr);

            // Setup
            DynamicDBObject.Setup4(con);

            // Set the command
            OracleCommand cmd = new OracleCommand("TESTPACKAGE.Ret1Cur", con);
            cmd.CommandType = CommandType.StoredProcedure;

            // Bind
            // TEST.Ret1Cur is a function so ParameterDirection is ReturnValue.
            OracleParameter param = cmd.Parameters.Add("refcursor",
                                                        OracleDbType.RefCursor);
            param.Direction = ParameterDirection.ReturnValue;

            // Create an OracleDataAdapter
            OracleDataAdapter da = new OracleDataAdapter(cmd);

            try
            {
                // 1. Demostrate populating a DataSet with RefCursor
                // Populate a DataSet
                DataSet ds = new DataSet();
                da.FillSchema(ds, SchemaType.Source, "myRefCursor");
                da.Fill(ds, "myRefCursor");

                // Obtain the row which we want to modify
                DataRow[] rowsWanted = ds.Tables["myRefCursor"].Select("THEKEY = 1");

                // 2. Demostrate how to update with RefCursor
                // Update the "story" column
                rowsWanted[0]["story"] = "New story";

                // Setup the update command on the DataAdapter
                OracleCommand updcmd = new OracleCommand("TESTPACKAGE.UpdateREFCur", con);
                updcmd.CommandType = CommandType.StoredProcedure;

                OracleParameter param1 = updcmd.Parameters.Add("myStory",
                  OracleDbType.Varchar2, 32);
                param1.SourceVersion = DataRowVersion.Current;
                param1.SourceColumn = "STORY";
                OracleParameter param2 = updcmd.Parameters.Add("myClipId",
                  OracleDbType.Decimal);
                param2.SourceColumn = "THEKEY";
                param2.SourceVersion = DataRowVersion.Original;

                da.UpdateCommand = updcmd;

                // Update
                da.Update(ds, "myRefCursor");
                Console.WriteLine("Data has been updated.");
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }

        // Demonstrates how a DataSet can be populated from an OracleRefCursor object.
        public void refCursor5()
        {
            // Connect

            OracleConnection con = Connect(constr);

            // Setup
            DynamicDBObject.Setup5(con);

            // Set the command
            OracleCommand cmd = new OracleCommand("TESTPACKAGE.Get1Cur", con);
            cmd.CommandType = CommandType.StoredProcedure;

            // Bind 
            cmd.Parameters.Add("refcursor1", OracleDbType.RefCursor);
            cmd.Parameters[0].Direction = ParameterDirection.ReturnValue;

            try
            {
                // Execute command; Have the parameters populated
                cmd.ExecuteNonQuery();

                // Create the OracleDataAdapter
                OracleDataAdapter da = new OracleDataAdapter(cmd);

                // Populate a DataSet with refcursor1.
                DataSet ds = new DataSet();
                da.Fill(ds, "refcursor1", (OracleRefCursor)(cmd.Parameters["refcursor1"].Value));

                // Print out the field count the REF Cursor
                Console.WriteLine("Field count: " + ds.Tables["refcursor1"].Columns.Count);
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }

        // Demonstrates how to populate a DataSet with multiple Ref Cursors selectively.
        public void refCursor6()
        {
            OracleConnection con = Connect(constr);

            // Setup
            DynamicDBObject.Setup6(con);

            // Get 3 RefCursors
            OracleCommand cmd = new OracleCommand("testPackage.Get3Cur", con);
            cmd.CommandType = CommandType.StoredProcedure;

            OracleRefCursor[] refCursors = Get3RefCursors(cmd);

            try
            {
                // Create 2 DataTable in a DataSet
                DataSet ds = new DataSet();
                ds.Tables.Add(new DataTable("refcur0"));
                ds.Tables.Add(new DataTable("refcur2"));

                // Use Adapter.Fill to populate the DataTable using
                // only two of the three OracleRefCursor objects
                OracleDataAdapter adpt = new OracleDataAdapter();
                adpt.Fill(ds.Tables["refcur0"], refCursors[0]);
                adpt.Fill(ds.Tables["refcur2"], refCursors[2]);

                // Display the Row count of each DataTable
                Console.WriteLine("Row Count:{0}", ds.Tables["refcur0"].Rows.Count);
                Console.WriteLine("Row Count:{0}", ds.Tables["refcur2"].Rows.Count);
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }

        private static OracleRefCursor[] Get3RefCursors(OracleCommand cmd)
        {
            // 1. Get 3 OracleParameters as REF CURSORs
            // Set the command


            // Bind 
            // select * from multimedia_tab
            OracleParameter p1 = cmd.Parameters.Add("refcursor1",
                OracleDbType.RefCursor);
            p1.Direction = ParameterDirection.ReturnValue;

            // select * from emp
            OracleParameter p2 = cmd.Parameters.Add("refcursor2",
                OracleDbType.RefCursor);
            p2.Direction = ParameterDirection.Output;

            // select * from dept
            OracleParameter p3 = cmd.Parameters.Add("refcursor3",
                OracleDbType.RefCursor);
            p3.Direction = ParameterDirection.Output;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            OracleRefCursor[] refCursors = new OracleRefCursor[3];
            refCursors[0] = (OracleRefCursor)p1.Value;
            refCursors[1] = (OracleRefCursor)p2.Value;
            refCursors[2] = (OracleRefCursor)p3.Value;

            return refCursors;
        }

        // Demonstrates how to selectively obtain OracleDataReader objects from Ref Cursors
        public void refCursor7()
        {
            OracleConnection con = Connect(constr);

            // Setup
            DynamicDBObject.Setup7(con);

            // Get 3 RefCursors
            OracleCommand cmd = new OracleCommand("TESTPACKAGE.Get3Cur", con);
            cmd.CommandType = CommandType.StoredProcedure;

            OracleRefCursor[] refCursors = Get3RefCursors(cmd);

            try
            {
                // Obtain an OracleDataReader for the RefCursors except
                // for the first one.
                for (int i = 1; i < refCursors.Length; i++) // skip 0th REF Cursor
                {
                    int cnt = 0;
                    OracleDataReader reader = refCursors[i].GetDataReader();

                    while (reader.Read())
                        cnt++;

                    // Display the Row count of each Reader
                    Console.WriteLine("Row Count:{0}", cnt);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
            finally
            {
                // Dispose OracleCommand object
                cmd.Dispose();

                // Close and Dispose OracleConnection object
                con.Close();
                con.Dispose();
            }
        }
    }
}
