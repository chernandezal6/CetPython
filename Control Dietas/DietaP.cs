using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Control_Dietas
{
   public class DietaP
    {
        private const int DESAYUNO_MAX_MINS =451;
        private const int ALMUERZO_MIN_MINS = 781;
        private const int CENA_MIN_MINS =1141;
        
        public List<Day> Days { get; set; }
        public float AsignacionDiaria { get; set; }
        public int DietaCod { get; set; }
        public DateTime Fecha { get; set; }
        public DateTime Salida { get; set; }
        public DateTime Retorno { get; set; }
        public float TotalCobrar { get; set; }
        public string LugarVisitado { get; set; }
        public empleados Empleado { get; set; }
        public Categoria cat { get; set; }
        public String   Actividad { get; set; }

        public DietaP()
        {
            Days = new List<Day>();
        }
        public void CreateDietaFromValues()
        {
            
            for(int i =1; i<=DateTime.DaysInMonth(Salida.Year,Salida.Month); i++)
            {
                if (i == 0)
                    continue;
                Day d = new Day() { Date = new DateTime(Salida.Year, Salida.Month, i) };
                if (i == Salida.Day || i<=Retorno.Day)
                {
                   
                    //////////Verificamos si es el dia de salida
                    if (Salida.Date == d.Date)
                    {
                        d.Date = Salida;
                        d.LugarVisitado = Actividad;
                        //////////////Verificamos si le toca desayuno
                        if (getElapsedMins(d.Date)< DESAYUNO_MAX_MINS)
                        {
                            d.Desayuno = true;
                        }
                        else
                        {
                            d.Desayuno = false;
                        }
                        if (d.Desayuno == true || getElapsedMins(Retorno) > ALMUERZO_MIN_MINS || Salida.Date<Retorno.Date)
                        {
                            d.Almuerzo = true;
                        }
                        else
                        {
                            d.Almuerzo = false;
                        }
                        if (getElapsedMins(Retorno) > CENA_MIN_MINS || Salida.Date < Retorno.Date)
                        {
                            d.Cena = true;
                        }
                        else
                        {
                            d.Cena = false;
                        }
                        //verificamos la fecha de retorno para otorgar Alojamiento
                        if (Salida.Date != Retorno.Date )
                        {
                            d.Alojamiento = true;
                        }
                        else
                        {
                            d.Alojamiento = false;
                        }
                    }
                    if(d.Date.Day>Salida.Date.Day && d.Date.Day < Retorno.Date.Day)
                    {
                        d.LugarVisitado = Actividad;
                        d.Desayuno = true;
                        d.Almuerzo = true;
                        d.Cena = true;
                        d.Alojamiento = true;
                    }
                   if(Retorno.Date == d.Date)
                    {
                        d.LugarVisitado = Actividad;
                        d.Desayuno = true;
                        if(getElapsedMins(Retorno)>ALMUERZO_MIN_MINS)
                        {
                            d.Almuerzo = true;
                        }
                        else
                        {
                            d.Almuerzo = false;
                        }
                        if (getElapsedMins(Retorno) > CENA_MIN_MINS)
                        {
                            d.Cena = true;
                        }
                        else
                        {
                            d.Cena = false;
                        }
                        d.Alojamiento = false;
                    }
                }
                  SetCobro(d,cat);
                
                Days.Add(d);
            }
            
        }
        private void SetCobro(Day day,Categoria cat)
        {
            day.Cobrar = 0;
            if (day.Desayuno)
            {
                day.Cobrar += (float)cat.Desayuno;
            }
            if (day.Almuerzo)
            {
                day.Cobrar += (float)cat.Almuerzo;
            }
            if (day.Cena)
            {
                day.Cobrar += (float)cat.Cena;
            }
            if (day.Alojamiento)
            {
                day.Cobrar += (float)cat.Alojamiento;
            }
        }
        private int getElapsedMins(DateTime entity)
        {
            int mins = 0;
            mins = (entity.Hour * 60) + entity.Minute;
            return mins;
        }
        public DietaP GetDietaPrint()
        {
            return this;
        }
    }
}
