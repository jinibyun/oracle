﻿using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace odp.net
{
    public class OdpNet: BaseClass
    {        

        // Data Source Enumerator
        // Go to app.config
        public void DataSourceEnumerator()
        {
            if (factory.CanCreateDataSourceEnumerator)
            {
                DbDataSourceEnumerator dsenum = factory.CreateDataSourceEnumerator();
                DataTable dt = dsenum.GetDataSources();

                // Print the first column/row entry in the DataTable
                Console.WriteLine(dt.Columns[0] + " : " + dt.Rows[0][0]);
                Console.WriteLine(dt.Columns[1] + " : " + dt.Rows[0][1]);
                Console.WriteLine(dt.Columns[2] + " : " + dt.Rows[0][2]);
                Console.WriteLine(dt.Columns[3] + " : " + dt.Rows[0][3]);
                Console.WriteLine(dt.Columns[4] + " : " + dt.Rows[0][4]);
            }
            else
                Console.Write("Data source enumeration is not supported by provider");
        }

        // Get Schema
        public void GetSchema()
        {                       
            using (DbConnection conn = factory.CreateConnection())
            {
                try
                {
                    conn.ConnectionString = constr;
                    conn.Open();

                    //Get all the schema collections and write to an XML file. 
                    //The XML file name is Oracle.ManagedDataAccess.Client_Schema.xml
                    DataTable dtSchema = conn.GetSchema();
                    dtSchema.WriteXml(ProviderName + "_Schema.xml");
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.WriteLine(ex.StackTrace);
                }
            }
        }

        // Data Reader
        public void DataReader()
        {
            using (DbConnection conn = factory.CreateConnection())
            {
                conn.ConnectionString = constr;
                try
                {
                    conn.Open();
                    OracleCommand cmd = (OracleCommand)factory.CreateCommand();
                    cmd.Connection = (OracleConnection)conn;

                    //to gain access to ROWIDs of the table
                    cmd.AddRowid = true;
                    cmd.CommandText = "select empno, ename from emp;";

                    OracleDataReader reader = cmd.ExecuteReader();

                    int visFC = reader.VisibleFieldCount; //Results in 2
                    int hidFC = reader.HiddenFieldCount;  // Results in 1

                    Console.WriteLine("Visible field count: " + visFC);
                    Console.WriteLine("Hidden field count: " + hidFC);

                    reader.Dispose();
                    cmd.Dispose();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.WriteLine(ex.StackTrace);
                }
            }
        }

        public void ClientFactory()
        {
            using (DbConnection conn = factory.CreateConnection())
            {
                try
                {
                    conn.ConnectionString = constr;
                    conn.Open();

                    DbCommand cmd = factory.CreateCommand();
                    cmd.Connection = conn;
                    cmd.CommandText = "select * from emp";

                    // OracleDataRader or DbDataReader
                    DbDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                        Console.WriteLine(reader["EMPNO"] + " : " + reader["ENAME"]);

                    reader.Close();                    
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.WriteLine(ex.StackTrace);
                }
            }
        }
        
        
    }
}
