using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SuirPlus.Empresas
{
    /// <summary>
    /// Clase para manejar las propiedades del Objecto Empleador
    /// </summary>
    public partial class Empleador
    {
        #region "Miembros y Propiedades Publicas"

        //Atributos de un Empleador
        private string myIdMotivoNoImpresion,
            myMotivoNoImpresion,
            mySectorEconomico,
            myIdActividadEconomica,
            myActividadEconomina,
            myIdRiesgo,
            myFactorRiesgo,
            myIdMunicipio,
            myMunicipio,
            myIdProvincia,
            myProvincia,
            myRncCedula,
            myRazonSocial,
            myNombreComercial,
            myEstatus,
            myCalle,
            myNumero,
            myEdificio,
            myPiso,
            myApartamento,
            mySector,
            myTelefono1,
            myExt1,
            myTelefono2,
            myExt2,
            myFax,
            myEmail,
            myTipoEmpresa,
            myNoPagaIDSS,
            myAdministradoraLocal,
            myPagaInfotep,
            mySectorSalarial,
            myPagoDiscapacidad,
            myTieneAcuerdoPago;

        private int myRegistroPatronal,
            myIdSectorEconomico,
            myIdOficio,
            myCodSector,
            myRutaDistribucion;

        //private int? myIdMotivoCobro = null;

        private bool myTieneMovimientoPendiente,
            myIsCensoCompletado,
            myPermitirPago,
            myCompletoEncuesta,
            myPagaMDT;

        private decimal myDescuentoPenalidad,
            myCapital,
            mySalarioMinimoVigente;

        private DateTime myFechaRegistro,
            myFechaInicioActividades,
            MyFechaConstitucion;

        private StatusCobrosType myStatusCobro;

        //Propiedades Publicas//

        public bool EstaEnLegal
        {
            get
            {
                //if (this.myStatusCobro == StatusCobrosType.Legal && this.IdMotivoCobro == 3)
                if (this.myStatusCobro == StatusCobrosType.Legal)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public bool TieneAcuerdoDePago
        {
            get
            {
                if (this.myTieneAcuerdoPago == "S")
                {
                    return true;

                }
                else {
                    return false;
                }
            }
           
        }




        public string ConAcuerdoDePago
        {
            get
            {
                return this.ConAcuerdoDePago;
            }
            set
            {
                this.ConAcuerdoDePago = value;
            }
        }

        public bool PermitirPago
        {
            get
            {
                return Empleador.PermitePago(myRegistroPatronal);
            }

        }

        public bool CompletoEncuesta
        {
            get
            {
                return this.myCompletoEncuesta;
            }
            set
            {
                this.myCompletoEncuesta = value;
            }
        }

        public string IdProvincia
        {
            get { return myIdProvincia; }
            set { myIdProvincia = value; }
        }

        public string Provincia
        {
            get
            {
                return this.myProvincia;
            }
        }

        public bool isMovimientoPendiente
        {
            get
            {
                return Empleador.ExisteMovimiento(myRegistroPatronal);
            }
        }

        public int RegistroPatronal
        {
            get
            {
                return this.myRegistroPatronal;
            }
        }

        public int IDSectorEconomico
        {
            get
            {
                return this.myIdSectorEconomico;
            }
            set
            {
                this.myIdSectorEconomico = value;
            }
        }

        public int CodSector
        {
            get
            {
                return this.myCodSector;
            }
            set
            {
                this.myCodSector = value;
            }
        }

        public string SectorEconomico
        {
            get
            {
                return this.mySectorEconomico;
            }
        }

        public int IDOficio
        {
            get
            {
                return this.myIdOficio;
            }
            set
            {
                this.myIdOficio = value;
            }
        }

        public int RutaDistribucion
        {
            get
            {
                return this.myRutaDistribucion;
            }
            set
            {
                this.myRutaDistribucion = value;
            }
        }

        public decimal DescuentoPenalidad
        {
            get
            {
                return this.myDescuentoPenalidad;
            }
            set
            {
                this.myDescuentoPenalidad = value;
            }
        }

        public decimal Capital
        {
            get
            {
                return this.myCapital;
            }
            set
            {
                this.myCapital = value;
            }
        }

        public decimal SalarioMinimoVigente
        {
            get
            {
                return this.mySalarioMinimoVigente;
            }
            set
            {
                this.mySalarioMinimoVigente = value;
            }
        }

        public string SectorSalarial
        {
            get
            {
                return this.mySectorSalarial;
            }
            set
            {
                this.mySectorSalarial = value;
            }
        }

        public string FactorRiesgo
        {
            get
            {
                return this.myFactorRiesgo;
            }

        }

        public string IdMotivoNoImpresion
        {
            get { return myIdMotivoNoImpresion; }
            set { myIdMotivoNoImpresion = value; }
        }

        public string MotivoNoImpresion
        {
            get
            {
                return myMotivoNoImpresion;
            }
        }

        public string ActividadEconomica
        {
            get
            {
                return myActividadEconomina;
            }
        }

        public string IDActividadEconomica
        {
            get
            {
                return myIdActividadEconomica;
            }
            set
            {
                myIdActividadEconomica = value;
            }
        }

        public string IDRiesgo
        {
            get
            {
                return myIdRiesgo;
            }
            set
            {
                myIdRiesgo = value;
            }
        }

        public string IDMunicipio
        {
            get
            {
                return myIdMunicipio;
            }
            set
            {
                myIdMunicipio = value;
            }
        }

        public string Municipio
        {
            get
            {
                return myMunicipio;
            }
        }

        public string RNCCedula
        {
            get
            {
                return myRncCedula;
            }
        }

        public string RazonSocial
        {
            get
            {
                return myRazonSocial;
            }
            set { myRazonSocial = value; }

        }

        public string NombreComercial
        {
            get
            {
                return myNombreComercial;
            }
            set
            {
                myNombreComercial = value;
            }
        }

        public string Estatus
        {
            get
            {
                return myEstatus;
            }
            set
            {
                myEstatus = value;
            }
        }

        public string Calle
        {
            get
            {
                return myCalle;
            }
            set
            {
                myCalle = value;
            }
        }

        public string Numero
        {
            get
            {
                return myNumero;
            }
            set
            {
                myNumero = value;
            }
        }

        public string Edificio
        {
            get
            {
                return myEdificio;
            }
            set
            {
                myEdificio = value;
            }
        }

        public string Piso
        {
            get
            {
                return myPiso;
            }
            set
            {
                myPiso = value;
            }
        }

        public string Apartamento
        {
            get
            {
                return myApartamento;
            }
            set
            {
                myApartamento = value;
            }
        }

        public string Sector
        {
            get
            {
                return mySector;
            }
            set
            {
                mySector = value;
            }
        }

        public string Direccion
        {
            get
            {
                return this.Calle + " " + this.Numero + " " + this.Sector;
            }
        }

        public string Telefono1
        {
            get
            {
                return myTelefono1;
            }
            set
            {
                myTelefono1 = value;
            }
        }

        public string Ext1
        {
            get
            {
                return myExt1;
            }
            set
            {
                myExt1 = value;
            }
        }

        public string Telefono2
        {
            get
            {
                return myTelefono2;
            }
            set
            {
                myTelefono2 = value;
            }
        }

        public string Ext2
        {
            get
            {
                return myExt2;
            }
            set
            {
                myExt2 = value;
            }
        }

        public string Fax
        {
            get
            {
                return myFax;
            }
            set
            {
                myFax = value;
            }
        }

        public string Email
        {
            get
            {
                return myEmail;
            }
            set
            {
                myEmail = value;
            }
        }

        public string TipoEmpresa
        {
            get
            {
                return myTipoEmpresa;
            }
            set
            {
                myTipoEmpresa = value;
            }
        }

        public string TipoEmpresaDescripcion
        {
            get
            {
                string tipoEmpresa = string.Empty;
                switch (this.myTipoEmpresa)
                {
                    case "PU":
                        tipoEmpresa = "Pública";
                        break;
                    case "PC":
                        tipoEmpresa = "Pública Centralizada";
                        break;
                    case "PR":
                        tipoEmpresa = "Privada";
                        break;
                    case "PE":
                        tipoEmpresa = "Persona";
                        break;
                }

                return tipoEmpresa;
            }

        }

        public string NoPagaIDSS
        {
            get
            {
                return this.myNoPagaIDSS;
            }
            set
            {
                this.myNoPagaIDSS = value;
            }
        }

        /// <summary>
        /// Propiedad utlizada para verificar si el empleador completo el censo.
        /// </summary>
        public bool isCensoCompletado
        {
            get
            {
                return this.myIsCensoCompletado;
            }
            set
            {
                this.myIsCensoCompletado = value;
            }
        }

        public string AdministradoraLocal
        {
            get
            {
                return this.myAdministradoraLocal;
            }
        }

        public DateTime FechaRegistro
        {
            get
            {
                return myFechaRegistro;
            }
        }

        public DateTime FechaIniciaActividades
        {
            get { return myFechaInicioActividades; }
        }

        public DateTime FechaConstitucion
        {
            get { return MyFechaConstitucion; }
        }

        //public int? IdMotivoCobro
        //{
        //    get { return myIdMotivoCobro; }
        //}

        public StatusCobrosType StatusCobro
        {
            get { return myStatusCobro; }
            set { myStatusCobro = value; }
        }

        public string PagaInfotep
        {
            get { return myPagaInfotep; }
            set { myPagaInfotep = value; }
        }

        public bool PagaMDT
        {
            get
            {
                return this.myPagaMDT;
            }
            set
            {
                this.myPagaMDT = value;
            }
        }


        public string PagoDiscapacidad
        {
            get
            {
                return this.myPagoDiscapacidad;
            }

        }
        # endregion

    }
}
