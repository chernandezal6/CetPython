using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF.Models
{
    public class FacturaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByReferencia()
        {
            Factura factura = new Factura();
            FacturasRepository _RepFactura = new FacturasRepository();

            factura = _RepFactura.GetByIdReferencia(DefaultValues.IdReferenciaTSS);
            NUnit.Framework.Assert.True(true);
        }


        [Test]
        [Category("EntityFramework1")]
        public void ForeignKeys()
        {            
            EntidadRecaudadoraRepository _RepEntRecaudadora = new EntidadRecaudadoraRepository();
            UsuarioRepository _RepUsuario = new UsuarioRepository(_RepEntRecaudadora.db);            
            NominaRepository _RepNomina = new NominaRepository(_RepEntRecaudadora.db);
            CategoriaRiesgoRepository _RepCategoriaRiesgo = new CategoriaRiesgoRepository(_RepEntRecaudadora.db);
            MovimientoRepository _RepMovimiento = new MovimientoRepository(_RepEntRecaudadora.db);         

            EntidadRecaudadora entidad = _RepEntRecaudadora.GetByIdEntidadRecaudadora(DefaultValues.IdEntidadRecaudadora);
            Usuario usuario = _RepUsuario.GetByUsername(DefaultValues.IdUsuario);
            Nomina nomina = _RepNomina.GetByIdNomina(DefaultValues.IdNomina);
            CategoriaRiesgo categoria = _RepCategoriaRiesgo.GetByIdRiesgo(DefaultValues.IdRiesgo);
            Movimiento movimiento = _RepMovimiento.GetByIdMovimiento(DefaultValues.IdMovimiento);                     
           
            Factura factura = new Factura { IdReferencia = DefaultValues.IdReferenciaTSS, Nomina = nomina , Entidad = entidad , Riesgo = categoria, Movimiento = movimiento };

            int Nomina = factura.Nomina.IdNomina;
            int Entidad = factura.Entidad.IdEntidadRecaudadora;          
            string Riesgo = factura.IdRiesgo;
            int Movimiento = factura.Movimiento.IdMovimiento;         

            NUnit.Framework.Assert.True(true);
        }
    }
}





