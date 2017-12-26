using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class CiudadanoRepository : Framework.BaseObject<Models.Ciudadano>, Framework.IBaseRepository<Models.Ciudadano>
    {

        public CiudadanoRepository() : base() { }
        public CiudadanoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Ciudadano GetById(int id)
        {
            throw new NotImplementedException();
        }

        public Ciudadano GetCiudadano(string  documento, string tipodoc)
        {
            return db.Ciudadanos.FirstOrDefault(x => x.NroDocumento == documento && x.TipoDocumento == tipodoc);
        }


        public Ciudadano GetByNroDocumento(string NroDocumento, string Tipo, ref int existe) {
            existe = db.Ciudadanos.Count(y => y.NroDocumento == NroDocumento && y.TipoDocumento==Tipo);
            if (existe > 0)
            {
                var ciu = db.Ciudadanos.FirstOrDefault(x => x.NroDocumento == NroDocumento && x.TipoDocumento == Tipo);
                return ciu;
            }
            else {
                return null;
            }
        }

        public Ciudadano GetByNSS(int? IdNSS)
        {
            return db.Ciudadanos.FirstOrDefault(x => x.IdNSS == IdNSS);
        }
        
        public Ciudadano Insertar(ref Ciudadano ciudadano) {
            //generamos
            NumeroSeguridadSocial nss = new NumeroSeguridadSocial();
            DocumentoNSS docNSS = nss.Crear(ciudadano.TipoDocumento);
            
            ciudadano.IdNSS= Convert.ToInt32(docNSS.NumeroSinGuiones());

            //limpiar los datos del acta para insertar data
            //considerar que el nombre, primer apellido, fechanacimiento(esta fecha no puede ser mayor que sysdate) y sexo son requeridos
            //si no viene uno de estos datos se rechaza con el error 441


            //Grabar en la BD
            this.AddNoSequence(ciudadano);
            Console.WriteLine("ya insertamos el ciudadanos correctamente...");
            return ciudadano;
        }

        public void Actualizar(Ciudadano existente, ref Ciudadano nuevo) {

            // etc
            existente.Nombres = nuevo.Nombres;
            //etc

            this.Update(existente);

        }
    }
}
