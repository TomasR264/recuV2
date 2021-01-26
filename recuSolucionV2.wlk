object empresaDeComercializacion{ 
	var registroDeDescargas = []
	
	// Punto 2
	method cobrarDescarga(contenido,usuario){
		if(usuario.puedeDescargar(self.calcularCostoDescarga(contenido,usuario))){
			usuario.descargar(self.calcularCostoDescarga(contenido,usuario))
			self.registrarDescarga(contenido,usuario)
		}
		else{
			self.error("No se puede descargar este contenido")
		}
	}
	
	method calcularCostoDescarga(contenido,usuario) = contenido.montoDerechoAutor() + usuario.costoCompania(contenido) + (contenido.montoDerechoAutor() * 0.25)     
	
	
	// Punto 1
	method conocerPrecioDeDescarga(contenido,usuario) = usuario.calcularCostoSegunPlan(self.calcularCostoDescarga(contenido,usuario))
	
	method registrarDescarga(contenido,usuario){
		registroDeDescargas.add(new Descarga(contenidoDescargado = contenido, usuarioQueDescargo = usuario, fecha = new Date()))
	}
	
	// Punto 3
	method cuantoGastoUnClienteEsteMes(usuario){
		self.descargasDelClienteDeEsteMes(usuario).sum({unaDescarga => unaDescarga.costoDeDescarga()})
	}
	method descargasDelClienteDeEsteMes(usuario) = registroDeDescargas.filter({unaDescarga => unaDescarga.esElMismoCliente(usuario) and unaDescarga.esDeEsteMes()})
	// Punto 4
	method elClienteEsColgado(usuario) = usuario.esColgado()
	// Punto 5
	method elMasDescargadoDeUnaFecha(unaFecha) = self.descargasDeUnaFechaEspecifica(unaFecha).max({unContenido => unContenido.count({unCont => unCont == unContenido})})

    method descargasDeUnaFechaEspecifica(unaFecha) = registroDeDescargas.filter({unaDescarga => unaDescarga.esDeEsaFecha(unaFecha)})
}

// DESCARGAS 

class Descarga{
	const contenidoDescargado
	const usuarioQueDescargo
	const fecha
	
	method esElMismoCliente(usuario) = usuario == usuarioQueDescargo
	
	method esDeEsteMes(){
		const hoy = new Date() 
		return fecha.month() == hoy.month()
	}
	
	method esDeEsaFecha(unaFecha) = unaFecha == fecha
	
	method costoDeDescarga() = empresaDeComercializacion.calcularCostoDescarga(contenidoDescargado,usuarioQueDescargo)
}

 // COMPAÑIAS DE TELECOMUNCIACION

class CompaniaDeTelecomunicacionesNacional{
	method montoCompania(contenido) = contenido.montoDerechoAutor() * 0.05
}

class CompaniaDeTelecomunicacionesExtrangera inherits CompaniaDeTelecomunicacionesNacional{
	const montoCompaniaExtrangera = 15
	
	override method montoCompania(contenido) = super(contenido) + montoCompaniaExtrangera
}


// USUARIOS

class Usuario{
	var plan
	var companiaTelecomunicaciones
	var contenidos = []
	
	method descargar(contenido){
		plan.cobrar(empresaDeComercializacion.calcularCostoDescarga(contenido,self))
		contenidos.add(contenido)
	 }
	method puedeDescargar(monto) = plan.PermiteDescarga(monto)
	
	method calcularCostoSegunPlan(monto) = plan.calcularCosto(monto)
	
	method costoCompania(contenido) = companiaTelecomunicaciones.montoCompania(contenido)
	
	method cambiarDePlan(nuevoPlan){
		plan = nuevoPlan
	}
	
	method esColgado() = contenidos.asSet().size() != contenidos.size()
	
}

// PLANES

class PlanPrepago{
	var saldo
	
	method permiteDescarga(monto){
		return saldo - (monto + (monto * 0.1)) > 0
	}
	method cobrar(monto){
		saldo -= (monto + (monto * 0.1))
	}
	method calcularCosto(monto){
		return (monto + (monto *0.1))
	}
	
}

class PlanFacturado{
	var facturacion
	
	method permiteDescarga(monto){
		return true
	}
	method cobrar(monto){
		facturacion += monto
	}
	method calcularCosto(monto){
		return monto
	}
	
}

// CONTENIDOS


class Ringtone{
	var duracion
	var precioPorMinutoAutor
	
	method montoDerechoAutor() = duracion * precioPorMinutoAutor
}

class Chiste{
	var texto
	const montoFijo = 2
	
	method montoDerechoAutor() = texto.size() * montoFijo
}

class Juego{
	var montoDeterminado
	
	method montoDerechoAutor() = montoDeterminado
}






