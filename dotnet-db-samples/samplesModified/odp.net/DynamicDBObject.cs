using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace odp.net
{
    public static class DynamicDBObject
    {
        public static void Setup(OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Warning: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Header
            blr = new StringBuilder();
            blr.Append("CREATE OR REPLACE PACKAGE testPackage is ");
            blr.Append("TYPE refcursor is ref cursor;");
            blr.Append("FUNCTION Ret1Cur return refCursor;");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor);");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor,");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor;");

            blr.Append("FUNCTION Get1Cur return refCursor;");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR,");
            blr.Append("clipid in NUMBER);");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor);");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,myStory out VARCHAR2);");
            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Body
            blr = new StringBuilder();

            blr.Append("create or replace package body testPackage is ");

            blr.Append("FUNCTION Ret1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Ret1Cur; ");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("OPEN p_cursor1 for select * from emp; ");
            blr.Append("END Get1CurOut; ");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor, ");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("open p_cursor1 for select * from emp; ");
            blr.Append("open p_cursor2 for select * from dept; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get3Cur; ");

            blr.Append("FUNCTION Get1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get1Cur; ");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR, ");
            blr.Append("clipid in NUMBER) is ");
            blr.Append("BEGIN ");
            blr.Append("Update multimedia_tab set story = new_story where thekey = clipid; ");
            blr.Append("END UpdateRefCur; ");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for ");
            blr.Append("Select story from multimedia_tab where thekey = 1; ");
            blr.Append("END GetStoryForClip1; ");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,");
            blr.Append("myStory out VARCHAR2) is ");
            blr.Append("BEGIN ");
            blr.Append("FETCH p_cursor into myStory; ");
            blr.Append("END GetRefCurData; ");

            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }

        public static void Setup2(OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch
            {
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }

        public static void Setup3(OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch
            {
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Header
            blr = new StringBuilder();
            blr.Append("CREATE OR REPLACE PACKAGE testPackage is ");
            blr.Append("TYPE refcursor is ref cursor;");
            blr.Append("FUNCTION Ret1Cur return refCursor;");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor);");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor,");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor;");

            blr.Append("FUNCTION Get1Cur return refCursor;");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR,");
            blr.Append("clipid in NUMBER);");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor);");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,myStory out VARCHAR2);");
            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Body
            blr = new StringBuilder();

            blr.Append("create or replace package body testPackage is ");

            blr.Append("FUNCTION Ret1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Ret1Cur; ");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("OPEN p_cursor1 for select * from emp; ");
            blr.Append("END Get1CurOut; ");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor, ");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("open p_cursor1 for select * from emp; ");
            blr.Append("open p_cursor2 for select * from dept; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get3Cur; ");

            blr.Append("FUNCTION Get1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get1Cur; ");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR, ");
            blr.Append("clipid in NUMBER) is ");
            blr.Append("BEGIN ");
            blr.Append("Update multimedia_tab set story = new_story where thekey = clipid; ");
            blr.Append("END UpdateRefCur; ");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for ");
            blr.Append("Select story from multimedia_tab where thekey = 1; ");
            blr.Append("END GetStoryForClip1; ");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,");
            blr.Append("myStory out VARCHAR2) is ");
            blr.Append("BEGIN ");
            blr.Append("FETCH p_cursor into myStory; ");
            blr.Append("END GetRefCurData; ");

            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }

        public static void Setup4(OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch
            {
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Header
            blr = new StringBuilder();
            blr.Append("CREATE OR REPLACE PACKAGE testPackage is ");
            blr.Append("TYPE refcursor is ref cursor;");
            blr.Append("FUNCTION Ret1Cur return refCursor;");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor);");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor,");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor;");

            blr.Append("FUNCTION Get1Cur return refCursor;");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR,");
            blr.Append("clipid in NUMBER);");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor);");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,myStory out VARCHAR2);");
            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Body
            blr = new StringBuilder();

            blr.Append("create or replace package body testPackage is ");

            blr.Append("FUNCTION Ret1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Ret1Cur; ");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("OPEN p_cursor1 for select * from emp; ");
            blr.Append("END Get1CurOut; ");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor, ");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("open p_cursor1 for select * from emp; ");
            blr.Append("open p_cursor2 for select * from dept; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get3Cur; ");

            blr.Append("FUNCTION Get1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get1Cur; ");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR, ");
            blr.Append("clipid in NUMBER) is ");
            blr.Append("BEGIN ");
            blr.Append("Update multimedia_tab set story = new_story where thekey = clipid; ");
            blr.Append("END UpdateRefCur; ");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for ");
            blr.Append("Select story from multimedia_tab where thekey = 1; ");
            blr.Append("END GetStoryForClip1; ");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,");
            blr.Append("myStory out VARCHAR2) is ");
            blr.Append("BEGIN ");
            blr.Append("FETCH p_cursor into myStory; ");
            blr.Append("END GetRefCurData; ");

            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }

        public static void Setup5(OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch
            {
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Header
            blr = new StringBuilder();
            blr.Append("CREATE OR REPLACE PACKAGE testPackage is ");
            blr.Append("TYPE refcursor is ref cursor;");
            blr.Append("FUNCTION Ret1Cur return refCursor;");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor);");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor,");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor;");

            blr.Append("FUNCTION Get1Cur return refCursor;");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR,");
            blr.Append("clipid in NUMBER);");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor);");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,myStory out VARCHAR2);");
            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Body
            blr = new StringBuilder();

            blr.Append("create or replace package body testPackage is ");

            blr.Append("FUNCTION Ret1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Ret1Cur; ");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("OPEN p_cursor1 for select * from emp; ");
            blr.Append("END Get1CurOut; ");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor, ");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("open p_cursor1 for select * from emp; ");
            blr.Append("open p_cursor2 for select * from dept; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get3Cur; ");

            blr.Append("FUNCTION Get1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get1Cur; ");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR, ");
            blr.Append("clipid in NUMBER) is ");
            blr.Append("BEGIN ");
            blr.Append("Update multimedia_tab set story = new_story where thekey = clipid; ");
            blr.Append("END UpdateRefCur; ");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for ");
            blr.Append("Select story from multimedia_tab where thekey = 1; ");
            blr.Append("END GetStoryForClip1; ");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,");
            blr.Append("myStory out VARCHAR2) is ");
            blr.Append("BEGIN ");
            blr.Append("FETCH p_cursor into myStory; ");
            blr.Append("END GetRefCurData; ");

            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }

        public static void Setup6 (OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch
            {
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Header
            blr = new StringBuilder();
            blr.Append("CREATE OR REPLACE PACKAGE testPackage is ");
            blr.Append("TYPE refcursor is ref cursor;");
            blr.Append("FUNCTION Ret1Cur return refCursor;");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor);");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor,");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor;");

            blr.Append("FUNCTION Get1Cur return refCursor;");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR,");
            blr.Append("clipid in NUMBER);");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor);");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,myStory out VARCHAR2);");
            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Body
            blr = new StringBuilder();

            blr.Append("create or replace package body testPackage is ");

            blr.Append("FUNCTION Ret1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Ret1Cur; ");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("OPEN p_cursor1 for select * from emp; ");
            blr.Append("END Get1CurOut; ");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor, ");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("open p_cursor1 for select * from emp; ");
            blr.Append("open p_cursor2 for select * from dept; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get3Cur; ");

            blr.Append("FUNCTION Get1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get1Cur; ");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR, ");
            blr.Append("clipid in NUMBER) is ");
            blr.Append("BEGIN ");
            blr.Append("Update multimedia_tab set story = new_story where thekey = clipid; ");
            blr.Append("END UpdateRefCur; ");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for ");
            blr.Append("Select story from multimedia_tab where thekey = 1; ");
            blr.Append("END GetStoryForClip1; ");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,");
            blr.Append("myStory out VARCHAR2) is ");
            blr.Append("BEGIN ");
            blr.Append("FETCH p_cursor into myStory; ");
            blr.Append("END GetRefCurData; ");

            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }

        public static void Setup7(OracleConnection con)
        {
            StringBuilder blr;
            OracleCommand cmd = new OracleCommand("", con);

            // Create multimedia table
            blr = new StringBuilder();
            blr.Append("DROP TABLE multimedia_tab");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch
            {
            }

            blr = new StringBuilder();
            blr.Append("CREATE TABLE multimedia_tab(thekey NUMBER(4) PRIMARY KEY,");
            blr.Append("story CLOB, sound BLOB)");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            blr = new StringBuilder();
            blr.Append("INSERT INTO multimedia_tab values(");
            blr.Append("1,");
            blr.Append("'This is a long story. Once upon a time ...',");
            blr.Append("'656667686970717273747576777879808182838485')");
            cmd.CommandText = blr.ToString();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Header
            blr = new StringBuilder();
            blr.Append("CREATE OR REPLACE PACKAGE testPackage is ");
            blr.Append("TYPE refcursor is ref cursor;");
            blr.Append("FUNCTION Ret1Cur return refCursor;");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor);");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor,");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor;");

            blr.Append("FUNCTION Get1Cur return refCursor;");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR,");
            blr.Append("clipid in NUMBER);");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor);");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,myStory out VARCHAR2);");
            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }

            // Create Package Body
            blr = new StringBuilder();

            blr.Append("create or replace package body testPackage is ");

            blr.Append("FUNCTION Ret1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Ret1Cur; ");

            blr.Append("PROCEDURE Get1CurOut(p_cursor1 out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("OPEN p_cursor1 for select * from emp; ");
            blr.Append("END Get1CurOut; ");

            blr.Append("FUNCTION Get3Cur (p_cursor1 out refCursor, ");
            blr.Append("p_cursor2 out refCursor)");
            blr.Append("return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("open p_cursor1 for select * from emp; ");
            blr.Append("open p_cursor2 for select * from dept; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get3Cur; ");

            blr.Append("FUNCTION Get1Cur return refCursor is ");
            blr.Append("p_cursor refCursor; ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for select * from multimedia_tab; ");
            blr.Append("return (p_cursor); ");
            blr.Append("END Get1Cur; ");

            blr.Append("PROCEDURE UpdateRefCur(new_story in VARCHAR, ");
            blr.Append("clipid in NUMBER) is ");
            blr.Append("BEGIN ");
            blr.Append("Update multimedia_tab set story = new_story where thekey = clipid; ");
            blr.Append("END UpdateRefCur; ");

            blr.Append("PROCEDURE GetStoryForClip1(p_cursor out refCursor) is ");
            blr.Append("BEGIN ");
            blr.Append("open p_cursor for ");
            blr.Append("Select story from multimedia_tab where thekey = 1; ");
            blr.Append("END GetStoryForClip1; ");

            blr.Append("PROCEDURE GetRefCurData (p_cursor out refCursor,");
            blr.Append("myStory out VARCHAR2) is ");
            blr.Append("BEGIN ");
            blr.Append("FETCH p_cursor into myStory; ");
            blr.Append("END GetRefCurData; ");

            blr.Append("end testPackage;");

            cmd.CommandText = blr.ToString();

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: {0}", e.Message);
            }
        }
    }
}
