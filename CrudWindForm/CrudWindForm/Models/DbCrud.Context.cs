﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CrudWindForm.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using CrudWindForm.Models;
   
    
 
    
    public partial class CrudEntities3 : DbContext
    {
        public CrudEntities3()
            : base("name=CrudEntities3")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<accesos> accesos { get; set; }
        public virtual DbSet<crudtable> crudtable { get; set; }
        public virtual DbSet<departamentos> departamentos { get; set; }
        public virtual DbSet<login> login { get; set; }
        public virtual DbSet<permiso> permiso { get; set; }
        public virtual DbSet<personas> personas { get; set; }
        public virtual DbSet<roles> roles { get; set; }
        public virtual DbSet<table> table { get; set; }
        public virtual DbSet<tipovisita> tipovisita { get; set; }
        public virtual DbSet<UserM> UserM { get; set; }
        public virtual DbSet<usuarios> usuarios { get; set; }
        public virtual DbSet<visitas> visitas { get; set; }
    }
}
