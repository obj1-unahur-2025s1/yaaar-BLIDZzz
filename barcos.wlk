class Barco {
    var mision
    const capacidad 

    const tripulacion = []

    method mision() = mision

    method agregarPirata(unPirata) {
        if(mision.estaEnCondiciones(unPirata) and (capacidad>tripulacion.size())){
            tripulacion.add(unPirata)
        }
    }

    method patearA(unPirata) {
        tripulacion.remove(unPirata)
        unPirata.abandonarBarco()
    }

    method sobraUn(unObjeto) {tripulacion.any{x=>x.tiene(unObjeto)}}

    method nuevaMision(unaMision){
        mision = unaMision
        self.echarInutilesMision()
    }

    method echarInutilesMision(){
        self.bancaRota()
        const nuevaTripulacion = self.piratasAptosParaLaMision()
        tripulacion.clear()
        tripulacion.addAll(nuevaTripulacion)
    }

    method bancaRota() {tripulacion.forEach{x=>x.abandonarBarco()}}

    method contratarA(listaPiratas) {listaPiratas.forEach{x=>x.nuevoBarco(self)}}

    method piratasAptosParaLaMision()=tripulacion.filter({x=>mision.estaEnCondiciones(x)})

    method todosPasados() = tripulacion.all({x=>x.estaPasadoDeRon()})

    method esVulnerable(unBarco) = (tripulacion.size().div(2)) <= unBarco.tripulacion().size()

    method seAnimaElPirata(unPirata) = unPirata.estaPasadoDeRon()

    method anclaEn(unaCiudad) {
        self.todosSeTomanUna()
        tripulacion.remove(self.elMasBorracho())
        unaCiudad.agregarHabitante()
    }

    method todosSeTomanUna() {tripulacion.forEach({x=>x.seTomaUna()})}

    method elMasBorracho() = tripulacion.max({x=>x.ronEnSangre()})

    method esTemible() = tripulacion.all({mision.puedeRealizarla(self)})

    method suficientesPiratas() = capacidad*0.9 <= tripulacion.size()
    method cuantosPasados()=tripulacion.count({x=>x.estaPasadoDeRon()})
    method cuantosObjetosDiferetes()=tripulacion.map({x=>x.inventario()}).flatten().asSet().asList().size()
    method borrachoRico()=tripulacion.filter({x=>x.estaPasadoDeRon()}).max({x=>x.monedas()})
    
    method elMasSociable() = self.elQueSeRepiteMas()  // no va

    method elQueSeRepiteMas() = self.losInvitadores().max{x=>tripulacion.map{x=>x.elQueMeInvito()}.occurrencesOf(x)}

    

    method losInvitadores() = tripulacion.map{x=>x.elQueMeInvito()}.asSet()

    method listas(unPirata, ocurrencias) = [unPirata, ocurrencias]

    // [A,B,C].forEach({x=>x})
}

class Ciudad {
    var habitantes

    method habitantes() = habitantes

    method esVulnerable(unBarco) = (habitantes * 0.4) <= unBarco.tripulacion().size() or unBarco.todosPasados()

    method seAnimaElPirata(unPirata) = unPirata.ronEnSangre() >= 50

    method agregarHabitante() {habitantes += 1}
}
///misiones///

class Mision {
    method puedeRealizarla(unBarco) = unBarco.suficientesPiratas()
}
class BusquedaTesoro inherits Mision{
    const objetosRequeridos = ["brujula", "mapa", "grog"]

    method estaEnCondiciones(unPirata) = objetosRequeridos.any({x=>unPirata.tiene(x)}) and unPirata.monedas() <= 5

    override method puedeRealizarla(unBarco) = super(unBarco) and unBarco.sobraUn("llave")
}


class Leyenda inherits Mision{
    const objetosRequeridos 

    method estaEnCondiciones(unPirata) = unPirata.inventario().contains(objetosRequeridos) and unPirata.inventario().size() >=10
}

class Saqueo inherits Mision{
    var victima 

    method estaEnCondiciones(unPirata) = unPirata.monedas() < requisitoSaqueo.monto() and unPirata.seAnimaASaquear(victima)

    override method puedeRealizarla(unBarco) = super(unBarco) and victima.esVulnerable(unBarco)
}

object requisitoSaqueo {
    var property monto = 10
}

//pirataa///

class Pirata {
    var elQueMeInvito

    var barco

    var property monedas = 40

    var property ronEnSangre = 10

    const inventario

    method inventario() = inventario

    method tiene(unObjeto) = inventario.contains(unObjeto)

    method seAnimaASaquear(unaVictima) = unaVictima.seAnimaElPirata(self)

    method estaPasadoDeRon() = ronEnSangre >= 90

    method puedeCumpiMision(unaMision)=unaMision.estaEnCondiciones(self)

    method seTomaUna(){
        self.ronEnSangre(ronEnSangre + 5)
        self.monedas((monedas - 1).max(0))
    }

    method invitarA(unPirata) = unPirata.meInvito(self)

    method meInvito(unPirata){
        elQueMeInvito = unPirata
        barco
    }

    method nuevoBarco(unBarco) {barco = unBarco}

    method abandonarBarco() {barco = null}
    
    method elQueMeInvito() = elQueMeInvito
}


class Espia inherits Pirata{


override  method estaPasadoDeRon() =false 

override method seAnimaASaquear(unaVictima) = super(unaVictima) and inventario.contains("permiso de la corona")

}

