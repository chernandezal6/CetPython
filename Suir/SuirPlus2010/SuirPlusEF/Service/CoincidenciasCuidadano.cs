using SuirPlusEF.Framework;
using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace SuirPlusEF.Service
{
    public class ConincidenciasCuidadano
    {
        public SuirPlusEF.Framework.OracleDbContext db;
        public ConincidenciasCuidadano() {

        }
        public ConincidenciasCuidadano(Ciudadano ciudadano, TipoDocumentoEnum tipoDocumento)
        {

        }

        //public IList<Ciudadano> Procesar(Ciudadano ciu, ref RespuestaSerCoincidenciasCuidadano respuesta) {
        //    Console.WriteLine("Entre a procesar las validaciones para las coincidencias");
        //    db = new OracleDbContext();
        //    List<Ciudadano> coincidenciasEncontradas = new List<Ciudadano>();
        //    ValidacionesAsignacionNSS val = new ValidacionesAsignacionNSS();
        //    if (val.VerificarEstatus("01",1)) {
                
        //        var res = from c in db.Ciudadanos
        //                  where c.NroDocumento == ciu.NroDocumento//c.NombrePadre.StartsWith("LORENZO")
        //                  select c;

        //        Console.WriteLine("COINCIDENCIAS ENCONTRADAS.....   " +  res.Count());
        //        if (res.Count() > 0)
        //        {
        //            foreach (Ciudadano c in res.ToList())
        //            {
        //                Console.WriteLine("este es el apellido del que encontro..." + c.PrimerApellido);
        //                coincidenciasEncontradas.Add(c);
        //            }
        //        }
        //    }

        //    if (val.VerificarEstatus("01", 2))
        //    {
        //        var res = from c in db.Ciudadanos
        //                  where val.limpiarPrimerNombre(c.Nombres) == val.limpiarPrimerNombre(ciu.Nombres) && val.limpiarPrimerApellido(c.PrimerApellido) == val.limpiarPrimerApellido(ciu.PrimerApellido) && 
        //                  val.limpiarFechaNacimiento(c.FechaNacimiento) == val.limpiarFechaNacimiento(ciu.FechaNacimiento) && val.limpiarMunicipio(c.IdMunicipio) == val.limpiarMunicipio(ciu.IdMunicipio) &&
        //                  val.limpiarAno(c.AnoActa) == val.limpiarAno(ciu.AnoActa) && val.limpiarNumero(c.NumeroActa) == val.limpiarNumero(ciu.NumeroActa) && val.limpiarFolio(c.FolioActa) == val.limpiarFolio(ciu.FolioActa) && 
        //                  val.limpiarLibro(c.LibroActa,c.AnoActa) == val.limpiarLibro(ciu.LibroActa,ciu.AnoActa) && val.limpiarOficialia(c.OficialiaActa) == val.limpiarOficialia(ciu.OficialiaActa)
        //                  select c;
        //        if (res.Count() > 0)
        //        {
        //            foreach (Ciudadano c in res.ToList())
        //            {
        //                coincidenciasEncontradas.Add(c);
        //            }
        //        }
        //    }

        //    if (coincidenciasEncontradas.Count() > 0)
        //    {
        //        respuesta = RespuestaSerCoincidenciasCuidadano.SeEncontraronCoincidencias;
        //        return coincidenciasEncontradas;
        //    }
        //    else
        //    {
        //        respuesta = RespuestaSerCoincidenciasCuidadano.NoSeEncontraronCoincidencias;
        //        return null;
        //    }

        //}        
    }

    public enum RespuestaSerCoincidenciasCuidadano {
        SeEncontraronCoincidencias = 1,
        NoSeEncontraronCoincidencias = 2,
        SeEncontroUnaCoincidenciaExacta = 3
    }
}
