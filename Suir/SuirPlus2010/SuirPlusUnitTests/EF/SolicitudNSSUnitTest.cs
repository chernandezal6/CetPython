using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;
using System.Data;

namespace SuirPlusUnitTests.EF
{
     public class SolicitudNSSUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdSolicitudNSS()
        {            
            SolicitudNSS solicitudNSS = new SolicitudNSS();
            SolicitudNSSRepository _RepSolicitudNSS = new SolicitudNSSRepository();

            solicitudNSS = _RepSolicitudNSS.GetById(DefaultValues.IdSolicitudNSS);

            NUnit.Framework.Assert.True(true);
        }
        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {
            //TipoSolicitudNSSRepository _RepTipoSolicitud = new TipoSolicitudNSSRepository();
            //UsuarioRepository _RepUsuario = new UsuarioRepository(_RepTipoSolicitud.db);
            
            //TipoSolicitudNSS tipoSolicitud = _RepTipoSolicitud.GetByIdTipoSolNSS(DefaultValues.IdTipoSolicitudNSS);
            //Usuario usuario = _RepUsuario.GetByUsername(DefaultValues.IdUsuario);

            //SolicitudNSS solicitudNSS = new SolicitudNSS { IdSolicitud= DefaultValues.IdSolicitudNSS, tipoSolicitudNSS=tipoSolicitud, usuarioSol=usuario};
            //string username = solicitudNSS.usuarioSol.IdUsuario;
            //Int32 IdtipoSol = solicitudNSS.tipoSolicitudNSS.IdTipo;

            //NUnit.Framework.Assert.True(true);
        }


        //[Test]
        //[Category("EntityFrameworkData")]
        //public void GetSolicitud()
        //{
        //    SolicitudNSS solicitudNSS = new SolicitudNSS();
        //    SolicitudNSSRepository _RepSolicitudNSS = new SolicitudNSSRepository();

        //    var result = _RepSolicitudNSS.GetSolicitud(0,null,null,0,0,1,15);

        //    foreach (DataRow row in result.Rows) {
        //        Console.WriteLine("Solicitud: " + row[0].ToString() + " - Tipo: " + row[1].ToString() + " - Documento: " + row[6].ToString() + " - Nombre: " + row[7].ToString() +" " + row[8].ToString());
        //    }

        //    NUnit.Framework.Assert.True(true);
        //}
    }
}
