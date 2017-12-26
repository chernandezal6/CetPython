using System;
using FluentMigrator.VersionTableInfo;

namespace DatabaseMigrations
{
    [VersionTableMetaData]
    public class VersionInfo : DefaultVersionTableMetaData
    {

        public override  string SchemaName
        {
            get { return "SUIRPLUS"; }
        }
             
    }
}
