 /*
 // Script utilizado por el formulario del IR17 para la realizacion de calculos y formateos de numeros.
 // By Ronny Carreras
 // Created: 19/07/2007
 */
 
 
 //Utilizado para quitar el 0.00 cuandos se hace focus.
 function maskFocus(control)
    {
        if(control.value == "0.00")
            control.value = "";
    }

//Utilizado para colocar el 0.00 si no se coloco ningun valor.    
function maskBlur(control)
{
    if(control.value == "")
    {
        control.value = "0.00";}
    else
    {
       round(control)}        
}


//Funcion utilizada para redondear. toma como parametro el control.
function roundNum(num) 
{ 
  ans = num * 1000 
  ans = Math.round(ans /10) + "" 
  while (ans.length < 3) {ans = "0" + ans} 
  len = ans.length 
  ans = ans.substring(0,len-2) + "." + ans.substring(len-2,len)
  return ans; 
}

//Funcion utilizada para redondear. toma como parametro el control.
function round(control) 
{ 
  ans = control.value * 1000 
  ans = Math.round(ans /10) + "" 
  while (ans.length < 3) {ans = "0" + ans} 
  len = ans.length 
  ans = ans.substring(0,len-2) + "." + ans.substring(len-2,len)
  control.value = ans; 
}

//Verificador que se utiliza para solo permitir numero y punto.
function CheckKeyCode()
{
  if( (event.keyCode == 189 || event.keyCode == 109) ||
      (event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 110) ||
      (event.keyCode >= 48 && event.keyCode <= 57) || 
      (event.keyCode >= 96 && event.keyCode <= 105) ) 
      {return true; }
  else {
    return false;
  }
}

//Wraper de la funcion de formatNumber.
function FormatNum(num)
{
    return FormatNumber(num,2,true,false,true);
}
function FormatNumber(num,decimalNum,bolLeadingZero,bolParens,bolCommas)
/**********************************************************************
	IN:
		NUM - el numero que se va a formatear
		decimalNum - el numero de decimales permitido
		bolLeadingZero - true / false - display a leading zero for
										numbers between -1 and 1
		bolParens - true / false - usa parentesis para numeros negativos.
		bolCommas - usa comma como separador.
 
	RETVAL:
		El numero formateado.
 **********************************************************************/
{ 
        if (isNaN(parseInt(num))) return "NaN";

	var tmpNum = num;
	var iSign = num < 0 ? -1 : 1;		// obtenemos el signo del numero.
	
	// Adjust number so only the specified number of numbers after
	// the decimal point are shown.
	tmpNum *= Math.pow(10,decimalNum);
	tmpNum = Math.round(Math.abs(tmpNum))
	tmpNum /= Math.pow(10,decimalNum);
	tmpNum *= iSign;					// reajustamos el signo.
	
	
	// creamos un string temporal para formatear el numero.
	var tmpNumStr = new String(tmpNum);

	// Verificamos si se desear rellenar de 0.
	if (!bolLeadingZero && num < 1 && num > -1 && num != 0)
		if (num > 0)
			tmpNumStr = tmpNumStr.substring(1,tmpNumStr.length);
		else
			tmpNumStr = "-" + tmpNumStr.substring(2,tmpNumStr.length);
		
	// Verificamos si de desea utilizar coma como separador.
	if (bolCommas && (num >= 1000 || num <= -1000)) {
		var iStart = tmpNumStr.indexOf(".");
		if (iStart < 0)
			iStart = tmpNumStr.length;

		iStart -= 3;
		while (iStart >= 1) {
			tmpNumStr = tmpNumStr.substring(0,iStart) + "," + tmpNumStr.substring(iStart,tmpNumStr.length)
			iStart -= 3;
		}		
	}

	// Verificamos si deseamos usar parentesis.
	if (bolParens && num < 0)
		tmpNumStr = "(" + tmpNumStr.substring(1,tmpNumStr.length) + ")";

	return tmpNumStr;		// retornamos nuestro numero formateado.
}

